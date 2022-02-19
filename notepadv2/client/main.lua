QBCore = exports['qb-core']:GetCoreObject()

local UIOpen = false
local closeNUI = false
local notepadmodel = "prop_notepad_01"
local notepad_net = nil
local penmodel = "prop_pencil_01"
local pen_net = nil
local AnimDict = 'missheistdockssetup1clipboard@base'
local AnimAnim = 'base'

RegisterNetEvent("stickynotepad:client:showUI", function(text, slot)
	if not UIOpen then
		SendNUIMessage({action = "open", uitext = text, slot = slot})
		UIOpen = true
		closeNUI = true
		closeNUILoop(AnimDict, AnimAnim)
		SetNuiFocus(true, true)
	else
		print('cannot view another whilst you are viewing this one')
	end
end)

function closeNUILoop(dictionary, animation)

	loadAnimDict(dictionary)
	local ped = PlayerPedId()
	local pedOffCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(ped), 0.0, 0.0, -5.0)
	local notepad = CreateObject(GetHashKey(notepadmodel), pedOffCoords.x, pedOffCoords.y, pedOffCoords.z, 1, 1, 1)
	local notepadnetid = ObjToNet(notepad)
	TaskPlayAnim(ped, dictionary, animation, 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
	AttachEntityToEntity(notepad,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 18905),0.1, 0.02, 0.05, 10.0, 0.0, 0.0,1,1,0,1,0,1)
	clipboard_net = notepadnetid
	
	local pen = CreateObject(GetHashKey(penmodel), pedOffCoords.x, pedOffCoords.y, pedOffCoords.z, 1, 1, 1)
	local pennetid = ObjToNet(pen)
	TaskPlayAnim(ped, dictionary, animation, 5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
	AttachEntityToEntity(pen,GetPlayerPed(PlayerId()),GetPedBoneIndex(GetPlayerPed(PlayerId()), 58866),0.11, -0.02, 0.001, -120.0, 0.0, 0.0,1,1,0,1,0,1)
	pen_net = pennetid
	
	Citizen.CreateThread(function()
		while (closeNUI) do
			Wait(0)
			
			HelpNotif(string.format('~INPUT_FRONTEND_PAUSE_ALTERNATE~ to close.'), false)
			
			if IsControlJustReleased(0, 38) then -- key e
				SendNUIMessage({action = "close"})
				closeNUI = false
				UIOpen = false
				DetachEntity(NetToObj(clipboard_net), 1, 1)
				DeleteEntity(NetToObj(clipboard_net))
				clipboard_net = nil
				
				DetachEntity(NetToObj(pen_net), 1, 1)
				DeleteEntity(NetToObj(pen_net))
				pen_net = nil
				ClearPedTasks(ped)
				SetNuiFocus(false, false)
				break
			end
			
			if not UIOpen then
				closeNUI = false
				break
			end
			
			if (not IsEntityPlayingAnim(PlayerPedId(), dictionary, animation, 3)) then
				playAnim(dictionary, animation)
			end
		end
	end)
end

RegisterNUICallback('closeUI', function (data, cb)
	local ped = PlayerPedId()
	closeNUI = false
	UIOpen = false
	DetachEntity(NetToObj(clipboard_net), 1, 1)
	DeleteEntity(NetToObj(clipboard_net))
	clipboard_net = nil
	DetachEntity(NetToObj(pen_net), 1, 1)
	DeleteEntity(NetToObj(pen_net))
	pen_net = nil
	ClearPedTasks(ped)
	SetNuiFocus(false, false)
end)

RegisterNUICallback('saveText', function (data, cb)
	local ped = PlayerPedId()
	closeNUI = false
	UIOpen = false
	DetachEntity(NetToObj(clipboard_net), 1, 1)
	DeleteEntity(NetToObj(clipboard_net))
	clipboard_net = nil
	DetachEntity(NetToObj(pen_net), 1, 1)
	DeleteEntity(NetToObj(pen_net))
	pen_net = nil
	ClearPedTasks(ped)
	SetNuiFocus(false, false)
	local text = data.text
	local slot = data.slot
	TriggerServerEvent('jake:server:stickychange', text, slot)
end)

function playAnim(dictionary, animation)
		TaskPlayAnim(GetPlayerPed(-1),dictionary,animation,5.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

function HelpNotif(text, sound)
    AddTextEntry(GetCurrentResourceName(), text)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(0, 0, (sound == true), -1)
end
