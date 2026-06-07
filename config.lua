Config = {}

Config.Dev = {
	Enabled = false,
}

Config.Hud = {
	ToggleKey = 'U',
	FailNotifyDuration = 12000,
	ErrorNotifyCooldown = 8000,
}

Config.Priser = {
	dmv         = 500,
	drive       = 2500,
	drive_bike  = 3000,
	drive_truck = 5000
}

Config.Hansen = {
	Location = vector4(240.9351, -1379.14, 32.74178, 139.9268),
	Model = 'a_m_m_business_01',
	Scenario = 'WORLD_HUMAN_CLIPBOARD',
	Name = 'Kørelærer Hansen',
	TargetLabel = 'Tal med kørelæreren',
	BlipLabel = 'Køreskole',
}

Config.Test = {
	MarkerDistance = 10.0,
	MaxErrors = 5,
	SpeedMultiplier = 3.6,
	SpeedingErrorDelay = 5000,
	SpawnClearRadius = 2.75,
	SpawnPoints = {
		vector4(243.5221, -1415.6520, 30.4086, 325.4341),
		vector4(240.6742, -1413.3357, 30.4086, 327.1406),
	},
	VehicleModels = {
		drive       = 'blista',
		drive_bike  = 'sanchez',
		drive_truck = 'mule3'
	},
	SpeedLimits = {
		residence = 80,
		town      = 50,
		freeway   = 130
	},
	CheckPoints = {
		{
			Position = {x = 255.139, y = -1400.731, z = 29.537},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText(('Hansen: Velkommen til køreprøven. Kør roligt mod markeringen - her er grænsen %s km/t.'):format(Config.Test.SpeedLimits['residence']), 5000)
			end
		},
		{
			Position = {x = 271.874, y = -1370.574, z = 30.932},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Fint holdt. Fortsæt ad ruten i et roligt tempo.', 5000)
			end
		},
		{
			Position = {x = 234.907, y = -1345.385, z = 29.542},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				CreateThread(function()
					DrawMissionText('Hansen: Fodgængerfelt forude - fuldt stop, og kig begge veje.', 5000)
					PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
					FreezeEntityPosition(vehicle, true)
					Wait(4000)
					FreezeEntityPosition(vehicle, false)
					DrawMissionText('Hansen: Godt set. Du må køre videre.', 5000)
				end)
			end
		},
		{
			Position = {x = 217.821, y = -1410.520, z = 28.292},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				setCurrentZoneType('town')
				CreateThread(function()
					DrawMissionText(('Hansen: Vi kører ind i tæt bebyggelse. Hastighedsgrænse %s km/t - stop ved hovedvejen.'):format(Config.Test.SpeedLimits['town']), 5000)
					PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
					FreezeEntityPosition(vehicle, true)
					Wait(6000)
					FreezeEntityPosition(vehicle, false)
					DrawMissionText('Hansen: Pænt gennemført. Drej til højre og hold din vognbane.', 5000)
				end)
			end
		},
		{
			Position = {x = 178.550, y = -1401.755, z = 27.725},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Tjek spejle og blindvinkler - og husk at bruge blinklys.', 5000)
			end
		},
		{
			Position = {x = 113.160, y = -1365.276, z = 27.725},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Hold afstand til forankørende. Fortsæt mod næste markering.', 5000)
			end
		},
		{
			Position = {x = -73.542, y = -1364.335, z = 27.789},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Vigepligt forude - vent til det er frit, før du kører.', 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
				FreezeEntityPosition(vehicle, true)
				Wait(6000)
				FreezeEntityPosition(vehicle, false)
			end
		},
		{
			Position = {x = -355.143, y = -1420.282, z = 27.868},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Rolig kurve forude. Kig langt frem i vejen.', 5000)
			end
		},
		{
			Position = {x = -439.148, y = -1417.100, z = 27.704},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Godt kørt indtil videre. Vi skal snart ud på motorvejen.', 5000)
			end
		},
		{
			Position = {x = -453.790, y = -1444.726, z = 27.665},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				setCurrentZoneType('freeway')
				DrawMissionText(('Hansen: Nu på motorvejen. Maks %s km/t - flet ind i trafikken roligt.'):format(Config.Test.SpeedLimits['freeway']), 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			end
		},
		{
			Position = {x = -463.237, y = -1592.178, z = 37.519},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Hold dig i højre spor, medmindre du skal overhale.', 5000)
			end
		},
		{
			Position = {x = -900.647, y = -1986.28, z = 26.109},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Stadig på motorvejen - hold jævn hastighed og afstand.', 5000)
			end
		},
		{
			Position = {x = 1225.759, y = -1948.792, z = 38.718},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Vi forlader snart motorvejen. Forbered dig på at sætte farten ned.', 5000)
			end
		},
		{
			Position = {x = 1225.759, y = -1948.792, z = 38.718},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				setCurrentZoneType('town')
				DrawMissionText(('Hansen: Byzone igen. Grænsen er %s km/t - pas på cyklister og parkerede biler.'):format(Config.Test.SpeedLimits['town']), 5000)
			end
		},
		{
			Position = {x = 1163.603, y = -1841.771, z = 35.679},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				DrawMissionText('Hansen: Du kører pænt. Husk: spejle, blinklys og ro i hovedet hele vejen hjem.', 5000)
				PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', false, 0, true)
			end
		},
		{
			Position = {x = 235.283, y = -1398.329, z = 28.921},
			Action = function(playerPed, vehicle, setCurrentZoneType)
				CleanupDriveTestVehicle(vehicle)
			end
		}
	}
}
