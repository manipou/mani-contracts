local Config = require 'config'
local Target = exports['ox_target']

local function OpenMenu()
    local MenuData = Jet.Callback.Await('mani-contracts:server:GetMenuData', false)

    print(json.encode(MenuData.Contracts))

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OpenContracts',
        data = MenuData
    })
end

CreateThread(function()
    local NPCCoords = Jet.Callback.Await('mani-contracts:server:GetNPCLocation', false)
    local NPCModel = GetHashKey('IG_LesterCrest')

    Jet.Points.New({
        coords = NPCCoords,
        distance = 75,
        onEnter = function(self)
            Jet.Request.Model(NPCModel)
            local NPC = CreatePed(4, NPCModel, NPCCoords.x, NPCCoords.y, NPCCoords.z, NPCCoords.w, false, true)
            FreezeEntityPosition(NPC, true)
            SetEntityInvincible(NPC, true)
            SetBlockingOfNonTemporaryEvents(NPC, true)

            SetModelAsNoLongerNeeded(NPCModel)

            self.NPC = NPC

            Target:addLocalEntity(NPC, {
                label = 'Heist Kontrakter',
                icon = 'fa-solid fa-briefcase',
                distance = 2.5,
                onSelect = OpenMenu,
            })
        end,
        onExit = function(self)
            Target:removeLocalEntity(self.NPC)
            DeleteEntity(self.NPC)
        end
    })
end)

RegisterNuiCallback('HideUi', function(_, cb)
    SetNuiFocus(false, false)
    TriggerServerEvent('mani-contracts:server:CloseMenu')
    cb({})
end)

RegisterNuiCallback('StartContract', function(Data, cb)
    local Contract = Jet.Callback.Await('mani-contracts:server:StartContract', false, Data.Id)
    if not Contract then return cb({ Success = false }) end

    exports[Contract.Resource][Contract.Export]()

    cb({ Success = true, Data = Contract })
end)

RegisterNuiCallback('CreateTeam', function(_, cb)
    local TeamData = Jet.Callback.Await('mani-contracts:server:CreateTeam', false)
    if not TeamData then return cb({ Success = false }) end
    cb({ Success = true, Data = TeamData })
end)

RegisterNuiCallback('DisbandTeam', function(_, cb)
    local Success = Jet.Callback.Await('mani-contracts:server:DisbandTeam', false)
    cb({ Success = Success })
end)

RegisterNuiCallback('InviteTeam', function(Data, cb)
    local Success = Jet.Callback.Await('mani-contracts:server:InviteTeam', false, Data.Source)
    cb({ Success = Success })
end)

Jet.Callback.Register('mani-contracts:server:ConfirmInvite', function(By)
    -- Todo
    return true
end)

RegisterNetEvent('mani-contracts:client:UpdateMenu', function(Contracts)
    SendNUIMessage({
        action = 'UpdateContracts',
        data = Contracts
    })
end)