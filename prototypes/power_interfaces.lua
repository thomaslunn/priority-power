local sounds = require("__base__.prototypes.entity.sounds")

local HIDDEN_ENTITY_FLAGS = {
    "not-rotatable",
    "placeable-neutral",
    "not-on-map",
    "hide-alt-info",
    "not-flammable",
    "not-selectable-in-game",
    "not-upgradable",
    "not-in-kill-statistics"
}

local INPUT_PRIORITY = {
    primary = "primary-input",
    secondary = "secondary-input",
    tertiary = "tertiary"
}

local OUTPUT_PRIORITY = {
    primary = "primary-output",
    secondary = "secondary-output",
    tertiary = "tertiary"
}

local power_interfaces = {}

for priority, priority_setting in pairs(INPUT_PRIORITY) do
    table.insert(power_interfaces, {
        type = "electric-energy-interface",
        name = "pwrpty-input-interface-"..priority,
        flags = HIDDEN_ENTITY_FLAGS,
        placeable_by = {item = "pwrpty-power-transformer", count = 1},

        icon = "__priority-power__/graphics/icons/trafo.png",
        icon_size = 32,

        collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
        collision_mask = {
            layers = {item = true, object = true, player = true, water_tile = true}
        },
        selection_box = {{-1, -1}, {1, 1}},
        selection_priority = 0,

        energy_source = {
            type = "electric",
            buffer_capacity = "1kJ", -- updated dynamically
            usage_priority = priority_setting,
            input_flow_limit = "1PW",
            output_flow_limit = "0W",
            drain = "0W",
            render_no_power_icon = false
        },

        working_sound = table.deepcopy(data.raw["accumulator"]["accumulator"]["working_sound"]),
        open_sound = sounds.electric_large_open,

        hidden = true,
        hidden_in_factoriopedia = true
    })
end

for priority, priority_setting in pairs(OUTPUT_PRIORITY) do
    table.insert(power_interfaces, {
        type = "electric-energy-interface",
        name = "pwrpty-output-interface-"..priority,
        flags = HIDDEN_ENTITY_FLAGS,
        placeable_by = {item = "pwrpty-power-transformer", count = 1},

        icon = "__priority-power__/graphics/icons/trafo.png",
        icon_size = 32,

        collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
        collision_mask = {
            layers = {item = true, object = true, player = true, water_tile = true}
        },
        selection_box = {{-1, -1}, {1, 1}},
        selection_priority = 0,

        energy_source = {
            type = "electric",
            buffer_capacity = "1kJ", -- updated dynamically
            usage_priority = priority_setting,
            input_flow_limit = "0W",
            output_flow_limit = "1PW",
            drain = "0W",
            render_no_power_icon = false
        },
        
        working_sound = table.deepcopy(data.raw["accumulator"]["accumulator"]["working_sound"]),
        open_sound = sounds.electric_large_open,

        hidden = true,
        hidden_in_factoriopedia = true
    })
end

return power_interfaces