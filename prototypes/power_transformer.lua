local graphics = require("graphics")

local entity = {
    type="boiler",
    name="power-transformer",
    flags = {"placeable-player", "player-creation"},
    minable = { mining_time = 0.8, result = "power-transformer" },
    placeable_by = {item = "power-transformer", count = 1},
    max_health = 300,

    energy_source = {
        type = "void"
    },
    energy_consumption = "1W",

    fluid_box = {
        volume = 1,
        pipe_connections = {},
        hide_connection_info = true
    },
    output_fluid_box = {
        volume = 1,
        pipe_connections = {},
        hide_connection_info = true
    },
    burning_cooldown = 0,

    icon = "__priority-power__/graphics/icons/trafo.png",
    icon_size = 32,
    pictures = graphics.transformer_pictures,

    collision_box = {{-0.9, -1.9}, {0.9, 1.9}},
    collision_mask = {
        layers = {item = true, object = true, player = true, water_tile = true}
    },
    selection_box = {{-1, -2}, {1, 2}},
}
local item = {
    type = "item",
    name = "power-transformer",
    
    stack_size = 50,
    icon = "__priority-power__/graphics/icons/trafo.png",
    icon_size = 32,

    place_result = "power-transformer",
}

return {
    entity,
    item
}