local Config = require 'config'
local Target = exports['ox_target']

local function OpenMenu()
    local Contracts = Jet.Callback.Await('mani-contracts:server:GetContracts', false)
end

CreateThread(function()
    local NPCCoords = Jet.Callback.Await('mani-contracts:server:GetNPCLocation', false)
    local NPCModel = GetHashKey(Config.NPC.Model)

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