local TeamClass = {}
TeamClass.__index = TeamClass

---@param Source number
function TeamClass:New(Source)
    local PlayerData = Jet.Framework.GetPlayerData(Source)
    if not PlayerData then return end

    local NewSelf = table.clone(self)

    NewSelf.Leader = Source
    NewSelf.Members = {
        {
            Source = Source,
            Name = PlayerData.character.fullName,
            IsLeader = true
        }
    }
    NewSelf.Metadata = {}
    NewSelf.Locked = false

    return NewSelf
end

---@param Source number
function TeamClass:AddMember(Source)
    local PlayerData = Jet.Framework.GetPlayerData(Source)
    if not PlayerData then return end

    table.insert(self.Members, {
        Source = Source,
        Name = PlayerData.character.fullName,
        IsLeader = false
    })
end

---@param Source number
function TeamClass:RemoveMember(Source)
    for i, Member in ipairs(self.Members) do
        if not Member.IsLeader and Member.Source == Source then
            table.remove(self.Members, i)
            break
        end
    end
end

---@param Func fun(Source: number)
function TeamClass:Run(Func)
    for i = 1, #self.Members do
        Func(self.Members[i])
    end
end

---@param Key string
---@param Value any
function TeamClass:SetMetadata(Key, Value)
    self.Metadata[Key] = Value
end

---@param Key string
---@param Default any
---@return any
function TeamClass:GetMetadata(Key, Default)
    Default = Default or false
    return self.Metadata[Key] or Default
end

---@param State boolean
function TeamClass:SetLock(State)
    self.Locked = State
end

return TeamClass