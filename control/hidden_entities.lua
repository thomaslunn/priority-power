hidden_entities = {}

hidden_entities.create =  function(entity)
    local center = entity.position
    local direction = entity.direction

    local generator_position = nil
    local burner_position = nil

    if direction == defines.direction.north then
        generator_position = {center.x, center.y - 1}
        burner_position = {center.x, center.y + 1}
    elseif direction == defines.direction.east then
        generator_position = {center.x + 1, center.y}
        burner_position = {center.x - 1, center.y}
    elseif direction == defines.direction.south then
        generator_position = {center.x, center.y + 1}
        burner_position = {center.x, center.y - 1}
    elseif direction == defines.direction.west then
        generator_position = {center.x - 1, center.y}
        burner_position = {center.x + 1, center.y}
    end

    local generator = entity.surface.create_entity{
        name = "power-fluid-generator",
        position = generator_position,
        direction = direction,
        force = entity.force
    }
    generator.destructible = false

    local burner = entity.surface.create_entity{
        name = "power-fluid-burner",
        position = burner_position,
        direction = direction,
        force = entity.force
    }
    burner.destructible = false

    generator.fluidbox.add_linked_connection(
        1, burner, 1
    )
end

hidden_entities.destroy = function(entity)
    local bounding_box = entity.bounding_box

    for _, entity in pairs(entity.surface.find_entities_filtered{
        area = bounding_box,
        name = {"power-fluid-burner", "power-fluid-generator"}
    }) do
        entity.destroy()
    end
end

return hidden_entities