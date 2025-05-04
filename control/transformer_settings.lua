local transformer_settings = {}

-- The following virtual signals are set in the transformer/combinator to save it's state
-- This internal representation of the setting is used to create the correct generator + burner when the transformer is created
-- Storing the settings as signals in a constant combinator allows the transformer to support copy-paste

-- The following signals are used:
local signals = {
    INPUT_PRIORITY = "down-arrow",
    OUTPUT_PRIORITY = "up-arrow"
}
-- stored in the following slots:
local slots = {
    INPUT_PRIORITY = 1,
    OUTPUT_PRIORITY = 2
}
-- where, for input/output priority:
local priority = {
    PRIMARY = 1,
    SECONDARY = 2,
    TERTIARY = 3
}
local priority_lookup = {
    [1] = "primary",
    [2] = "secondary",
    [3] = "tertiary"
}

local reset_logistic_sections = function(entity)
    local logistic_sections = entity.get_logistic_sections()
    -- remove any existing sections
    local section_count = logistic_sections.sections_count

    for i=section_count,1,-1 do
        logistic_sections.remove_section(i)
    end

    -- add the new section
    local new_section = logistic_sections.add_section()
    new_section.set_slot(slots.INPUT_PRIORITY, {value = signals.INPUT_PRIORITY, min = priority.TERTIARY})
    new_section.set_slot(slots.OUTPUT_PRIORITY, {value = signals.OUTPUT_PRIORITY, min = priority.PRIMARY})
end

-- Returns true if the entity has valid settings to be a transformer
local function verify_valid_settings(entity)
    local logistic_sections = entity.get_logistic_sections()
    if logistic_sections.sections_count ~= 1 then
        return false
    end

    local section = logistic_sections.get_section(1)
    if not section.is_manual or section.filters_count ~= 2 then
        return false
    end

    local input_slot = section.get_slot(slots.INPUT_PRIORITY)
    local output_slot = section.get_slot(slots.OUTPUT_PRIORITY)

    if input_slot == nil or input_slot.value.name ~= signals.INPUT_PRIORITY
    or output_slot == nil or output_slot.value.name ~= signals.OUTPUT_PRIORITY then
        return false
    end
    -- satisfied that this is a valid transformer that has already been set up
    return true
end

transformer_settings.init_entity = function(entity) 
    local valid_settings = verify_valid_settings(entity)

    -- retain any values already set, as these were set by copy-paste/blueprint
    if not valid_settings then
        reset_logistic_sections(entity)
    end
end

transformer_settings.get_input_priority = function(entity)
    local section = entity.get_logistic_sections().get_section(1)
    return section.get_slot(slots.INPUT_PRIORITY).min
end

transformer_settings.get_output_priority = function(entity)
    local section = entity.get_logistic_sections().get_section(1)
    return section.get_slot(slots.OUTPUT_PRIORITY).min
end

transformer_settings.get_input_priority_string = function(entity)
    return priority_lookup[transformer_settings.get_input_priority(entity)]
end

transformer_settings.get_output_priority_string = function(entity)
    return priority_lookup[transformer_settings.get_output_priority(entity)]
end

transformer_settings.set_input_priority = function(entity, value)
    local section = entity.get_logistic_sections().get_section(1)
    return section.set_slot(slots.INPUT_PRIORITY, {value = signals.INPUT_PRIORITY, min = value})
end

transformer_settings.set_output_priority = function(entity, value)
    local section = entity.get_logistic_sections().get_section(1)
    return section.set_slot(slots.OUTPUT_PRIORITY, {value = signals.OUTPUT_PRIORITY, min = value})
end

transformer_settings.validate_settings_after_paste = function(entity)
    if not verify_valid_settings(entity) then
        -- Not sure this paste is preventable
        -- So fix the invalid state and paste a warning in the console
        reset_logistic_sections(entity)
        -- TODO: locale this
        game.print(string.format("[font=default-large-bold][color=red]WARNING[/color][/font] - Pasting onto [entity=pwrpty-power-transformer] at [gps=%s,%s] has reset its settings to default.", entity.position.x, entity.position.y))
    end
end

return transformer_settings