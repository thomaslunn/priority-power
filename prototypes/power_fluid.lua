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

local power_fluid = {
    type = "fluid",
    name = "power-fluid",

    icon = "__base__/graphics/icons/signal/signal-lightning.png",
    icon_size = 64,
    base_color = {0.8, 0.8, 0},
    flow_color = {0.8, 0.8, 0},

    fuel_value = "1kJ",
    default_temperature = 15,

    auto_barrel = false,
    hidden = true,
    hidden_in_factoriopedia = true
}

local create_power_fluid_recipe_category = {
    type = "recipe-category",
    name = "power-fluid-generation",
    hidden = true,
    hidden_in_factoriopedia = true
}

local create_power_fluid_recipe = {
    type = "recipe",
    name = "create-power-fluid",
    category = "power-fluid-generation",
    ingredients = {},
    results = {
        {type = "fluid", name = "power-fluid", amount = 1000}
    },
    energy_required = 1,
    
    hide_from_stats = true,
    hide_from_player_crafting = true,
    hide_from_signal_gui = true,
    hidden = true,
    hidden_in_factoriopedia = true
}

local power_fluid_generator = {
    type = "assembling-machine",
    name = "power-fluid-generator",
    flags = {"placeable-neutral", "not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-selectable-in-game"},

    icon = "__priority-power__/graphics/icons/trafo.png",
    icon_size = 32,

    collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
    collision_mask = {
        layers = {item = true, object = true, player = true, water_tile = true}
    },
    selection_box = {{-1, -1}, {1, 1}},
    selection_priority = 0,

    fixed_recipe = "create-power-fluid",
    energy_usage = "1MW",
    crafting_speed = 1,
    crafting_categories = {"power-fluid-generation"},
    energy_source = { 
        type = "electric",
        usage_priority = "tertiary",
        render_no_power_icon = false,
        drain = "0W",
    },

    fluid_boxes = {
        {
            volume = 1000,
            production_type = "output",
            pipe_connections = {
                {
                    flow_directionn = "output",
                    connection_type = "linked",
                    linked_connection_id = 1
                }
            }
        }
    },

    show_recipe_icon = false,
    show_recipe_icon_on_map = false,
    hidden = true,
    hidden_in_factoriopedia = true
}

local power_fluid_burner = {
    type = "generator",
    name = "power-fluid-burner",
    flags = {"placeable-neutral", "not-on-map", "not-deconstructable", "not-blueprintable", "not-selectable-in-game"},

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
        usage_priority = "primary-output",
        buffer_capacity = "1MJ",
        render_no_power_icon = false
    },
    fluid_box = {
        filter = "power-fluid",
        volume = 1000,
        pipe_connections = {
            {
                flow_direction = "input",
                connection_type = "linked",
                linked_connection_id = 1
            }
        }
    },
    fluid_usage_per_tick = 1000/60,
    maximum_temperature = 15,
    burns_fluid = true,

    hidden = true,
    hidden_in_factoriopedia = true
}

return {
    power_fluid,
    create_power_fluid_recipe_category,
    create_power_fluid_recipe,
    power_fluid_generator,
    power_fluid_burner,
}