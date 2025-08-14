local hidden_entities = require("control.hidden_entities")
local gui = require("control.gui")
local transformer_settings = require("control.transformer_settings")

local function on_built(event)
    local entity = event.entity or event.created_entity


    if entity.name == "pwrpty-power-transformer" then
        transformer_settings.init_entity(entity)
        hidden_entities.create(entity)
        gui.check_for_ghost_build_with_gui_open(entity)

        script.register_on_object_destroyed(entity)
        return
    end

    if entity.name == "entity-ghost" and entity.ghost_name == "pwrpty-power-transformer" then
        transformer_settings.init_entity(entity)

        script.register_on_object_destroyed(entity)
        return
    end
end

local function on_destroy(event)
    local entity = event.entity

    if entity.name == "pwrpty-power-transformer" then
        hidden_entities.destroy(entity)
        return
    end
end

-- register-on-object-destroyed seems to be the only way to get an event to trigger when
-- a ghost entity is destroyed by placing another entity within its collision box
-- So this is needed so we can close the GUI in that case
local function on_registered_destroy(event)
    if event.type == defines.target_type.entity then
        gui.check_for_destroy_with_gui_open(event.useful_id)
    end
end

local function on_rotate(event)
    local entity = event.entity
    if entity.name ~= "pwrpty-power-transformer" then
        return
    end

    hidden_entities.destroy(entity)
    hidden_entities.create(entity)
end

function string.starts(string, start)
    return string.sub(string, 1, string.len(start)) == start
end

local function on_gui_open(event)
    if event.gui_type ~= defines.gui_type.entity then
        return
    end

    if event.entity.name == "pwrpty-power-transformer" then
        gui.show(event.player_index, event.entity)
        return
    end

    if event.entity.name == "entity-ghost" and event.entity.ghost_name == "pwrpty-power-transformer" then
        gui.show(event.player_index, event.entity)
        return
    end

    if string.starts(event.entity.name, "pwrpty-input-interface-") or string.starts(event.entity.name, "pwrpty-output-interface-") then
        local transformer = hidden_entities.get_associated_transformer(event.entity)
        gui.show(event.player_index, transformer)
        return
    end
end

local function on_settings_pasted(event)
    if event.destination.name == "pwrpty-power-transformer" then
        transformer_settings.validate_settings_after_paste(event.destination)

        hidden_entities.destroy(event.destination)
        hidden_entities.create(event.destination)

        gui.check_for_settings_changed_with_gui_open(event.destination)
    end

    if event.destination.name == "entity-ghost" and event.destination.ghost_name == "pwrpty-power-transformer" then
        transformer_settings.validate_settings_after_paste(event.destination)

        gui.check_for_settings_changed_with_gui_open(event.destination)
    end
end

local function on_init()
    gui.init_storage()
    hidden_entities.init_storage()
end

local function on_tick()
    hidden_entities.transfer_power()
end

local function on_gui_selection_state_changed(event)
    if event.element.name ~= "pwrpty-input-priority-dropdown" and event.element.name ~= "pwrpty-output-priority-dropdown" then
        return
    end

    gui.on_gui_selection_state_changed(event)

    local affected_entity = gui.get_open_entity(event.player_index)
    if affected_entity.name == "pwrpty-power-transformer" then
        -- Rebuild hidden entities with new stats
        hidden_entities.destroy(affected_entity)
        hidden_entities.create(affected_entity)
    end
end

-- init event
script.on_init(on_init)
-- player created event
script.on_event(defines.events.on_player_created, gui.on_player_created)

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

script.on_event(defines.events.on_object_destroyed, on_registered_destroy)
-- rotate events
script.on_event(defines.events.on_player_rotated_entity, on_rotate)
script.on_event(defines.events.on_player_flipped_entity, on_rotate)
-- settings paste event
script.on_event(defines.events.on_entity_settings_pasted, on_settings_pasted)

-- gui open event
script.on_event(defines.events.on_gui_opened, on_gui_open)
-- gui close event
script.on_event(defines.events.on_gui_closed, gui.on_gui_closed)
-- other gui events
script.on_event(defines.events.on_gui_click, gui.on_gui_click)
script.on_event(defines.events.on_gui_selection_state_changed , on_gui_selection_state_changed)

-- on-tick event
script.on_event(defines.events.on_tick, on_tick)