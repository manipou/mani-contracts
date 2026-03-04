local Config = require 'config'

local TeamClass = {}
TeamClass.__index = TeamClass

function TeamClass:New(Source)
    local PlayerData = Jet.Framework.GetPlayerData(Source)
    if not PlayerData then return end

    return setmetatable({
        Leader = Source,
        Members = {
            {
                Source = Source,
                Name = PlayerData.character.fullName,
                IsLeader = true
            }
        },
    }, TeamClass)
end

function TeamClass:AddMember(Source)
    local PlayerData = Jet.Framework.GetPlayerData(Source)
    if not PlayerData then return end

    table.insert(self.Members, {
        Source = Source,
        Name = PlayerData.character.fullName,
        IsLeader = false
    })
end

function TeamClass:RemoveMember(Source)
    for i, Member in ipairs(self.Members) do
        if not Member.IsLeader and Member.Source == Source then
            table.remove(self.Members, i)
            break
        end
    end
end

function TeamClass:Run(Func)
    for i = 1, #self.Members do
        Func(self.Members[i])
    end
end

return TeamClass