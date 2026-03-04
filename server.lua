local Config = require 'config'

local Registered, Contracts = {}, {}

local function GenerateContract()
    if #Registered == 0 then return end

    local ContactIndex = math.random(1, #Registered)
    local Contract = Registered[ContactIndex]

    if Contract.OneTime then table.remove(Registered, ContactIndex) end

    table.insert(Contracts, Contract)
end

CreateThread(function()
    if Config.Debug then SetTimeout(1000, GenerateContract) end

    while true do
        Wait(math.random(Config.Interval[1], Config.Interval[2]))

        GenerateContract()
    end
end)

exports('Register', function(Contract) Registered[#Registered + 1] = Contract end)

Jet.Callback.Register('mani-contracts:server:GetContracts', function(Source) return Contracts end)

local TempNPCLocations = {
    vec4(712.06, 2532.81, 72.41, 90.03),
    -- vec4(0.0, 0.0, 0.0, 0.0)
}

local TempNPCLocations = TempNPCLocations[math.random(1, #TempNPCLocations)]
Jet.Callback.Register('mani-contracts:server:GetNPCLocation', function(Source) return TempNPCLocations end)

-- exports['mani-contracts']:Register({
--     Label = 'Humane Heist',
--     Image = 'https://image.link/humanelabs.png',
--     Export = 'StartHeist',
--     -- Event = 'mani-humaneheist:client:StartHeist',
--     Single = true,
--     -- Cooldown = 3 * 60 * 60 * 1000,
--     RequiredXP = 1500,
--     Active = function() return Heist.Active end
-- })