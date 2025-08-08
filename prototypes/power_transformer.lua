local sounds = require("__base__.prototypes.entity.sounds")

local graphics = require("graphics")

local entity = {
    type="constant-combinator",
    name="pwrpty-power-transformer",
    flags = {"placeable-player", "player-creation", "hide-alt-info"},
    minable = { mining_time = 0.8, result = "pwrpty-power-transformer" },
    placeable_by = {item = "pwrpty-power-transformer", count = 1},
    max_health = 300,

    activity_led_light_offsets = {{0, 0}, {0, 0}, {0, 0}, {0, 0}},
    circuit_wire_connection_points = {
        {wire = {}, shadow = {}},
        {wire = {}, shadow = {}},
        {wire = {}, shadow = {}},
        {wire = {}, shadow = {}},
    },

    icon = "__priority-power__/graphics/icons/trafo.png",
    icon_size = 32,
    sprites = graphics.transformer_pictures,

    collision_box = {{-0.9, -1.9}, {0.9, 1.9}},
    collision_mask = {
        layers = {item = true, object = true, player = true, water_tile = true}
    },
    selection_box = {{-1, -2}, {1, 2}},

    open_sound = sounds.electric_large_open,
    close_sound = sounds.electric_large_close,

    impact_category = "metal"
}

local item = {
    type = "item",
    name = "pwrpty-power-transformer",
    
    stack_size = 10,
    icon = "__priority-power__/graphics/icons/trafo.png",
    icon_size = 32,

    place_result = "pwrpty-power-transformer",

    subgroup = "circuit-network",
    order = "d[other]-c[power-transformer]"
}

local recipe = {
    type = "recipe",
    name = "pwrpty-power-transformer",

    ingredients = {
        {type = "item", name = "steel-plate", amount = 5},
        {type = "item", name = "electronic-circuit", amount = 5},
        {type = "item", name = "copper-cable", amount = 10},
        {type = "item", name = "battery", amount = 2}
    },
    results = {
        {type = "item", name = "pwrpty-power-transformer", amount = 1}
    },

    enabled = false,
}

local tech = {
    type = "technology",
    name = "pwrpty-power-transformer",
    icon = "__priority-power__/graphics/technologies/tier-1.png",
    icon_size = 128,

    effects = {
        {
            type = "unlock-recipe",
            recipe = "pwrpty-power-transformer"
        }
    },
    unit = {
        count = 100,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
        time = 30
    },
    
    prerequisites = {"battery", "electric-energy-distribution-1"}
}

if mods["Ultracube"] then
    require("__Ultracube__/prototypes/lib/tech_costs")

    recipe.category = "cube-fabricator-handcraft"
    recipe.ingredients = {
        {type = "item", name = "cube-basic-matter-unit", amount = 40},
        {type = "item", name = "cube-electronic-circuit", amount = 5},
        {type = "item", name = "copper-cable", amount = 10},
        {type = "item", name = "battery", amount = 2}
    }

    tech.prerequisites = {
        "cube-battery",
        "cube-electric-energy-distribution-1"
    }
    tech.unit = tech_cost_unit("1b", 100)
end

return {
    entity,
    item,
    recipe,
    tech
}