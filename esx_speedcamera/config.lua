Config = {}

--esx
Config.useESX = true -- for jobs
Config.useBilling = true 
Config.useCameraSound = true 
Config.alertAuthorities = true 

Config.AlloweVehicles = {
	"POLICE",
    "FBI"
}

Config.Cameras = {
	{speed=80, alert=80, price=25, radius=30, title="Kamera (80KM/H)1", colour=1, id=1, blip=true,  model='prop_cctv_pole_01a', prop_z= 38.75-5, x = 2529.04, y = 4148.44, z = 38.75, heading=138.52, sensor_point1=vector3(2519.01, 4136.91, 38.58), sensor_point2=vector3(2514,4137.31,38.59), jobs={'police'}},

    -- without prop
	{speed=80, alert=80, price=25, radius=25, title="Kamera (80KM/H)", colour=1, id=1, blip=true,  model='', prop_z= 92.2374-5, x = 980.9982, y = 407.4164, z = 92.2374, heading=-50.0, sensor_point1=vector3(2519.01, 4136.91, 38.58), sensor_point2=vector3(2514,4137.31,38.59), jobs={'police'}},

	{speed=120, alert=150, price=25, radius=25, title="Kamera (120KM/H) 1 ", colour=1, id=1, blip=true,  model='prop_cctv_pole_01a', prop_z= 59.3923-5, x = 1584.9281, y = -993.4557, z = 59.3923, heading = 90.0, sensor_point1=vector3(2519.01, 4136.91, 38.58), sensor_point2=vector3(2514,4137.31,38.59), jobs={'police'}}, 
	{speed=120, alert=150, price=25, radius=25, title="Kamera (120KM/H)2 ", colour=1, id=1, blip=true,  model='prop_cctv_pole_01a', prop_z= 88.7765-5, x = 2442.2006, y = -134.6004, z = 88.7765, heading = -45.0, sensor_point1=vector3(2519.01, 4136.91, 38.58), sensor_point2=vector3(2514,4137.31,38.59), jobs={'police'}}, 
	{speed=120, alert=150, price=25, radius=35, title="Kamera (120KM/H)3", colour=1, id=1, blip=true,  model='prop_cctv_pole_01a', prop_z= 53.0930-5, x = 2872.91, y = 3543.39, z = 53.76, heading = 144.45, sensor_point1=vector3(2853.87, 3531.16, 54.05), sensor_point2=vector3(2866.04,3529.91,53.99), jobs={'police'}} 
}

-- client side

function Notify(index, speed)
    --ESX.ShowNotification(Config.Cameras[index].title .. ' - Nopeutesi: ' .. math.ceil(speed) .. ' KM/H', true, true, 120)
end

function Bill(index, speed, xtarget)
    local maxSpeed = Config.Cameras[index].speed 
    local price = 0;


    if speed >= maxSpeed + 30 then
        price = Config.Cameras[index].price + 1000
    elseif speed >= maxSpeed + 20 then
        price = Config.Cameras[index].price + 500
    elseif speed >= maxSpeed + 10 then
        price = Config.Cameras[index].price + 100
    else
        price = Config.Cameras[index].price
    end

   -- OKOKBILLING TriggerServerEvent("okokBilling:CreateCustomInvoice", GetPlayerServerId(PlayerId()), price, 'Nopeutesi: ' .. math.ceil(speed) .. ' KM/H', Config.Cameras[index].title, 'society_police', 'police')
    -- ESX BILLING TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Kamera (120KM/H) - Nopeutesi: ' .. speed .. ' KM/H - ', price) -- Sends a bill from the police
end

function Alert(camera, speed, plate, mugshotStr, mugshot)

    --[[   qs-dispatch
    
    local playerData = exports['qs-dispatch']:GetPlayerInfo(playerData)

    exports['qs-dispatch']:getSSURL(function(image)

        TriggerServerEvent('qs-dispatch:server:CreateDispatchCall', {
            job = { 'police', 'sheriff', 'traffic', 'patrol' },
            callLocation = playerData.coords,
            callCode = { code = 'Ylinopeus ', snippet = 'Auto' },
            message = 'Törkeä ylinopeus - ' .. plate .. ' -  ' .. math.ceil(speed) .. "KM/H",
            flashes = false,
            image = image or nil,
            blip = {
                sprite = 488,
                scale = 1.5,
                colour = 1,
                flashes = true,
                text = 'Hight Speed',
                time = (20 * 1000),     --20 secs
            }
        })


    end)
    --]]

    TriggerServerEvent("speedcamera:alertAuthorities", camera, speed, plate, mugshotStr, mugshot)


end

RegisterNetEvent('speedcamera:alert')
AddEventHandler('speedcamera:alert', function(camera, speed, plate, mugshotStr, mugshot)
    --ShowAdvNotification("CHAR_CALL911", Config.Cameras[camera].title, 'Törkeä ylinopeus' , plate .. ' -  ' .. math.ceil(speed) .. "KM/H")
    ShowAdvNotification("CHAR_CALL911", Config.Cameras[camera].title, 'Major speeding' , plate .. ' -  ' .. math.ceil(speed) .. "KM/H")
    UnregisterPedheadshot(mugshot)
end) 