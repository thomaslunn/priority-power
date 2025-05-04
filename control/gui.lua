local transformer_settings = require("transformer_settings")

local gui = {}

local function init_storage(player)
    storage.gui.players[player.index] = {
        open_entity = nil, 
        open_position = {x = nil, y = nil}, 
        open_direction = nil, 
        open_unit_number = nil
    }
end

local function save_to_storage(player, entity)
    storage.gui.players[player.index] = {
        open_entity = entity, 
        open_position = entity.position,
        open_direction = entity.direction,
        open_unit_number = entity.unit_number
    }
end

gui.init_storage = function()
    storage.gui = {}
    storage.gui.players = {}

    for _, player in pairs(game.players) do
        init_storage(player)
    end
end 

local priority_dropdown_items = {
    {"pwrpty.primary-priority"},
    {"pwrpty.secondary-priority"},
    {"pwrpty.tertiary-priority"}
}

local function set_focussed_entity(frame, entity)
    local content_frame = frame["pwrpty-content-frame"]

    content_frame["pwrpty-input-frame"]["pwrpty-input-priority-dropdown"].selected_index = transformer_settings.get_input_priority(entity)
    content_frame["pwrpty-output-frame"]["pwrpty-output-priority-dropdown"].selected_index = transformer_settings.get_output_priority(entity)

    content_frame["pwrpty-preview-frame"]["pwrpty-entity-preview"].entity = entity
end

local function create_label(parent, text)
    local label = parent.add{type = "label", caption = text}
    label.style.padding = 3
    label.style.single_line = false
end

local function build_interface(player, entity)
    save_to_storage(player, entity)

    local main_frame = player.gui.screen.add{type="frame", name = "pwrpty-main-frame", direction = "vertical"}
    main_frame.style.maximal_width = 500
    main_frame.auto_center = true

    local title_flow = main_frame.add{type = "flow", name = "pwrpty-title-flow"}
    local title = title_flow.add{type = "label", caption = {"pwrpty.power-transformer"}, style = "frame_title"}
    title.drag_target = main_frame

    local pusher = title_flow.add{type = "empty-widget", style = "draggable_space_header"}
    pusher.style.vertically_stretchable = true
    pusher.style.horizontally_stretchable = true
    pusher.drag_target = main_frame
    title_flow.add{type = "sprite-button", name = "pwrpty-close-window", style = "frame_action_button", sprite = "utility/close"}

    local content_frame = main_frame.add{type = "frame", name = "pwrpty-content-frame", direction = "vertical", style = "entity_frame"}

    local preview_frame = content_frame.add{type = "frame", name = "pwrpty-preview-frame", style = "inside_shallow_frame"}
    local entity_preview = preview_frame.add{type = "entity-preview", name = "pwrpty-entity-preview", style = "wide_entity_button"}
    entity_preview.entity = entity

    local input_frame = content_frame.add{type = "flow", name = "pwrpty-input-frame", direction = "horizontal", style="player_input_horizontal_flow"}

    input_frame.add{type = "label", caption = {"pwrpty.input-priority-title"}, tooltip = {"pwrpty.input-priority-description"}}
    local input_spacer = input_frame.add{type = "empty-widget"}
    input_spacer.style.horizontally_stretchable = true
    local input_priority_dropdown = input_frame.add{
        type = "drop-down",
        name = "pwrpty-input-priority-dropdown",
        tooltip = {"pwrpty.input-priority-description"},
        items = priority_dropdown_items,
    }

    local output_frame = content_frame.add{type = "flow", name = "pwrpty-output-frame", direction = "horizontal", style="player_input_horizontal_flow"}

    output_frame.add{type = "label", caption = {"pwrpty.output-priority-title"}, tooltip = {"pwrpty.output-priority-description"}}
    local output_spacer = output_frame.add{type = "empty-widget"}
    output_spacer.style.horizontally_stretchable = true    
    local output_priority_dropdown = output_frame.add{
        type = "drop-down",
        name = "pwrpty-output-priority-dropdown",
        tooltip = {"pwrpty.output-priority-description"},
        items = priority_dropdown_items,
    }

    set_focussed_entity(main_frame, entity)

    return main_frame
end

gui.show = function(player_index, entity)
    local player = game.get_player(player_index)
    local frame = build_interface(player, entity)
    player.opened = frame
end

local function close_gui(event)
    local player = game.get_player(event.player_index)
    local main_frame = player.gui.screen["pwrpty-main-frame"]
    main_frame.destroy()

    player.play_sound{path = "entity-close/pwrpty-power-transformer"}
end

gui.on_gui_closed = function(event) 
    if not event.element or event.element.name ~= "pwrpty-main-frame" then
        return
    end
    close_gui(event)
end

gui.on_gui_click = function(event)
    if not event.element or event.element.name ~= "pwrpty-close-window" then
        return
    end

    close_gui(event)
end

gui.on_gui_selection_state_changed  = function(event)
    local selected_index = event.element.selected_index
    local entity = storage.gui.players[event.player_index].open_entity

    if event.element.name == "pwrpty-input-priority-dropdown" then
        transformer_settings.set_input_priority(entity, selected_index)
        return
    end

    if event.element.name == "pwrpty-output-priority-dropdown" then
        transformer_settings.set_output_priority(entity, selected_index)
        return
    end
end

gui.check_for_ghost_build_with_gui_open = function(built_entity)
    local entity_x = built_entity.position.x
    local entity_y = built_entity.position.y
    local entity_dir = built_entity.direction

    for player_index, player_storage in pairs(storage.gui.players) do
        if player_storage.open_position.x == entity_x
        and player_storage.open_position.y == entity_y
        and player_storage.open_direction == entity_dir then
            -- Update the tracked entity to point to the built one
            -- Otherwise the game will crash if they change anything!
            -- Haven't found a better way to detect manual ghost build than this
            local player = game.get_player(player_index)
            save_to_storage(player, built_entity)

            -- Update entity display
            if player.opened ~= nil and player.opened.name == "pwrpty-main-frame" then
                set_focussed_entity(player.opened, built_entity)
            end
        end
    end
end

gui.check_for_destroy_with_gui_open = function(destroyed_entity_unit_number)
    for player_index, player_storage in pairs(storage.gui.players) do
        if destroyed_entity_unit_number == player_storage.open_unit_number then
            local player = game.get_player(player_index)
            if player.opened ~= nil and player.opened.name == "pwrpty-main-frame" then
                player.opened.destroy()
            end
        end 
    end
end

gui.check_for_settings_changed_with_gui_open = function(settings_changed_dest_entity)
    for player_index, player_storage in pairs(storage.gui.players) do
        if settings_changed_dest_entity.unit_number == player_storage.open_unit_number then
            local player = game.get_player(player_index)
            if player.opened ~= nil and player.opened.name == "pwrpty-main-frame" then
                set_focussed_entity(player.opened, settings_changed_dest_entity)
            end
        end
    end
end

gui.on_player_created = function(event)
    local player = game.get_player(event.player_index)
    init_storage(player)
end

gui.get_open_entity = function(player_index)
    return storage.gui.players[player_index].open_entity
end

return gui