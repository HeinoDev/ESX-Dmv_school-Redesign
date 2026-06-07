local Licenses = {}
local CurrentTest, CurrentTestType, CurrentVehicle = nil, nil, nil
local CurrentCheckPoint, DriveErrors = 0, 0
local LastCheckPoint, CurrentBlip, CurrentZoneType = -1, nil, nil
local LastVehicleHealth, failedTest = nil, false
local DriveHudExpanded, TotalDriveCheckPoints = false, 0
local LastErrorNotifyAt = 0
local InstructorName = Config.Hansen.Name
local DriveInstructorPed = nil

local function IsDebugMode()
	return Config.Dev.Enabled
end

local function NotifyDriveError(description)
	if failedTest or IsDebugMode() then return end

	local now = GetGameTimer()
	if now - LastErrorNotifyAt < Config.Hud.ErrorNotifyCooldown then return end

	LastErrorNotifyAt = now
	lib.notify({
		title = InstructorName,
		description = description,
		type = 'warning',
		icon = 'triangle-exclamation',
		duration = 6000
	})
end

function HideMissionText()
	SendNUIMessage({ missionText = 'hide' })
end

function DrawMissionText(msg, time)
	msg = msg:gsub('^Hansen:%s*', '')

	local prefix = InstructorName .. ': '

	if msg:sub(1, #prefix) == prefix then
		msg = msg:sub(#prefix + 1)
	end

	SendNUIMessage({
		missionText = 'show',
		message = msg,
		instructor = InstructorName,
		duration = time or 5000
	})
end

function StartTheoryTest()
	CurrentTest = 'theory'

	lib.notify({
		title = InstructorName,
		description = 'Tag plads ved skrivebordet. Teoriprøven er skriftlig - 25 spørgsmål, mindst 20 rigtige for at bestå (højst 5 fejl).',
		type = 'inform',
		icon = 'clipboard-question',
		duration = 10000
	})

	SendNUIMessage({
		openQuestion = true
	})

	ESX.SetTimeout(200, function()
		SetNuiFocus(true, true)
	end)
end

function StopTheoryTest(success)
	CurrentTest = nil

	SendNUIMessage({
		openQuestion = false
	})

	SetNuiFocus(false)

	if success then
		ESX.TriggerServerCallback('esx_dmvschool:addLicense', function(licenses)
			Licenses = licenses or {}
			lib.notify({
				title = 'Teoriprøve bestået',
				description = ('%s: Flot klaret. Vælg hvilken køreprøve du vil tage.'):format(InstructorName),
				type = 'success',
				icon = 'circle-check'
			})
			ShowDMVSchoolMenu(Licenses)
		end, 'dmv')
	else
		lib.notify({
			title = 'Teoriprøve ikke bestået',
			description = ('%s: Du skal have flere rigtige svar. Læs materialet og prøv igen.'):format(InstructorName),
			type = 'error',
			icon = 'circle-xmark'
		})
	end
end

function IsVehicleSpawnPointClear(coords, radius)
	if ESX.Game.IsSpawnPointClear then
		return ESX.Game.IsSpawnPointClear(coords, radius)
	end

	return not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, radius)
end

function GetAvailableVehicleSpawnPoint()
	local spawnPoints = Config.Test.SpawnPoints
	local clearRadius = Config.Test.SpawnClearRadius

	for i = 1, #spawnPoints do
		local point = spawnPoints[i]
		if IsVehicleSpawnPointClear(vector3(point.x, point.y, point.z), clearRadius) then
			return point
		end
	end

	return spawnPoints[1]
end

function UpdateDriveHud()
	SendNUIMessage({
		driveHud = 'update',
		checkpoint = CurrentCheckPoint,
		total = TotalDriveCheckPoints,
		errors = DriveErrors,
		maxErrors = Config.Test.MaxErrors,
		failed = failedTest == true,
		debugMode = IsDebugMode()
	})
end

function ShowDriveHud()
	SendNUIMessage({
		driveHud = 'show',
		checkpoint = CurrentCheckPoint,
		total = TotalDriveCheckPoints,
		errors = DriveErrors,
		maxErrors = Config.Test.MaxErrors,
		expanded = DriveHudExpanded,
		failed = failedTest == true,
		debugMode = IsDebugMode(),
		toggleKey = Config.Hud.ToggleKey
	})
end

function HideDriveHud()
	SendNUIMessage({
		driveHud = 'hide'
	})
end

function SpawnDriveTestVehicle(model, spawnPoint)
	local vehicle = Jet.Create.Vehicle(model, spawnPoint, { fuelLevel = 100.0 })

	SetVehicleFuelLevel(vehicle, 100.0)
	DecorSetFloat(vehicle, '_FUEL_LEVEL', 100.0)

	local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))

	exports['mani-keys']:GiveKey({
		Plate = plate,
		IsOwner = true,
		Persistent = false
	})

	return vehicle
end

function RemoveDriveInstructor()
	if DriveInstructorPed and DoesEntityExist(DriveInstructorPed) then
		DeleteEntity(DriveInstructorPed)
	end

	DriveInstructorPed = nil
end

function SpawnDriveInstructor(vehicle, testType)
	RemoveDriveInstructor()

	if testType == 'drive_bike' then
		return nil
	end

	local ped = Jet.Create.Ped(Config.Hansen.Model, vector4(0.0, 0.0, 0.0, 0.0), {
		Entity = vehicle,
		Seat = 0
	})

	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetPedCanBeDraggedOut(ped, false)
	SetPedCanBeKnockedOffVehicle(ped, 1)
	SetPedConfigFlag(ped, 184, true)

	DriveInstructorPed = ped
	return ped
end

function CleanupDriveTestVehicle(vehicle)
	RemoveDriveInstructor()

	if vehicle and DoesEntityExist(vehicle) then
		ESX.Game.DeleteVehicle(vehicle)
	end
end

function StartDriveTest(type)
	local vehicleLabels = {
		drive = 'bil',
		drive_bike = 'motorcykel',
		drive_truck = 'lastbil'
	}

	local spawnPoint = GetAvailableVehicleSpawnPoint()

	local instructorHint = type == 'drive_bike'
		and 'Stig på motorcyklen ved udkigsposten og begynd prøven.'
		or 'Jeg sidder som passager - stig ind som chauffør og begynd prøven.'

	if IsDebugMode() then
		lib.notify({
			title = InstructorName,
			description = 'DEV: Køreprøve - fejl tæller ikke. Kør ruten færdig.',
			type = 'inform',
			icon = 'bug',
			duration = 5000
		})
	else
		lib.notify({
			title = InstructorName,
			description = ('Køreprøve i %s. %s Max %s fejl.'):format(vehicleLabels[type] or 'køretøj', instructorHint, Config.Test.MaxErrors),
			type = 'inform',
			icon = 'car'
		})
	end

	local vehicle = SpawnDriveTestVehicle(Config.Test.VehicleModels[type], spawnPoint)
	SpawnDriveInstructor(vehicle, type)

	CurrentTest = 'drive'
	CurrentTestType = type
	CurrentCheckPoint = 0
	LastCheckPoint = -1
	CurrentZoneType = 'residence'
	DriveErrors = 0
	CurrentVehicle = vehicle
	LastVehicleHealth = GetEntityHealth(vehicle)
	failedTest = false
	DriveHudExpanded = false
	LastErrorNotifyAt = 0
	TotalDriveCheckPoints = #Config.Test.CheckPoints - 1

	ShowDriveHud()
end

function StopDriveTest(success)
	if IsDebugMode() then
		success = true
	end

	if success then
		ESX.TriggerServerCallback('esx_dmvschool:addLicense', function(licenses)
			Licenses = licenses or {}
		end, CurrentTestType)
		lib.notify({
			title = 'Køreprøve bestået',
			description = ('%s: Din kørsel var sikker og kontrolleret. Du har nu fået kørekort.'):format(InstructorName),
			type = 'success',
			icon = 'id-card'
		})
	else
		lib.notify({
			title = 'Køreprøve ikke bestået',
			description = ('%s: For mange fejl i trafikken. Øv dig mere og book en ny køreprøve.'):format(InstructorName),
			type = 'error',
			icon = 'circle-xmark'
		})
	end

	RemoveDriveInstructor()
	CurrentVehicle = nil
	CurrentTest = nil
	CurrentTestType = nil
	HideDriveHud()
	HideMissionText()
end

function SetCurrentZoneType(type)
	CurrentZoneType = type
end

function ShowDMVSchoolMenu(licenses)
	Licenses = licenses or {}

	local ownedLicenses = {}
	for i = 1, #Licenses do
		ownedLicenses[Licenses[i].type] = true
	end

	local options = {}

	if not ownedLicenses['dmv'] then
		options[#options + 1] = {
			title = ('Teoriprøve - %s kr'):format(ESX.Math.GroupDigits(Config.Priser['dmv'])),
			description = 'Skriftlig prøve i færdselsloven. Skal bestås før du må tage køreprøve.',
			icon = 'clipboard-question',
			onSelect = function()
				ESX.TriggerServerCallback('esx_dmvschool:canYouPay', function(haveMoney, message)
					if haveMoney then
						lib.hideContext()
						StartTheoryTest()
					else
						lib.notify({ title = InstructorName, description = message, type = 'error', icon = 'wallet' })
					end
				end, 'dmv')
			end
		}
	end

	if ownedLicenses['dmv'] then
		if not ownedLicenses['drive'] then
			options[#options + 1] = {
				title = ('Køreprøve (bil) - %s kr'):format(ESX.Math.GroupDigits(Config.Priser['drive'])),
				description = 'Praktisk prøve i bil med kørelærer.',
				icon = 'car',
				onSelect = function()
					ESX.TriggerServerCallback('esx_dmvschool:canYouPay', function(haveMoney, message)
						if haveMoney then
							lib.hideContext()
							StartDriveTest('drive')
						else
							lib.notify({ title = InstructorName, description = message, type = 'error', icon = 'wallet' })
						end
					end, 'drive')
				end
			}
		end

		if not ownedLicenses['drive_bike'] then
			options[#options + 1] = {
				title = ('Køreprøve (motorcykel) - %s kr'):format(ESX.Math.GroupDigits(Config.Priser['drive_bike'])),
				description = 'Praktisk prøve på motorcykel.',
				icon = 'motorcycle',
				onSelect = function()
					ESX.TriggerServerCallback('esx_dmvschool:canYouPay', function(haveMoney, message)
						if haveMoney then
							lib.hideContext()
							StartDriveTest('drive_bike')
						else
							lib.notify({ title = InstructorName, description = message, type = 'error', icon = 'wallet' })
						end
					end, 'drive_bike')
				end
			}
		end

		if not ownedLicenses['drive_truck'] then
			options[#options + 1] = {
				title = ('Køreprøve (lastbil) - %s kr'):format(ESX.Math.GroupDigits(Config.Priser['drive_truck'])),
				description = 'Praktisk prøve i lastbil.',
				icon = 'truck',
				onSelect = function()
					ESX.TriggerServerCallback('esx_dmvschool:canYouPay', function(haveMoney, message)
						if haveMoney then
							lib.hideContext()
							StartDriveTest('drive_truck')
						else
							lib.notify({ title = InstructorName, description = message, type = 'error', icon = 'wallet' })
						end
					end, 'drive_truck')
				end
			}
		end
	end

	if #options == 0 then
		lib.notify({
			title = InstructorName,
			description = 'Du har allerede alle kørekort.',
			type = 'inform',
			icon = 'id-card'
		})
		return
	end

	lib.registerContext({
		id = 'dmvschool_menu',
		title = InstructorName,
		options = options
	})

	lib.showContext('dmvschool_menu')
end

function OpenDMVSchoolMenu()
	ESX.TriggerServerCallback('esx_dmvschool:getLicenses', function(licenses)
		ShowDMVSchoolMenu(licenses)
	end)
end

RegisterNUICallback('question', function(data, cb)
	SendNUIMessage({
		openSection = 'question'
	})

	cb()
end)

RegisterNUICallback('close', function(data, cb)
	StopTheoryTest(true)
	cb()
end)

RegisterNUICallback('kick', function(data, cb)
	StopTheoryTest(false)
	cb()
end)

RegisterNetEvent('esx_dmvschool:loadLicenses')
AddEventHandler('esx_dmvschool:loadLicenses', function(licenses)
	Licenses = licenses
end)

CreateThread(function()
	local blip = AddBlipForCoord(Config.Hansen.Location.x, Config.Hansen.Location.y, Config.Hansen.Location.z)

	SetBlipSprite (blip, 408)
	SetBlipColour (blip, 0)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(Config.Hansen.BlipLabel)
	EndTextCommandSetBlipName(blip)
end)

CreateThread(function()
	while true do
		local sleep = 1500
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if CurrentTest == 'theory' then
			
			sleep = 0
			DisableControlAction(0, 1, true)
			DisableControlAction(0, 2, true)
			DisablePlayerFiring(playerPed, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 106, true)
		end

		if CurrentTest == 'drive' then
			sleep = 0

			local nextCheckPoint = CurrentCheckPoint + 1

			if Config.Test.CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(CurrentBlip) then
					RemoveBlip(CurrentBlip)
				end

				CurrentTest = nil
				StopDriveTest(IsDebugMode() or DriveErrors <= Config.Test.MaxErrors)
			else
				if CurrentCheckPoint ~= LastCheckPoint then
					if DoesBlipExist(CurrentBlip) then
						RemoveBlip(CurrentBlip)
					end

					CurrentBlip = AddBlipForCoord(Config.Test.CheckPoints[nextCheckPoint].Position.x, Config.Test.CheckPoints[nextCheckPoint].Position.y, Config.Test.CheckPoints[nextCheckPoint].Position.z)
					SetBlipRoute(CurrentBlip, 1)

					LastCheckPoint = CurrentCheckPoint
				end
            
				local Pos = vector3(Config.Test.CheckPoints[nextCheckPoint].Position.x,Config.Test.CheckPoints[nextCheckPoint].Position.y,Config.Test.CheckPoints[nextCheckPoint].Position.z)
				local distance = #(coords - Pos)
            
				if distance <= Config.Test.MarkerDistance then
					DrawMarker(1, Config.Test.CheckPoints[nextCheckPoint].Position.x, Config.Test.CheckPoints[nextCheckPoint].Position.y, Config.Test.CheckPoints[nextCheckPoint].Position.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end

				if distance <= 3.0 then
					Config.Test.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
					CurrentCheckPoint = CurrentCheckPoint + 1
					UpdateDriveHud()
				end
			end
		end

		Wait(sleep)
	end
end)


function TestFailedGoToLastCheckPoint()
	CurrentCheckPoint = #Config.Test.CheckPoints - 1
	failedTest = true
	DriveHudExpanded = true
	UpdateDriveHud()
	SendNUIMessage({ driveHud = 'expand' })

	lib.notify({
		title = InstructorName,
		description = 'For mange fejl. Kør tilbage til køreskolen - køreprøven er ikke bestået.',
		type = 'error',
		icon = 'route',
		duration = Config.Hud.FailNotifyDuration
	})
end

CreateThread(function()
	local pedModel = GetHashKey(Config.Hansen.Model)

	RequestModel(pedModel)
	while not HasModelLoaded(pedModel) do
		Wait(50)
	end
	
	local pedEntity = nil

	local pedEntityLocation = Config.Hansen.Location
	while true do
		local sleep = 1500
		if CurrentTest == 'drive' then
			sleep = 0
			local playerPed = PlayerPedId()
			
			if IsPedInAnyVehicle(playerPed, false) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				local speed = GetEntitySpeed(vehicle) * Config.Test.SpeedMultiplier
				local health = GetEntityHealth(vehicle)

				for k, v in pairs(Config.Test.SpeedLimits) do

					if CurrentZoneType == k and speed > v then
						if not IsDebugMode() then
							DriveErrors += 1
							UpdateDriveHud()

							if DriveErrors <= Config.Test.MaxErrors then
								NotifyDriveError(('Du kører for hurtigt - grænsen er %s km/t. Fejl %s/%s.'):format(v, DriveErrors, Config.Test.MaxErrors))
							end
						end

						sleep = (Config.Test.SpeedingErrorDelay < 5000) and 5000 or Config.Test.SpeedingErrorDelay
					end
				end

				if not IsDebugMode() and health < LastVehicleHealth then
					DriveErrors += 1
					UpdateDriveHud()

					if DriveErrors <= Config.Test.MaxErrors then
						NotifyDriveError(('Du ramte noget - køretøjet skal behandles forsigtigt. Fejl %s/%s.'):format(DriveErrors, Config.Test.MaxErrors))
					end

					LastVehicleHealth = health
					sleep = 1500
				elseif IsDebugMode() and health < LastVehicleHealth then
					LastVehicleHealth = health
				end

				if not IsDebugMode() and DriveErrors > Config.Test.MaxErrors and not failedTest then
					TestFailedGoToLastCheckPoint()
					sleep = 5000
				end
			end
		else
			local playerCoords = GetEntityCoords(PlayerPedId())
			local distance = #(playerCoords - vec3(pedEntityLocation))
			
			if distance < 150 then
				if not DoesEntityExist(pedEntity) then
					pedEntity = CreatePed(4, pedModel, pedEntityLocation.x, pedEntityLocation.y, pedEntityLocation.z, pedEntityLocation.w, false, false)
					FreezeEntityPosition(pedEntity, true)
					SetEntityInvincible(pedEntity, true)
					TaskStartScenarioInPlace(pedEntity, Config.Hansen.Scenario, 0, true)
					SetBlockingOfNonTemporaryEvents(pedEntity, true)
	
					exports.ox_target:addLocalEntity(pedEntity, {
						name = 'dmvschool',
						label = Config.Hansen.TargetLabel,
						icon = 'fa-solid fa-chalkboard-user',
						distance = 1.5,
						onSelect = OpenDMVSchoolMenu
					})
				end
			else
				if DoesEntityExist(pedEntity) then
					exports['ox_target']:removeLocalEntity(pedEntity)
					DeleteEntity(pedEntity)
				end
			end
		end
		Wait(sleep)
	end
end)

lib.addKeybind({
	name = 'dmvschool_toggle_hud',
	description = 'Udvid køreprøve HUD',
	defaultKey = Config.Hud.ToggleKey,
	onReleased = function()
		if CurrentTest ~= 'drive' then
			return
		end

		DriveHudExpanded = not DriveHudExpanded
		SendNUIMessage({ driveHud = 'toggle' })
	end
})