if mods["pyalienlife"] then
    -- Balance for Pyanodons by removing logistics science requirement
    data.raw.technology["pwrpty-power-transformer"].unit.ingredients = {{"automation-science-pack", 2}, {"py-science-pack-1", 1}}
end

if mods["pyalternativeenergy"] then
    -- Recreate the dependency on batteries tech for PyAE, since it removes the battery technology
    data.raw.technology["pwrpty-power-transformer"].prerequisites = {
        "electric-energy-distribution-1", "battery-mk01"
    }
end