local transformer_settings = require("transformer_settings")

hidden_entities = {}

local function init_storage()
    if storage.hidden_entities == nil then
        storage.hidden_entities = {}
        storage.hidden_entities.hidden_lookup = {}
        storage.hidden_entities.transformer_lookup = {}
    end
end

hidden_entities.create =  function(entity)
    local center = entity.position
    local direction = entity.direction

    local input_position = nil
    local output_position = nil

    if direction == defines.direction.north then
        input_position = {center.x, center.y - 1}
        output_position = {center.x, center.y + 1}
    elseif direction == defines.direction.east then
        input_position = {center.x + 1, center.y}
        output_position = {center.x - 1, center.y}
    elseif direction == defines.direction.south then
        input_position = {center.x, center.y + 1}
        output_position = {center.x, center.y - 1}
    elseif direction == defines.direction.west then
        input_position = {center.x - 1, center.y}
        output_position = {center.x + 1, center.y}
    end

    local input = entity.surface.create_entity{
        name = "pwrpty-input-interface-"..transformer_settings.get_input_priority_string(entity),
        position = input_position,
        force = entity.force
    }
    input.destructible = false
    local output = entity.surface.create_entity{
        name = "pwrpty-output-interface-"..transformer_settings.get_output_priority_string(entity),
        position = output_position,
        force = entity.force
    }
    output.destructible = false

    storage.hidden_entities.hidden_lookup[entity.unit_number] = {input = input, output = output}
    storage.hidden_entities.transformer_lookup[input.unit_number] = entity
    storage.hidden_entities.transformer_lookup[output.unit_number] = entity
end

hidden_entities.get_associated_transformer = function(hidden_entity)
    return storage.hidden_entities.transformer_lookup[hidden_entity.unit_number]
end

hidden_entities.destroy = function(entity)
    local interfaces = storage.hidden_entities.hidden_lookup[entity.unit_number]

    storage.hidden_entities.hidden_lookup[entity.unit_number] = nil
    storage.hidden_entities.transformer_lookup[interfaces.input.unit_number] = nil
    storage.hidden_entities.transformer_lookup[interfaces.output.unit_number] = nil

    interfaces.input.destroy()
    interfaces.output.destroy()
end

hidden_entities.init_storage = function() 
    init_storage()
end

local function transfer_power(input, output)
    -- Don't attempt to transfer any power if both transformers are on the same electric network
    if input.electric_network_id == output.electric_network_id then
        return
    end

    -- Increase buffer sizes if the full throughput of the transformer is being used
    -- Detect this by the input buffer being full and the output buffer being near-empty
    if (input.energy / input.electric_buffer_size) > 0.99 and (output.energy / output.electric_buffer_size) < 0.01 then
        input.electric_buffer_size = input.electric_buffer_size * 2
        output.electric_buffer_size = output.electric_buffer_size * 2
    end

    if input.energy + output.energy <= output.electric_buffer_size then
        output.energy = input.energy + output.energy
        input.energy = 0
    else
        input.energy = input.energy - (output.electric_buffer_size - output.energy)
        output.energy = output.electric_buffer_size
    end

end

hidden_entities.transfer_power = function()
    for transformer, interfaces in pairs(storage.hidden_entities.hidden_lookup) do
        transfer_power(interfaces.input, interfaces.output)
    end
end

return hidden_entities