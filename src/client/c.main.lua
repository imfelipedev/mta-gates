local Gate = {}

function Gate:constructor()
    self.config = {}
    self.offsets = {}
    return self:setup()
end

function Gate:key(key, state)
    if not self.interface then
        return false
    end

    if key == "lalt" then 
        self.interface.slow = state
        return true
    end
    
    if key == "lctrl" then 
        self.interface.move = state and "other" or "normal"
        return true 
    end
    
    if not state then
        return false 
    end

    if key == "backspace" then 
        return self:toggle()
    end

    if key == "enter" then 
        local _, _, objectR = getElementRotation(self.interface.object)
        local objectX, objectY, objectZ = getElementPosition(self.interface.object)
        local x, y, z, r = round(objectX, 3), round(objectY, 3), round(objectZ, 3), round(objectR, 3)
        cancelEvent()
        setClipboard("x = "..x..", y = "..y..", z = "..z..", r = "..r)
        return self.config.main.client.notify("Posição copiada com sucesso.", "success") 
    end
    
    if key == "mouse_wheel_up" then 
        local _, _, objectRotZ = getElementRotation(self.interface.object)
        setElementRotation(self.interface.object, 0, 0, objectRotZ + 5)
        return true 
    end

    if key == "mouse_wheel_down" then 
        local _, _, objectRotZ = getElementRotation(self.interface.object)
        setElementRotation(self.interface.object, 0, 0, objectRotZ - 5)
        return true 
    end

    local offset = self.offsets[self.interface.move][key]
    if not offset then
        return false 
    end

    local x, y, z = offset.x, offset.y, offset.z
    if self.interface.move == "normal" then 
        x, y = getMovementVector(offset)
    end

    if self.interface.slow then 
        x, y, z = x * 0.1, y * 0.1, z * 0.1
    end
    
    local objectX, objectY, objectZ = getElementPosition(self.interface.object)
    cancelEvent()
    setElementPosition(self.interface.object, objectX + x, objectY + y, objectZ + z)
    return true
end

function Gate:create(object)
    if not self.interface then
        return false
    end

    if isElement(self.interface.object) then
        destroyElement(self.interface.object)
    end

    local playerX, playerY, playerZ = getElementPosition(localPlayer)
    self.interface.object = createObject(object, playerX, playerY, playerZ)
    setElementCollisionsEnabled(self.interface.object, false)
    return true
end

function Gate:open(object)
    self.interface = {
        move = "normal"
    }

    self:create(object)
    toggleControl("fire", false)
    toggleControl("action", false)
    addEventHandler("onClientKey", root, self.__key__)
    return true
end

function Gate:close()
    if isElement(self.interface.object) then
        destroyElement(self.interface.object)
    end

    self.interface = nil
    toggleControl("fire", true)
    toggleControl("action", true)
    removeEventHandler("onClientKey", root, self.__key__)
    return true
end

function Gate:toggle(object)
    if self.interface then 
        return self:close()
    end
    return self:open(object)
end

function Gate:setup()
    self.config = getConfig()

    self.__key__ = function(key, state)
        return self:key(key, state)
    end

    self.offsets = {
        normal = {
            arrow_u = {x = 1, y = 0, z = 0},
            arrow_d = {x = -1, y = 0, z = 0},
            arrow_l = {x = 0, y = 1, z = 0},
            arrow_r = {x = 0, y = -1, z = 0}
        },
        other = {
            arrow_u = {x = 0, y = 0, z = 1},
            arrow_d = {x = 0, y = 0, z = -1}
        }
    }
    return true
end

--// Global functions

addEvent("gate:preview", true)
addEventHandler("gate:preview", resourceRoot, function(object)
    return Gate:toggle(object)
end)

--// Mta events

addEventHandler("onClientResourceStart", resourceRoot, function()
    return Gate:constructor()
end)