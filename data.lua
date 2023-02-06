flib = require("__flib__.data-util")

local arcopoleEntity = flib.copy_prototype(data.raw["electric-pole"]["se-pylon-substation"], "arcopole")
local arcopoleItem = flib.copy_prototype(data.raw["item"]["se-pylon-substation"], "arcopole")
local arcopoleRecipe = flib.copy_prototype(data.raw["recipe"]["se-pylon-substation"], "arcopole")

arcopoleRecipe.ingredients = {
  {"se-pylon-substation", 1},
  {"se-arcosphere-f", 1},
}

data:extend({
  arcopoleEntity,
  arcopoleItem,
  arcopoleRecipe,
})

data:extend({
    {
        icon = data.raw["technology"]["se-pylon-substation"].icon,
        icon_size = data.raw["technology"]["se-pylon-substation"].icon_size,
        type = "technology",
        name = "arcopoles",
        effects = {
            {
                type = "unlock-recipe",
                recipe=arcopoleRecipe.name
            }
        },
        prerequisites = {
            "se-pylon-substation",
            "se-teleportation"
        },
        unit = {
            count = 5000,
            time = 60,
            ingredients = {
                {"logistic-science-pack", 1},
                {"se-rocket-science-pack", 1},
                {"space-science-pack", 1},
                {"utility-science-pack", 1},
                {"production-science-pack", 1},
                {"se-astronomic-science-pack-4", 1},
                {"se-energy-science-pack-4", 1},
                {"se-deep-space-science-pack-4", 1},
            }
        },
        order = "e-h"
    }
})
