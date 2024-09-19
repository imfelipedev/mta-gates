local Gate = {}

function Gate:constructor()
    self.key = 2886
    self.gates = {}
    self.config = {}
    return self:setup()
end

function Gate:load()
    for i = 1, #self.config.gates do 
        local data = self.config.gates[i]
        local key = createObject(self.key, data.key.x, data.key.y, data.key.z, 0, 0, data.key.r)
        local gate = createObject(data.id, data.gate.closed.x, data.gate.closed.y, data.gate.closed.z, data.gate.closed.rx, data.gate.closed.ry, data.gate.closed.rz)
        self.gates[key] = { data = data, object = gate, state = "closed" }
    end
    return true
end

function Gate:preview(player, object)
    if not object then
        return false 
    end
    
    if object == "key" then 
        object = self.key
    end

    object = tonumber(object)
    if not object or object <= 0 then
        return self.config.main.server.notify(player, "Informe um id de objeto válido.", "error") 
    end

    if not self.config.main.server.isPlayerHasPermission(player) then
        return self.config.main.server.notify(player, "Você não possui permissão para executar esse comando.", "error")
    end
    return triggerClientEvent(player, "gate:preview", resourceRoot, object)
end

function Gate:click(player, object, button, state)
    if state ~= "down" then
        return false 
    end

    if button ~= "left" then
        return false 
    end

    local cache = self.gates[object]
    if not cache then
        return false 
    end

    if not self.config.main.server.verify(player, cache.data.group) then
        return false 
    end

    if cache.state == "closed" then 
        cache.state = "open"
        moveObject(cache.object, cache.data.delay, cache.data.gate.open.x, cache.data.gate.open.y, cache.data.gate.open.z)
        return true 
    end
    
    cache.state = "closed"
    moveObject(cache.object, cache.data.delay, cache.data.gate.closed.x, cache.data.gate.closed.y, cache.data.gate.closed.z)
    return true
end

function Gate:setup()
    self.config = getConfig()

    self.__preview__ = function(player, _, object)
        return self:preview(player, object)
    end

    self.__click__ = function(button, state, player)
        return self:click(player, source, button, state)
    end

    self:load()
    addCommandHandler(self.config.main.command, self.__preview__)
    addEventHandler("onElementClicked", resourceRoot, self.__click__)
    return outputDebugString(resourceName.." - resource loaded successfully.", 4, 134, 239, 172)
end

--// Mta events

addEventHandler("onResourceStart", resourceRoot, function()
    return Gate:constructor()
end)