local parameters = require("prototypes.mod_parameters")
local power_fluid = require("prototypes.power_fluid")
local transformer = require("prototypes.power_transformer")


data:extend(
    power_fluid
)
data:extend(
    transformer
)