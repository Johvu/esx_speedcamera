
RegisterServerEvent("speedcamera:flash")
AddEventHandler("speedcamera:flash", function(camera, direct)
if Config.useESX then
local xPlayers = ESX.GetPlayers()
for i= 1, #xPlayers do
	local source = xPlayers[i]
	local xPlayer = ESX.GetPlayerFromId(source)
    if tableContains(Config.Cameras[camera].jobs, xPlayer.job.name) then
        TriggerClientEvent('speedcamera:flash', source, camera, direct)
    end
end
end
end)


RegisterServerEvent("speedcamera:alertAuthorities")
AddEventHandler("speedcamera:alertAuthorities", function(camera, speed, plate, mugshotStr, mugshot)
if Config.useESX then
local xPlayers = ESX.GetPlayers()
for i= 1, #xPlayers do
	local source = xPlayers[i]
	local xPlayer = ESX.GetPlayerFromId(source)
    if tableContains(Config.Cameras[camera].jobs, xPlayer.job.name) then
        TriggerClientEvent('speedcamera:alert', source, camera, speed, plate, mugshotStr, mugshot)
    end
end
end
end)

