local Config = require 'config'
local TeamClass = require 'teams'

local Registered, Contracts, Teams, TeamsCache = {}, {}, {}, {}
local ActiveContracts = 0

local MenuCache = {}

---@param XP number
local function GetLevel(XP)
    for Level, MaxXP in ipairs(Config.Levels) do
        if XP < MaxXP then return Level end
    end

    return #Config.Levels
end

---@param Source number
local function AddMenuCache(Source)
    for _, src in ipairs(MenuCache) do if src == Source then return end end
    table.insert(MenuCache, Source)
end

---@param Source number
local function RemoveMenuCache(Source)
    for i, src in ipairs(MenuCache) do
        if src == Source then
            table.remove(MenuCache, i)
            return
        end
    end
end

---@param Func fun(Source: number)
local function MenuAction(Func)
    for _, Source in ipairs(MenuCache) do
        Func(Source)
    end
end

---@param Source number
local function GetTeam(Source)
    if Teams[Source] then return Teams[Source] end
    if TeamsCache[Source] then return Teams[TeamsCache[Source]] end

    return false
end

AddEventHandler('playerDropped', function() RemoveMenuCache(source) end)
RegisterNetEvent('mani-contracts:server:CloseMenu', function() RemoveMenuCache(source) end)

local function GenerateContract(Contract)
    if #Registered == 0 then return end

    if not Contract then
        local ContactIndex = math.random(1, #Registered)
        local Contract = Registered[ContactIndex]

        if Contract.OneTime then table.remove(Registered, ContactIndex) end
    end

    table.insert(Contracts, Contract)

    MenuAction(function(Source)
        TriggerClientEvent('mani-contracts:client:UpdateMenu', Source, Contracts)
    end)
end

CreateThread(function()
    while true do
        Wait(math.random(Config.Interval[1], Config.Interval[2]))

        GenerateContract()
    end
end)

---@return function
exports('Register', function(Contract)
    local Index = #Registered + 1
    Contract.Resource = GetInvokingResource()
    Contract.Id = Index

    Registered[Index] = Contract

    if Config.Debug then GenerateContract(Contract) end

    return function(Source, Success)
        if Success then
            local Team = GetTeam(Source)
            if Team then
                Team:SetMetadata('Contract', nil)
                Team:SetLock(false)

                local MemberAmount = #Team.Members
                local XPReward = math.floor(Contract.XPReward / MemberAmount)

                Team:Run(function(Member)
                    local MemberSource = Member.Source
                    Jet.AddMetaData(MemberSource, 'contracts:xp', XPReward)
                end)
            else
                Jet.AddMetaData(Source, 'contracts:xp', Contract.XPReward)
            end
        end

        if Contract.Limited and Config.Limited ~= 0 then
            ActiveContracts = math.max(ActiveContracts - 1, 0)
        end
    end
end)

Jet.Callback.Register('mani-contracts:server:GetMenuData', function(Source)
    AddMenuCache(Source)

    local Team = GetTeam(Source)

    local TeamsData = { InTeam = Team ~= false }

    if TeamsData.InTeam then
        TeamsData.IsLeader = Team.Leader == Source
        TeamsData.Members = Team.Members
    end

    local XP = Jet.GetMetaData(Source, 'contracts:xp', 0)
    local Level = GetLevel(XP)

    return {
        TeamsData = TeamsData,
        Contracts = Contracts,
        Level = {
            Stage = Level,
            XP = XP,
            Next = Config.Levels[Level] or XP
        }
    }
end)

Jet.Callback.Register('mani-contracts:server:StartContract', function(Source, Id)
    local Contract = Contracts[Id]

    local PoliceCount = Jet.GetJobCount(Config.PoliceJob)
    if Contract.RequiredPolice and PoliceCount < Contract.RequiredPolice then return false, 'There are not enough police online for this contract' end

    local XP = Jet.GetMetaData(Source, 'contracts:xp', 0)
    local Level = GetLevel(XP)
    if Contract.RequiredLevel > Level then return false, 'Your level is too low for this contract' end

    if not Contract or Contract.Purchased then return false, 'This contract is already in progress' end

    if Contract.Limited and Config.Limited ~= 0 then
        if ActiveContracts >= Config.Limited then return false, 'There are too many active contracts right now, try again later' end
        ActiveContracts = ActiveContracts + 1
    end

    local Team = GetTeam(Source)
    if Team then
        local Metadata = Team:GetMetadata('Contract', false)
        if Metadata then return false, "Your team is already on a contract" end

        Team:SetMetadata('Contract', true)
    end

    Contract.Purchased = true

    MenuAction(function(Source)
        TriggerClientEvent('mani-contracts:client:UpdateMenu', Source, Contracts)
    end)

    SetTimeout(300000, function()
        Contracts[Id].Removed = true

        MenuAction(function(Source)
            TriggerClientEvent('mani-contracts:client:UpdateMenu', Source, Contracts)
        end)
    end)

    return Contract
end)

Jet.Callback.Register('mani-contracts:server:CreateTeam', function(Source)
    if Teams[Source] then return false end
    Teams[Source] = TeamClass:New(Source)

    return Teams[Source]
end)

Jet.Callback.Register('mani-contracts:server:DisbandTeam', function(Source)
    if not Teams[Source] then return false end

    if Teams[Source].Locked then return false, 'Your team is locked in a contract' end

    Teams[Source]:Run(function(Member) TeamsCache[Member.Source] = nil end)
    Teams[Source] = nil

    return true
end)

Jet.Callback.Register('mani-contracts:server:InviteTeam', function(Source, Target)
    local Team = GetTeam(Source)
    if not Team then return false, "You aren't in a team" end
    if Team.Locked then return false, 'Your team is locked in a contract' end
    if #Team.Members >= Config.MaxTeamSize then return false, 'Your team is full' end
    if Teams[Target] or TeamsCache[Target] then return false, ('%s is already in a team'):format(GetPlayerName(Target)) end

    local Confirm = Jet.Callback.Await('mani-contracts:server:ConfirmInvite', Target, Source)
    if not Confirm then return false, ("%s didn't accept your invite"):format(GetPlayerName(Target)) end

    Teams[Source]:AddMember(Target)
    TeamsCache[Target] = Source

    return true
end)

Jet.Callback.Register('mani-contracts:server:KickTeamMember', function(Source, Target)
    local Team = GetTeam(Source)
    if not Team then return {} end
    if Team.Leader ~= Source then return Team.Members end

    Team:RemoveMember(Target)
    TeamsCache[Target] = nil

    return Team.Members
end)

exports('GetTeam', GetTeam)

-- TEMP STUFF

local TempNPCLocations = {
    vec4(712.06, 2532.81, 72.41, 90.03),
    -- vec4(0.0, 0.0, 0.0, 0.0)
}

local TempNPCLocations = TempNPCLocations[math.random(1, #TempNPCLocations)]
Jet.Callback.Register('mani-contracts:server:GetNPCLocation', function(Source) return TempNPCLocations end)