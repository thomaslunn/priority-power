local gui = {}

local function build_interface(player)
    local player_storage = storage.players[player.index]
    
    local main_frame = player.gui.screen.add{type="frame", name = "pwrpty-main-frame", caption={"pwrpty.power-transformer"}}
    main_frame.style.size = {385, 165}
    main_frame.auto_center = true

    player_storage.elements.main_frame = main_frame
    
    local content_frame = main_frame.add{type = "frame", name = "pwrpty-content-frame", direction = "vertical"}



    return main_frame
end

gui.show = function(event)
    local player = game.get_player(event.player_index)
    local frame = build_interface(player)
    player.opened = frame
end

return gui