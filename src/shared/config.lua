function getConfig()
    return {

        main = {

            command = "preview",

            client = {

                notify = function(message, type)
                    return triggerEvent("notify", localPlayer, message, type)
                end
                    
            },

            server = {

                notify = function(player, message, type)
                    return triggerClientEvent(player, "notify", player, message, type)
                end,

                verify = function(player, group)
                    local acl = aclGetGroup(group)
                    local account = getPlayerAccount(player)
                    local accountName = getAccountName(account)
                    if isObjectInACLGroup("user."..accountName, acl) then 
                        return true 
                    end
                    return false
                end,

                isPlayerHasPermission = function(player)
                    local acl = aclGetGroup("Console")
                    local account = getPlayerAccount(player)
                    local accountName = getAccountName(account)
                    if isObjectInACLGroup("user."..accountName, acl) then 
                        return true 
                    end
                    return false
                end

            }

        },

        gates = {

            {

                id = 980,

                delay = 1000,

                group = "Console",

                key = {
                    x = -693.597, 
                    y = 961.21, 
                    z = 12.813,
                    r = 270
                },

                gate = {

                    closed = {
                        x = -693.489, 
                        y = 966.079, 
                        z = 12.655,
                        rx = 0,
                        ry = 0,
                        rz = 90
                    },

                    open = {
                        x = -693.489, 
                        y = 966.079, 
                        z = 8.555,
                        rx = 0,
                        ry = 0,
                        rz = 90
                    }

                }
            }

        }

    }
end