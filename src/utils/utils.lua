function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function getMovementVector(offset)
    local camX, camY, camZ, targetX, targetY, targetZ = getCameraMatrix()
    local forwardX = targetX - camX
    local forwardY = targetY - camY
    local forwardZ = targetZ - camZ
    local forwardLength = math.sqrt(forwardX^2 + forwardY^2)
    forwardX = forwardX / forwardLength
    forwardY = forwardY / forwardLength
    return forwardX * offset.x + -forwardY * offset.y, forwardY * offset.x + forwardX * offset.y
end