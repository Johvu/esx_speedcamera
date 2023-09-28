local LoadedPropList = {}
local hasBeenCaught = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	LoadRadarProps()
	for k in pairs(Config.Cameras) do
		if  Config.Cameras[k].blip == true then
			blip = AddBlipForCoord(Config.Cameras[k].x,  Config.Cameras[k].y,  Config.Cameras[k].z)
			SetBlipSprite(blip, Config.Cameras[k].id)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, 0.5)
			SetBlipColour(blip,  Config.Cameras[k].colour)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Cameras[k].title)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

function LoadRadarProps()
    for k in pairs(Config.Cameras) do
		if  Config.Cameras[k].model == '' then
			
		else
			local propName = Config.Cameras[k].model
			RequestModel(propName)
		
			if not HasModelLoaded(propName) then
				RequestModel(propName)
		
				while not HasModelLoaded(propName) do
					Citizen.Wait(1)
				end
			end

			local radar = CreateObject(propName, Config.Cameras[k].x, Config.Cameras[k].y, Config.Cameras[k].prop_z, true, true, true)

			SetObjectTargettable(radar, true)
			SetEntityHeading(radar, Config.Cameras[k].heading - 115)
			SetEntityAsMissionEntity(radar, true, true)
			FreezeEntityPosition(radar, true)

			-- todo fov for camera SetCamFov(radar, 1.0)

			table.insert(LoadedPropList, radar)
		end
    end
end

function UnloadRadarProps()
	for k, v in pairs(LoadedPropList) do
		DeleteEntity(v)
	end
end

function ShowAdvNotification(image, title, subtitle, text)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(text);
	SetNotificationMessage(image, image, false, 0, title, subtitle);
	DrawNotification(false, true);
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		UnloadRadarProps()
	end
end)

RegisterNetEvent('speedcamera:flash')
AddEventHandler('speedcamera:flash', function(k, direct)
		Citizen.Wait(1)
		DrawSpotLight(Config.Cameras[k].x, Config.Cameras[k].y, Config.Cameras[k].z, direct.x, direct.y, direct.z, 221, 221, 221, 70.0, 100.0, 4.3, 25.0, 28.6)
		Citizen.Wait(10)
		DrawSpotLight(Config.Cameras[k].x, Config.Cameras[k].y, Config.Cameras[k].z, direct.x, direct.y, direct.z, 221, 221, 221, 70.0, 100.0, 4.3, 25.0, 28.6)
end) 


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
		for k in pairs(Config.Cameras) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Cameras[k].x, Config.Cameras[k].y, Config.Cameras[k].z)
            if dist <= Config.Cameras[k].radius then

				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local speed = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = Config.Cameras[k].speed 
				
				if tableContains(Config.Cameras[k].jobs, ESX.PlayerData.job.name) then
					return
				
				if speed > Config.Cameras[k].alert then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
							if hasBeenCaught == false then
								local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
								local sensor1_x,sensor1_y,sensor1_z = table.unpack(Config.Cameras[k].sensor_point1)
								local sensor2_x,sensor2_y,sensor2_z = table.unpack(Config.Cameras[k].sensor_point2)

								--print(GetClosestObjectOfType(x, y, z, 20, 'prop_cctv_pole_01a', true, true, true))
								if IsEntityInArea(playerPed, sensor1_x,sensor1_y,sensor1_z, sensor2_x,sensor2_y,sensor2_z) then
									print("alueella")
									local direct = (vector3(x, y, z) - vector3(Config.Cameras[k].x, Config.Cameras[k].y, Config.Cameras[k].z))
									if Config.Cameras[k].model ~= '' then
										TriggerServerEvent("speedcamera:flash", k, direct)
										Citizen.Wait(1)
										DrawSpotLight(Config.Cameras[k].x, Config.Cameras[k].y, Config.Cameras[k].z, direct.x, direct.y, direct.z, 221, 221, 221, 70.0, 100.0, 4.3, 25.0, 28.6)
										Citizen.Wait(10)
										DrawSpotLight(Config.Cameras[k].x, Config.Cameras[k].y, Config.Cameras[k].z, direct.x, direct.y, direct.z, 221, 221, 221, 70.0, 100.0, 4.3, 25.0, 28.6)
									end
	
									if Config.alertAuthorities then
										if speed > Config.Cameras[k].alert then
											local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
											Alert(k, speed, GetVehicleNumberPlateText(playerCar), mugshotStr, mugshot)
										end
									end
	
									if Config.useCameraSound then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
	
									Notify(k, speed)
	
									if Config.useBilling then
										Bill(k, speed, PlayerData)
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) 
								end
								
							end
						end
					end
					hasBeenCaught = false
				end
            end
        end
    end
end)