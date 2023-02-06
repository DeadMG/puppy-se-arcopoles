local event = require("__flib__.event")

function onEntityCreated(event)
    local built_entity = event.created_entity or event.entity
    if not built_entity or not built_entity.valid then return end
    
    global.arcopoles = global.arcopoles or {}
    global.arcopoles[built_entity] = true
    
    connect_arcopoles()
end

function connect_arcopoles()
    -- We need to globally verify and ensure connectivity of all arcopoles.
    
    -- First, make sure we have no "junk" arcopoles around.
    global.arcopoles = filter(global.arcopoles, function(entity) return entity.valid end)

    -- Second, if any arcopole has four non-arcopole connections, remove them until the problem is solved.
    for entity, _ in pairs(global.arcopoles) do
        local connections = entity.neighbours["copper"]
        for i, other in ipairs(filterArray(connections, function(entity) return entity.name ~= "arcopole" end)) do
            if i >= 4 then
                entity.disconnect_neighbour(other)
            end
        end
    end
    
    local graph_order = toArray(global.arcopoles, function(entity) return entity end)
    table.sort(graph_order, function(entity1, entity2) return entity1.unit_number < entity2.unit_number end)
        
    for k, entity in ipairs(graph_order) do
        local connections = filterArray(entity.neighbours["copper"], function(entity) return entity.name == "arcopole" end)
        
        local previous = graph_order[k - 1]
        local next = graph_order[k + 1]
        
        for _, other in ipairs(connections) do
            if other ~= previous and other ~= next then
                entity.disconnect_neighbour(other)
            end                
        end
        
        if previous then
            if not entity.connect_neighbour(previous) then
                log("bad things happened")
                log(serpent.block(previous))
            end
        end
            
        if next then
            if not entity.connect_neighbour(next) then
                log("other bad things happened")
                log(serpent.block(next))
            end
        end
    end
end

function filter(t, func)
    local result = {}
    for k, v in pairs(t) do
        if func(k, v) then result[k] = v end
    end
    return result
end

function filterArray(t, func)
    local result = {}
    for k, v in ipairs(t) do
        if func(v) then table.insert(result, v) end
    end
    return result
end

function toArray(original, func)
    local result = {}
    for k, v in pairs(original) do
     	table.insert(result, func(k, v))
    end
    return result
end
    
script.on_nth_tick(12, connect_arcopoles)

event.register(defines.events.on_entity_destroyed, function()
    connect_arcopoles()
end)

event.register({defines.events.on_built_entity, defines.events.on_robot_built_entity, defines.events.script_raised_built, defines.events.script_raised_revive},
  onEntityCreated,
  {
    {filter="type", type="electric-pole"},
    {filter="name", name="arcopole", mode="and"}
  }
)
