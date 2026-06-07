var tableauQuestion = [
	{
		question: "Du nærmer dig en rundkørsel. En bil er allerede inde i rundkørslen og kommer fra venstre. Hvad gør du?",
		mulighedA: "Kører ind, fordi du har forkørselsret",
		mulighedB: "Venter og viger for trafikken i rundkørslen",
		mulighedC: "Tuter og kører ind for at markere din tur",
		mulighedD: "Kører ind, hvis du blinker til højre",
		svar: "B"
	},
	{
		question: "Hvad er den almindelige hastighedsgrænse i tætbebyggede områder, hvis der ikke er opsat skilt?",
		mulighedA: "40 km/t",
		mulighedB: "50 km/t",
		mulighedC: "60 km/t",
		mulighedD: "80 km/t",
		svar: "B"
	},
	{
		question: "Du kører på en landevej uden hastighedsskilt. Hvad er den normale grænse for personbiler?",
		mulighedA: "70 km/t",
		mulighedB: "80 km/t",
		mulighedC: "90 km/t",
		mulighedD: "110 km/t",
		svar: "B"
	},
	{
		question: "Hvad er den lovlige promillegrænse for bilkørsel i Danmark?",
		mulighedA: "0,2‰",
		mulighedB: "0,5‰",
		mulighedC: "0,8‰",
		mulighedD: "1,0‰",
		svar: "B"
	},
	{
		question: "Du standser ved et stopskilt, hvor der er fri udsigt og ingen trafik. Hvad er korrekt?",
		mulighedA: "Du må sænke farten og rulle videre",
		mulighedB: "Du skal stoppe helt og sikre dig, at det er frit, før du kører",
		mulighedC: "Stopskilt gælder kun, når der er andre køretøjer",
		mulighedD: "Du må køre videre, hvis du blinker",
		svar: "B"
	},
	{
		question: "To biler mødes i et kryds uden skilte. Hvem har vigepligt?",
		mulighedA: "Bilen fra venstre",
		mulighedB: "Bilen fra højre (højre håndsregel)",
		mulighedC: "Den hurtigste bil",
		mulighedD: "Den største bil",
		svar: "B"
	},
	{
		question: "Du kører på motorvejen i højre spor. Må du overhale en anden bil ved at køre i højre side af den?",
		mulighedA: "Ja, hvis den anden bil kører langsomt",
		mulighedB: "Ja, hvis du blinker",
		mulighedC: "Nej, overhaling skal som udgangspunkt ske til venstre",
		mulighedD: "Ja, hvis der er to spor i samme retning",
		svar: "C"
	},
	{
		question: "Hvad betyder en gul, blinkende trafiklampe i et vejkryds?",
		mulighedA: "Du skal stoppe og vente på grønt",
		mulighedB: "Du har ubetinget forkørselsret",
		mulighedC: "Du skal sænke farten og være særligt opmærksom",
		mulighedD: "Lyset er ude af drift, og alle skal stoppe",
		svar: "C"
	},
	{
		question: "Du kører 50 km/t og nærmer dig et lyskryds, der skifter fra grønt til gult. Hvad bør du gøre?",
		mulighedA: "Accelerere for at nå over, før det bliver rødt",
		mulighedB: "Stoppe, hvis det kan ske sikkert uden hård opbremsning",
		mulighedC: "Altid køre videre, fordi gult betyder fri passage",
		mulighedD: "Blinke med fjernlys og fortsætte",
		svar: "B"
	},
	{
		question: "Hvornår må du bruge hornet under kørsel?",
		mulighedA: "Når du vil hilse på en ven",
		mulighedB: "Når en bil foran dig kører for langsomt",
		mulighedC: "Kun for at advare andre trafikanter om fare",
		mulighedD: "Når du kører forbi en skole om aftenen",
		svar: "C"
	},
	{
		question: "Du skal dreje til venstre i et lyskryds. En modkørende bil kører ligeud. Hvem har vigepligt?",
		mulighedA: "Du, der drejer til venstre",
		mulighedB: "Den modkørende bil",
		mulighedC: "Den bil, der kommer først til krydset",
		mulighedD: "Ingen, hvis lyset er grønt for begge",
		svar: "A"
	},
	{
		question: "Hvad er minimumskravet til dækdybde på sommerdæk i Danmark?",
		mulighedA: "0,8 mm",
		mulighedB: "1,0 mm",
		mulighedC: "1,6 mm",
		mulighedD: "3,0 mm",
		svar: "C"
	},
	{
		question: "Du kører på motorvejen, og bilen får motorstop. Hvad er det rigtige at gøre først?",
		mulighedA: "Stoppe midt i kørebanen og tænde advarselsblink",
		mulighedB: "Køre så langt til højre som muligt og stoppe på nødsporet eller vejsiden",
		mulighedC: "Forlade bilen og gå tilbage ad kørebanen",
		mulighedD: "Ringe til en ven og vente i bilen midt på vejen",
		svar: "B"
	},
	{
		question: "Du har stoppet på motorvejen efter et nedbrud. Hvor bør du opholde dig?",
		mulighedA: "På kørebanen bag bilen for at dirigere trafik",
		mulighedB: "I bilen med sikkerhedsselen på",
		mulighedC: "Bag autoværnet eller uden for kørebanen med advarselsvest på",
		mulighedD: "Foran bilen, så du kan se trafikken",
		svar: "C"
	},
	{
		question: "Må du bruge håndholdt mobiltelefon under kørsel?",
		mulighedA: "Ja, hvis du holder den med venstre hånd",
		mulighedB: "Ja, ved lav hastighed under 30 km/t",
		mulighedC: "Ja, hvis du kun skriver en kort besked",
		mulighedD: "Nej, håndholdt brug er forbudt under kørsel",
		svar: "D"
	},
	{
		question: "Et barn under 135 cm skal køre i bil. Hvordan skal barnet sikres?",
		mulighedA: "Med almindelig sikkerhedssele, hvis barnet sidder foran",
		mulighedB: "Med godkendt barnestol eller selepude efter barnets størrelse",
		mulighedC: "Kun hvis barnet sidder på bagsædet uden sele",
		mulighedD: "Det er op til forældrene uden særlige krav",
		svar: "B"
	},
	{
		question: "Du nærmer dig et fodgængerfelt, og en fodgænger er ved at gå ud. Hvad gør du?",
		mulighedA: "Kører videre, hvis fodgængeren ikke er på vejen endnu",
		mulighedB: "Tuter for at få fodgængeren til at skynde sig",
		mulighedC: "Stopper og lader fodgængeren passere",
		mulighedD: "Kører langsomt forbi uden at stoppe",
		svar: "C"
	},
	{
		question: "Du kører i tåge med meget dårlig sigtbarhed. Hvilket lys er korrekt at bruge?",
		mulighedA: "Kun parkeringslys",
		mulighedB: "Nærlys og eventuelt tågeforlygter; bagtågelys kun ved meget tæt tåge",
		mulighedC: "Konstant fjernlys for bedre udsyn",
		mulighedD: "Sluk alle lys for ikke at blænde andre",
		svar: "B"
	},
	{
		question: "En ambulance nærmer sig bagfra med sirene og blink. Hvad gør du?",
		mulighedA: "Øger farten for at komme væk",
		mulighedB: "Fortsætter uændret, hvis du holder hastighedsgrænsen",
		mulighedC: "Giver fri passage ved at holde ind og stoppe om nødvendigt",
		mulighedD: "Stopper midt i et vejkryds for at vise hensyn",
		svar: "C"
	},
	{
		question: "Du skal parkere ved et vejkryds. Hvor tæt på krydset må du som udgangspunkt parkere?",
		mulighedA: "Lige ved stoplinjen, hvis der er plads",
		mulighedB: "Mindst 10 meter fra kørebanens nærmeste kant",
		mulighedC: "Mindst 3 meter fra kørebanens nærmeste kant",
		mulighedD: "Der er ingen afstandskrav i byzone",
		svar: "B"
	},
	{
		question: "Hvad betyder en heltrukken hvid stribe midt på vejen?",
		mulighedA: "Du må gerne overhale, hvis der er god udsigt",
		mulighedB: "Du må ikke køre over eller krydse striben til overhaling",
		mulighedC: "Striben viser kun en anbefalet kørebane",
		mulighedD: "Den gælder kun for lastbiler",
		svar: "B"
	},
	{
		question: "Du kører på cykelsti parallelt med vejen og skal dreje til venstre over vejen. Hvad er korrekt?",
		mulighedA: "Du har altid forkørselsret over biler",
		mulighedB: "Du skal vige for køretøjer på vejen, medmindre andet er skiltet",
		mulighedC: "Du skal altid stoppe midt i vejen og vinkke",
		mulighedD: "Biler skal altid stoppe for cyklister uanset situation",
		svar: "B"
	},
	{
		question: "En bus ved et busstoppested tænder blinklys og begynder at køre ud. Hvad gør du som udgangspunkt?",
		mulighedA: "Accelererer for at komme forbi før bussen",
		mulighedB: "Tuter og holder din bane",
		mulighedC: "Sænker farten og viger, så bussen kan køre ind i trafikken",
		mulighedD: "Kører tæt bag bussen for at forhindre indkørsel",
		svar: "C"
	},
	{
		question: "Du har drukket alkohol og er i tvivl om, hvorvidt du er under grænsen. Hvad er det sikreste valg?",
		mulighedA: "Køre en kort tur hjem ad små veje",
		mulighedB: "Køre langsomt og undgå motorvejen",
		mulighedC: "Lade bilen stå og finde en anden transport",
		mulighedD: "Tage en kop kaffe og køre med det samme",
		svar: "C"
	},
	{
		question: "Hvad er formålet med 3-sekunders reglen i trafikken?",
		mulighedA: "At holde mindst 3 sekunders afstand til forankørende ved normal kørsel",
		mulighedB: "At vente 3 sekunder ved stoplinjen efter rødt lys",
		mulighedC: "At kigge i spejlet hvert 3. sekund",
		mulighedD: "At holde 3 meters afstand i byzone",
		svar: "A"
	},
	{
		question: "Du kører på en vej med ensrettet trafik og ser en bil modkørende i din bane. Hvad gør du?",
		mulighedA: "Blinker og forsøger at køre forbi til højre",
		mulighedB: "Sænker farten, giver tegn og stopper om nødvendigt for at undgå sammenstød",
		mulighedC: "Tuter og holder kursen, fordi du har ret",
		mulighedD: "Accelererer for at komme forbi hurtigt",
		svar: "B"
	},
	{
		question: "Hvornår skal du som bilist særligt være opmærksom på svingende døre og gående nær parkerede biler?",
		mulighedA: "Kun på motorvejen",
		mulighedB: "Kun om natten",
		mulighedC: "I byområder og ved parkering langs vejen",
		mulighedD: "Kun ved skoler om morgenen",
		svar: "C"
	},
	{
		question: "Du skal flette ind, hvor to vognbaner bliver til én (rækkevejskift). Hvem har vigepligt?",
		mulighedA: "Bilen i den venstre bane har altid forkørselsret",
		mulighedB: "Bilen i den højre bane har altid forkørselsret",
		mulighedC: "Man skal skifte række vekselvis og hensynstagne hinanden",
		mulighedD: "Den hurtigste bil kører først",
		svar: "C"
	},
	{
		question: "Du kører med nærlys om aftenen i byen. Hvornår skal du blænde ned for mødende trafik?",
		mulighedA: "Kun hvis den anden bil tuter",
		mulighedB: "Når du risikerer at blænde føreren af det mødende køretøj",
		mulighedC: "Aldrig i byzone",
		mulighedD: "Kun på motorvejen",
		svar: "B"
	},
	{
		question: "Hvad er den typiske hastighedsgrænse på danske motorveje for personbiler, medmindre andet er skiltet?",
		mulighedA: "110 km/t",
		mulighedB: "120 km/t",
		mulighedC: "130 km/t",
		mulighedD: "140 km/t",
		svar: "C"
	},
	{
		question: "Du har fået grønt lys, men en fodgænger er stadig i fodgængerfeltet. Hvad gør du?",
		mulighedA: "Kører, fordi du har grønt",
		mulighedB: "Tuter og kører tæt på fodgængeren",
		mulighedC: "Venter, til fodgængeren har passeret sikkert",
		mulighedD: "Kører langsomt og skubber fodgængeren til siden",
		svar: "C"
	},
	{
		question: "Hvad bør du gøre, hvis du blændes af en modkørende bil med fjernlys?",
		mulighedA: "Tænde dine egne fjernlys og blænde tilbage",
		mulighedB: "Kigge mod højre kant af vejen og sænke farten om nødvendigt",
		mulighedC: "Lukke øjnene kort og beholde farten",
		mulighedD: "Stoppe midt på vejen med det samme",
		svar: "B"
	},
	{
		question: "Du skal lave en U-vending i byen. Hvornår er det som udgangspunkt tilladt?",
		mulighedA: "Altid, hvis der ikke er andre biler",
		mulighedB: "Kun hvor det kan ske uden fare og uden at hindre trafikken, og hvor det ikke er forbudt",
		mulighedC: "Kun på motorvejens nødspor",
		mulighedD: "Aldrig i Danmark",
		svar: "B"
	},
	{
		question: "Hvorfor er det farligt at køre med utilstrækkelig afstand til forankørende?",
		mulighedA: "Det øger kun brændstofforbruget",
		mulighedB: "Det giver for kort reaktionstid og høj risiko for påkørsel bagfra",
		mulighedC: "Det er kun ulovligt på motorvejen",
		mulighedD: "Det er kun et problem ved regnvejr",
		svar: "B"
	},
	{
		question: "Du skal køre videre fra et lyskryds og har glemt at slå blinklys til. Hvad er mest korrekt?",
		mulighedA: "Blinklys er kun pynt i byzone",
		mulighedB: "Du skal bruge blinklys for at vise dine øvrige trafikanter, hvad du har tænkt dig",
		mulighedC: "Blinklys bruges kun på motorvejen",
		mulighedD: "Du skal kun blinke, hvis der er politi til stede",
		svar: "B"
	}
]
