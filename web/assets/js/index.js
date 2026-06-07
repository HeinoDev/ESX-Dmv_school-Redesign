var questionNumber = 1;
var userAnswer = [];
var goodAnswer = [];
var questionUsed = [];
var nbQuestionToAnswer = 5;
var nbAnswerNeeded = 1;
var nbPossibleQuestions = 0;
var animationDuration = 350;
var themeStorageKey = 'dmvschool-theme';

function postNui(event, data) {
	$.post('https://' + GetParentResourceName() + '/' + event, JSON.stringify(data || {}));
}

function getRandomQuestion() {
	var random = Math.floor(Math.random() * nbPossibleQuestions);

	while (questionUsed.indexOf(random) !== -1) {
		random = Math.floor(Math.random() * nbPossibleQuestions);
	}

	questionUsed.push(random);
	return random;
}

function applyTheme(theme) {
	document.documentElement.setAttribute('data-theme', theme);
	localStorage.setItem(themeStorageKey, theme);
	var isDark = theme === 'dark';
	$('#theme-toggle').prop('checked', isDark);
	$('#theme-hint-icon').attr('class', 'fa-solid ' + (isDark ? 'fa-moon' : 'fa-sun'));
	$('#theme-toggle-label').text(isDark ? 'Mørk' : 'Lys');
}

function toggleTheme() {
	var current = document.documentElement.getAttribute('data-theme') || 'light';
	applyTheme(current === 'light' ? 'dark' : 'light');
}

function initTheme() {
	var saved = localStorage.getItem(themeStorageKey);
	applyTheme(saved === 'dark' ? 'dark' : 'light');
}

function closeMain() {
	$('.dmv-home').css('display', 'none');
}

function openMain() {
	$('.dmv-home').css('display', 'flex');
}

function closeAll() {
	$('.dmv-section').css('display', 'none');
}

function showSection(selector) {
	$(selector).css('display', 'flex');
}

function initQuizSettings() {
	nbPossibleQuestions = tableauQuestion.length;
	$('.dmv-progress-bar').attr('max', nbQuestionToAnswer);
	initProgressMarkers();
}

var driveHudTotal = 0;
var driveHudMaxErrors = 5;

function initProgressMarkers() {
	var markerInterval = 5;

	$('.dmv-progress-markers').not('#drive-progress-markers').each(function () {
		var $markers = $(this);
		$markers.empty();

		for (var i = markerInterval; i <= nbQuestionToAnswer; i += markerInterval) {
			var pct = (i / nbQuestionToAnswer) * 100;
			var $marker = $('<span class="dmv-progress-marker"></span>');

			if (i === nbAnswerNeeded) {
				$marker.addClass('dmv-progress-marker--pass');
			}

			$marker.css('left', pct + '%');
			$markers.append($marker);
		}
	});
}

function updateProgress(value) {
	var $section = $('.dmv-section:visible');
	$section.find('.dmv-progress-bar').attr('max', nbQuestionToAnswer).val(value);
	$section.find('.dmv-progress-count').text(value + ' / ' + nbQuestionToAnswer);
}

function openQuestionnaire() {
	showSection('.dmv-questionnaire');
	var randomQuestion = getRandomQuestion();

	$('#questionNumero').text('Spørgsmål ' + questionNumber + ' af ' + nbQuestionToAnswer);
	$('#question').html(tableauQuestion[randomQuestion].question);
	$('.answerA').html(tableauQuestion[randomQuestion].mulighedA);
	$('.answerB').html(tableauQuestion[randomQuestion].mulighedB);
	$('.answerC').html(tableauQuestion[randomQuestion].mulighedC);
	$('.answerD').html(tableauQuestion[randomQuestion].mulighedD);
	$('input[name=question]').prop('checked', false);

	goodAnswer.push(tableauQuestion[randomQuestion].svar);
	updateProgress(questionNumber - 1);
}

function openResultGood(score) {
	showSection('.dmv-result-pass');
	$('.dmv-result-pass .dmv-progress-bar').val(nbQuestionToAnswer);
	$('.dmv-result-pass .dmv-progress-count').text(score + ' / ' + nbQuestionToAnswer);
	$('.dmv-result-pass .dmv-result-text').text(
		'Du har ' + score + ' rigtige ud af ' + nbQuestionToAnswer + '. Gå ud til Hansen og book din praktiske køreprøve, når du er klar.'
	);
}

function openResultBad(score) {
	showSection('.dmv-result-fail');
	$('.dmv-result-fail .dmv-progress-bar').val(nbQuestionToAnswer);
	$('.dmv-result-fail .dmv-progress-count').text(score + ' / ' + nbQuestionToAnswer);
	$('.dmv-result-fail .dmv-result-text').text(
		'Du havde ' + score + ' rigtige. For at bestå skal du have mindst ' + nbAnswerNeeded + ' rigtige ud af ' + nbQuestionToAnswer + ' (højst ' + (nbQuestionToAnswer - nbAnswerNeeded) + ' fejl).'
	);
}

function openContainer() {
	var $overlay = $('.dmv-overlay');
	var $panel = $('.dmv-panel');

	$overlay.css('display', 'flex');
	$panel.css('display', 'flex');

	requestAnimationFrame(function () {
		$overlay.addClass('ui-open').removeClass('ui-closing');
		$panel.addClass('ui-open').removeClass('ui-closing');
	});
}

function closeContainer() {
	var $overlay = $('.dmv-overlay');
	var $panel = $('.dmv-panel');

	$overlay.removeClass('ui-open').addClass('ui-closing');
	$panel.removeClass('ui-open').addClass('ui-closing');

	setTimeout(function () {
		$overlay.css('display', 'none').removeClass('ui-closing');
		$panel.css('display', 'none').removeClass('ui-closing');
	}, animationDuration);
}

function resetQuiz() {
	userAnswer = [];
	goodAnswer = [];
	questionUsed = [];
	questionNumber = 1;
	updateProgress(0);
}

function initDriveHudMarkers(total) {
	var $markers = $('#drive-progress-markers');
	var markerInterval = Math.max(1, Math.round(total / 4));

	$markers.empty();

	for (var i = markerInterval; i < total; i += markerInterval) {
		var pct = (i / total) * 100;
		var $marker = $('<span class="dmv-progress-marker"></span>');
		$marker.css('left', pct + '%');
		$markers.append($marker);
	}
}

function applyDriveHudState(data) {
	var failed = data.failed === true;

	$('#drive-hud').toggleClass('is-failed', failed);
	$('#drive-hud-failed').prop('hidden', !failed);

	if (failed) {
		$('#drive-hud-hint').text('Kør tilbage til køreskolen for at afslutte prøven.');
	} else {
		$('#drive-hud-hint').text('Max fejl før prøven ikke bestås');
	}

	$('#drive-hud-dev').prop('hidden', data.debugMode !== true);

	if (data.toggleKey) {
		$('#drive-hud-key').text(data.toggleKey);
	}
}

function updateDriveHud(data) {
	var checkpoint = data.checkpoint || 0;
	var total = data.total || 1;
	var errors = data.errors || 0;
	var maxErrors = data.maxErrors || driveHudMaxErrors;

	driveHudTotal = total;
	driveHudMaxErrors = maxErrors;

	$('#drive-progress-bar').attr('max', total).val(checkpoint);
	$('#drive-progress-count').text(checkpoint + ' / ' + total);
	$('#drive-errors-count').text(errors + ' / ' + maxErrors);

	var $errors = $('#drive-errors-count');
	$errors.removeClass('is-warning is-danger');

	if (data.failed === true) {
		$errors.addClass('is-danger');
	} else if (errors >= Math.max(1, maxErrors - 1)) {
		$errors.addClass('is-warning');
	}

	applyDriveHudState(data);
}

function showDriveHud(data) {
	initDriveHudMarkers(data.total || 1);
	updateDriveHud(data);

	var $hud = $('#drive-hud');
	$hud.removeClass('is-closing');
	$hud.attr('aria-hidden', 'false');

	if (data.expanded) {
		$hud.addClass('is-expanded');
	} else {
		$hud.removeClass('is-expanded');
	}

	requestAnimationFrame(function () {
		$hud.addClass('is-visible');
	});
}

function hideDriveHud() {
	var $hud = $('#drive-hud');

	if (!$hud.hasClass('is-visible') && !$hud.hasClass('is-closing')) {
		return;
	}

	$hud.removeClass('is-visible is-expanded is-failed').addClass('is-closing');
	$('#drive-hud-failed').prop('hidden', true);
	$('#drive-hud-dev').prop('hidden', true);
	$('#drive-hud-icon').attr('class', 'fa-solid fa-route');
	$('#drive-hud-title').text('Køreprøve');
	$('#drive-hud-hint').text('Max fejl før prøven ikke bestås');

	setTimeout(function () {
		$hud.removeClass('is-closing');
		$hud.attr('aria-hidden', 'true');
	}, animationDuration);
}

function toggleDriveHud() {
	$('#drive-hud').toggleClass('is-expanded');
}

var missionTextTimer = null;

function showMissionText(data) {
	var $mission = $('#mission-text');

	$('#mission-text-instructor').text(data.instructor || 'Kørelærer Hansen');
	$('#mission-text-message').text(data.message || '');

	$mission.attr('aria-hidden', 'false');
	$mission.addClass('is-visible');

	if (missionTextTimer) {
		clearTimeout(missionTextTimer);
	}

	missionTextTimer = setTimeout(function () {
		hideMissionText();
	}, data.duration || 5000);
}

function hideMissionText() {
	var $mission = $('#mission-text');

	$mission.removeClass('is-visible');
	$mission.attr('aria-hidden', 'true');

	if (missionTextTimer) {
		clearTimeout(missionTextTimer);
		missionTextTimer = null;
	}
}

window.addEventListener('message', function (event) {
	var item = event.data;

	if (item.driveHud === 'show') {
		showDriveHud(item);
	}

	if (item.driveHud === 'hide') {
		hideDriveHud();
	}

	if (item.driveHud === 'update') {
		updateDriveHud(item);
	}

	if (item.driveHud === 'toggle') {
		toggleDriveHud();
	}

	if (item.driveHud === 'expand') {
		$('#drive-hud').addClass('is-expanded');
	}

	if (item.missionText === 'show') {
		showMissionText(item);
	}

	if (item.missionText === 'hide') {
		hideMissionText();
	}

	if (item.openQuestion === true) {
		openContainer();
		openMain();
		updateProgress(0);
	}

	if (item.openQuestion === false) {
		closeContainer();
		closeAll();
		resetQuiz();
	}

	if (item.openSection === 'question') {
		closeAll();
		openQuestionnaire();
	}
});

$(function () {
	initQuizSettings();
	initTheme();

	$('#theme-toggle').on('change', toggleTheme);

	$('.theme-toggle-hint').on('click', function () {
		toggleTheme();
	});

	$('.btn-start, .btn-pass-close, .btn-fail-close').on('click', function (e) {
		e.preventDefault();
	});

	$('.btn-start').on('click', function () {
		postNui('question');
	});

	$('.btn-pass-close').on('click', function () {
		postNui('close');
		resetQuiz();
	});

	$('.btn-fail-close').on('click', function () {
		postNui('kick');
		resetQuiz();
	});

	$('#question-form').on('submit', function (e) {
		e.preventDefault();

		var selected = $('input[name="question"]:checked').val();
		if (!selected) {
			return false;
		}

		userAnswer.push(selected);

		if (questionNumber !== nbQuestionToAnswer) {
			closeAll();
			questionNumber++;
			openQuestionnaire();
		} else {
			var nbGoodAnswer = 0;

			for (var i = 0; i < nbQuestionToAnswer; i++) {
				if (userAnswer[i] === goodAnswer[i]) {
					nbGoodAnswer++;
				}
			}

			closeAll();
			if (nbGoodAnswer >= nbAnswerNeeded) {
				openResultGood(nbGoodAnswer);
			} else {
				openResultBad(nbGoodAnswer);
			}
		}

		return false;
	});
});
