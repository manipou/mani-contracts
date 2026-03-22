local Config = {}

Config.Debug = false

Config.Levels = { -- From 1 to ...
    1000,
    2500,
    5000,
    10000,
    20000,
    40000
}

Config.Limited = 1 -- Set to 0 for unlimited

Config.MaxTeamSize = 4 -- Todo: Add to UI

Config.Interval = { 600000, 900000 }

Config.PoliceJob = 'police'

return Config