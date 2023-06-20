local QBCore = exports['qb-core']:GetCoreObject()

Wrapper = {
    blip = {},
    cam = {}
}

function Wrapper:CreateObject(Object) -- Create object / prop
    self.LoadModel(Object)
end

function Wrapper:LoadModel() -- Load Model
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Citizen.Wait(5)
    end
end


function Wrapper:Target(id,Label,pos,event,_sizex,_sizey) -- QBTarget target create
    local sizex = _sizex or 1
    local sizey = _sizey or 1
    print(id,Label,pos,event.. " : Wrapper created a target")
    exports["qb-target"]:AddBoxZone(Label..id, pos, sizex, sizey, {
        name = Label..id,
        heading = '90.0',
        minZ = pos - 5,
        maxZ = pos + 5
    }, {
        options = {
            {
                type = "client",
                event = event,
                icon = "fas fa-button",
                label = Label,
            }
        },
        distance = 1.5
    })
end

function Wrapper:TargetRemove(sendid) -- Remove QBTarget target
    exports["qb-target"]:RemoveZone(sendid)
end

function Wrapper:Blip(id,label,pos,sprite,color,scale) -- Create Normal Blip on Map
    Wrapper.blip[id] = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite (Wrapper.blip[id], sprite)
    SetBlipDisplay(Wrapper.blip[id], 4)
    SetBlipScale  (Wrapper.blip[id], scale)
    SetBlipAsShortRange(Wrapper.blip[id], true)
    SetBlipColour(Wrapper.blip[id], color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(Wrapper.blip[id])
end

function Wrapper:Stash(label,weight,slots) -- Create and Open a stash in qb-inventory
    TriggerEvent("inventory:client:SetCurrentStash", label)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", label, {
        maxweight = weight,
        slots = slots,
    })
end

function Wrapper:Notify(txt,tp,time) -- QBCore notify
    QBCore.Functions.Notify(txt, tp, time)
end

function Wrapper:Bill(playerId, amount) -- QBCore bill player, YOU (your job) Bills => Player and amount (player,amount)
    TriggerServerEvent('Wrapper:Bill',playerId, amount)
end

function Wrapper:AddItem(item,amount) -- AddItem to me (Like give item) very unsafe use only in dev build.
    TriggerServerEvent('Wrapper:AddItem',item,amount)
end

function Wrapper:Craft(txt,time) -- Not Done
    QBCore.Functions.Progressbar("pickup_sla", txt, time, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mp_common",
        anim = "givetake1_a",
        flags = 8,
    }, {}, {}, function() -- Done

    end, function()
        QBCore.Functions.Notify("Cancelled..", "error")
    end)
end

function Wrapper:Cam(id,trans) -- Create and render a camera :)
    Wrapper.cam[id] = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    RenderScriptCams(true, 1, trans or 1500,  true,  true)
    self.processCamera(Wrapper.cam[id])
end

function Wrapper:CamDestory(id,trans) -- KILL THE CAMERA !!!!
    activated = false
    RenderScriptCams(false, 1, trans or 1500,  true,  true)
    DestroyCam(Wrapper.cam[id], false)
end

function Wrapper:processCamera(id) -- process the camera :)
    local rotx, roty, rotz = table.unpack(GetEntityRotation(PlayerPedId()))
	local camX, camY, camZ = table.unpack(GetGameplayCamCoord())
	local camRX, camRY, camRZ = GetGameplayCamRelativePitch(), 0.0, GetGameplayCamRelativeHeading()
	local camF = GetGameplayCamFov()
	local camRZ = (rotz+camRZ)
	
	SetCamCoord(Wrapper.cam[id], camX, camY, camZ)
	SetCamRot(Wrapper.cam[id], camRX, camRY, camRZ)
	SetCamFov(Wrapper.cam[id], camF - 120) 
end

function Wrapper:Log(webhook,txt) -- Log all of your abusive staff
    TriggerServerEvent('Wrapper:Log',webhook,txt)
end

function Wrapper:Tp(_coords,fancy,ped) -- Teleport to coords, very fancy, very pretty
    local ped = _ped or PlayerPedId()
    local coords = _coords
    print(coords)
    if coords == nil then 
        QBCore.Functions.Notify("Wrapper: Нямаш coords бай хуй", 'error', 2500)
        return
    end
    if fancy then 
        DoScreenFadeOut(1000)
        Wait(1000)
        DoScreenFadeIn(1000)
    end
    SetEntityCoords(ped,coords)
end


