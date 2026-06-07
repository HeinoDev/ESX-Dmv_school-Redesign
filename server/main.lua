local VALID_LICENSES = {
	dmv = true,
	drive = true,
	drive_bike = true,
	drive_truck = true,
}

-- Slå til hvis I bruger population/frakendelse i databasen
local CHECK_REVOKED_LICENSES = false
local REVOKED_STATUSES = { 'Ubetinget frakendelse' }

local function isValidLicense(licenseType)
	return VALID_LICENSES[licenseType] == true
end

local function isAccountLocked(source)
	local ok, locked = pcall(function()
		return exports['fh_accountclose']:isAccountLocked(source)
	end)
	return ok and locked
end

local function isPolice(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	return xPlayer and xPlayer.getJob().name == 'police'
end

local TestLabels = {
	dmv = 'teoriprøven',
	drive = 'køreprøven (bil)',
	drive_bike = 'køreprøven (motorcykel)',
	drive_truck = 'køreprøven (lastbil)',
}

local function getPlayerLicenses(source, cb)
	TriggerEvent('esx_license:getLicenses', source, function(licenses)
		cb(licenses or {})
	end)
end

local function processPayment(source, xPlayer, type, cb)
	local price = Config.Priser[type]
	local bankMoney = xPlayer.getAccount('bank').money or 0

	if bankMoney < price then
		cb(false, 'Du har ikke nok penge')
		return
	end

	if isAccountLocked(source) then
		cb(false, 'Din konto er låst')
		return
	end

	xPlayer.removeAccountMoney('bank', price, 'Køreskole betaling')
	TriggerClientEvent('ox_lib:notify', source, {
		title = Config.Hansen.Name,
		description = ('Du har betalt %s kr for %s.'):format(ESX.Math.GroupDigits(price), TestLabels[type] or 'prøven'),
		type = 'success',
		icon = type == 'dmv' and 'clipboard-question' or 'car'
	})
	cb(true)
end

local function checkLicenseEligibility(source, xPlayer, type, cb)
	if not CHECK_REVOKED_LICENSES then
		processPayment(source, xPlayer, type, cb)
		return
	end

	MySQL.Async.fetchScalar('SELECT id FROM population WHERE steamid = @steamid', {
		['@steamid'] = xPlayer.identifier
	}, function(id)
		if not id then
			processPayment(source, xPlayer, type, cb)
			return
		end

		MySQL.Async.fetchAll('SELECT status FROM population_cases WHERE pid = @pid AND dato >= DATE(NOW()) - INTERVAL 3 DAY', {
			['@pid'] = id
		}, function(result)
			if result then
				for _, row in ipairs(result) do
					for _, status in ipairs(REVOKED_STATUSES) do
						if row.status == status then
							cb(false, 'Du har en ubetinget frakendelse')
							return
						end
					end
				end
			end

			processPayment(source, xPlayer, type, cb)
		end)
	end)
end

ESX.RegisterServerCallback('esx_dmvschool:getLicenses', function(source, cb)
	getPlayerLicenses(source, cb)
end)

ESX.RegisterServerCallback('esx_dmvschool:addLicense', function(source, cb, licenseType)
	if not isValidLicense(licenseType) then
		cb(nil)
		return
	end

	TriggerEvent('esx_license:addLicense', source, licenseType, function()
		getPlayerLicenses(source, cb)
	end)
end)

ESX.RegisterServerCallback('esx_dmvschool:canYouPay', function(source, cb, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then
		cb(false, 'Kunne ikke finde spiller')
		return
	end

	if not Config.Priser[type] then
		cb(false, 'Ukendt licenstype')
		return
	end

	checkLicenseEligibility(source, xPlayer, type, cb)
end)

ESX.RegisterServerCallback('esx_dmvschool:policeGetLicenses', function(source, cb, targetId)
	if not isPolice(source) then
		cb(false)
		return
	end

	local xTarget = ESX.GetPlayerFromId(targetId)
	if not xTarget then
		cb(nil)
		return
	end

	getPlayerLicenses(targetId, cb)
end)

RegisterNetEvent('esx_dmvschool:policeRemoveLicense')
AddEventHandler('esx_dmvschool:policeRemoveLicense', function(targetId, licenseType)
	if not isPolice(source) or not isValidLicense(licenseType) then
		return
	end

	local xTarget = ESX.GetPlayerFromId(targetId)
	if not xTarget then
		TriggerClientEvent('esx_dmvschool:licenseActionResult', source, false, 'Spilleren blev ikke fundet.')
		return
	end

	exports['esx_license']:RemoveLicense(xTarget.getIdentifier(), licenseType, function(rowsChanged)
		if rowsChanged > 0 then
			getPlayerLicenses(targetId, function(licenses)
				TriggerClientEvent('esx_dmvschool:loadLicenses', targetId, licenses)
			end)
			TriggerClientEvent('esx_dmvschool:licenseActionResult', source, true, 'Kørekortet er frataget.')
			TriggerClientEvent('ox_lib:notify', targetId, {
				title = 'Kørekort frataget',
				description = 'Politiet har frataget dit kørekort.',
				type = 'error',
				icon = 'circle-xmark'
			})
		else
			TriggerClientEvent('esx_dmvschool:licenseActionResult', source, false, 'Personen havde ikke det kørekort.')
		end
	end)
end)

AddEventHandler('esx:playerLoaded', function(source)
	getPlayerLicenses(source, function(licenses)
		TriggerClientEvent('esx_dmvschool:loadLicenses', source, licenses)
	end)
end)
