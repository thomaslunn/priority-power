local hidden_entities = require("control.hidden_entities")
local gui = require("control.gui")

local function on_built(event)
    local entity = event.entity or event.created_entity
    if entity.name ~= "power-transformer" then
        return
    end

    hidden_entities.create(entity)
end

local function on_destroy(event)
    local entity = event.entity
    if entity.name ~= "power-transformer" then
        return
    end

    hidden_entities.destroy(entity)
end

local function on_rotate(event)
    local entity = event.entity
    if entity.name ~= "power-transformer" then
        return
    end

    hidden_entities.destroy(entity)
    hidden_entities.create(entity)
end

local function on_gui_open(event)
    if event.gui_type ~= defines.gui_type.entity or event.entity.name ~= "power-transformer" then
        return
    end

    gui.show(event)
end

-- build events
script.on_event(defines.events.on_built_entity, on_built)
script.on_event(defines.events.on_robot_built_entity, on_built)
script.on_event(defines.events.script_raised_revive, on_built)
script.on_event(defines.events.script_raised_built, on_built)
-- destroy events
script.on_event(defines.events.on_player_mined_entity, on_destroy)
script.on_event(defines.events.on_robot_mined_entity, on_destroy)
script.on_event(defines.events.on_entity_died, on_destroy)
script.on_event(defines.events.script_raised_destroy, on_destroy)
-- rotate events
script.on_event(defines.events.on_player_rotated_entity, on_rotate)
script.on_event(defines.events.on_player_flipped_entity, on_rotate)

-- gui open event
script.on_event(defines.events.on_gui_opened, on_gui_open)