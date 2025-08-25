-- Server-side function to send notifications to specific players
function SendNotificationToPlayer(playerId, notificationData)
    if not playerId or not notificationData then
        print('Error: Missing playerId or notificationData')
        return false
    end
    
    TriggerClientEvent('botz_notify:showNotification', playerId, notificationData)
    return true
end

-- Server-side function to send notifications to all players
function SendNotificationToAll(notificationData)
    if not notificationData then
        print('Error: Missing notificationData')
        return false
    end
    
    TriggerClientEvent('botz_notify:showNotification', -1, notificationData)
    return true
end

-- Export the functions for other resources to use
exports('sendNotificationToPlayer', SendNotificationToPlayer)
exports('sendNotificationToAll', SendNotificationToAll)

-- Example event handler for server-triggered notifications
RegisterNetEvent('botz_notify:serverNotification')
AddEventHandler('botz_notify:serverNotification', function(notificationData)
    local source = source
    SendNotificationToPlayer(source, notificationData)
end)

-- Command to test server-side notifications
RegisterCommand('test:serverNotification', function(source, args, rawCommand)
    local testType = args[1] or 'success'
    local testTitle = args[2] or 'Server Notification'
    local testDescription = args[3] or 'This notification was sent from the server'
    
    local notificationData = {
        type = testType,
        title = testTitle,
        description = testDescription,
        expiry = 5000,
        iconAnimation = 'bounce',
        icon = 'fa-server'
    }
    
    if source == 0 then
        -- Console command - send to all players
        SendNotificationToAll(notificationData)
    else
        -- Player command - send to specific player
        SendNotificationToPlayer(source, notificationData)
    end
end, true)
