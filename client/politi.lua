local function isPolice()
	return ESX.PlayerData.job and ESX.PlayerData.job.name == 'police'
end

local function getTargetServerId(entity)
	local playerIndex = NetworkGetPlayerIndexFromPed(entity)
	return playerIndex ~= -1 and GetPlayerServerId(playerIndex) or nil
end

function OpenPoliceRemoveMenu(targetServerId)
	if not isPolice() then
		return lib.notify({ title = 'Kørekort', description = 'Kun politiet kan gøre det her.', type = 'error', icon = 'shield' })
	end

	ESX.TriggerServerCallback('esx_dmvschool:policeGetLicenses', function(licenses)
		if licenses == false then
			return lib.notify({ title = 'Kørekort', description = 'Kun politiet kan gøre det her.', type = 'error', icon = 'shield' })
		end

		if not licenses or #licenses == 0 then
			return lib.notify({ title = 'Kørekort', description = 'Personen har intet kørekort.', type = 'inform', icon = 'id-card' })
		end

		local options = {}

		for i = 1, #licenses do
			local license = licenses[i]
			options[#options + 1] = {
				title = license.label,
				description = 'Fratag kørekortet',
				icon = 'ban',
				onSelect = function()
					if lib.alertDialog({
						header = 'Fratag kørekort',
						content = ('Fratag %s?'):format(license.label),
						centered = true,
						cancel = true
					}) == 'confirm' then
						TriggerServerEvent('esx_dmvschool:policeRemoveLicense', targetServerId, license.type)
					end
				end
			}
		end

		lib.registerContext({ id = 'dmvschool_police', title = 'Fratag kørekort', options = options })
		lib.showContext('dmvschool_police')
	end, targetServerId)
end

CreateThread(function()
	exports.ox_target:addGlobalPlayer({
		{
			name = 'dmvschool_police_license',
			icon = 'fa-solid fa-id-card',
			label = 'Fratag kørekort',
			groups = { police = 0 },
			distance = 2.5,
			onSelect = function(data)
				local targetId = getTargetServerId(data.entity)
				if targetId then OpenPoliceRemoveMenu(targetId) end
			end
		}
	})
end)

RegisterCommand('fratagkørekort', function(_, args)
	local targetId = tonumber(args[1])

	if not targetId then
		return lib.notify({
			title = 'Kørekort',
			description = 'Brug: /fratagkørekort [id]',
			type = 'error',
			icon = 'circle-info'
		})
	end

	OpenPoliceRemoveMenu(targetId)
end, false)

RegisterNetEvent('esx_dmvschool:licenseActionResult', function(success, message)
	lib.notify({
		title = 'Kørekort',
		description = message,
		type = success and 'success' or 'error',
		icon = success and 'circle-check' or 'circle-xmark'
	})
end)
