local function debugPrint(msg)
    if true then -- set 'false' to disable all 'debugPrint'.
        print(msg)
    end
end

-- Export function to show notifications from other resources
exports('showNotification', function(notificationData)
    -- Validate required fields
    if not notificationData.title or not notificationData.description or not notificationData.type then
        debugPrint('Error: Missing required notification fields (title, description, type)')
        return false
    end
    
    -- Validate notification type
    local validTypes = {'success', 'warning', 'error', 'info'}
    local isValidType = false
    for _, validType in ipairs(validTypes) do
        if notificationData.type == validType then
            isValidType = true
            break
        end
    end
    
    if not isValidType then
        debugPrint('Error: Invalid notification type. Must be one of: success, warning, error, info')
        return false
    end
    
    -- Set default values for optional fields
    local notification = {
        title = notificationData.title,
        description = notificationData.description,
        type = notificationData.type,
        expiry = notificationData.expiry or 5000,
        iconAnimation = notificationData.iconAnimation or nil,
        iconColor = notificationData.iconColor or nil,
        icon = notificationData.icon or nil,
        borderColor = notificationData.borderColor or nil,
        positionIcon = notificationData.positionIcon or 'top'
    }
    
    -- Validate icon animation if provided
    if notification.iconAnimation then
        local validAnimations = {'spin', 'spinPulse', 'spinReverse', 'pulse', 'beat', 'fade', 'beatFade', 'bounce', 'shake'}
        local isValidAnimation = false
        for _, validAnim in ipairs(validAnimations) do
            if notification.iconAnimation == validAnim then
                isValidAnimation = true
                break
            end
        end
        
        if not isValidAnimation then
            debugPrint('Warning: Invalid icon animation. Using default.')
            notification.iconAnimation = nil
        end
    end
    
    -- Validate icon position if provided
    if notification.positionIcon then
        local validPositions = {'top', 'bottom', 'left', 'right'}
        local isValidPosition = false
        for _, validPos in ipairs(validPositions) do
            if notification.positionIcon == validPos then
                isValidPosition = true
                break
            end
        end
        
        if not isValidPosition then
            debugPrint('Warning: Invalid icon position. Using default (top).')
            notification.positionIcon = 'top'
        end
    end
    
    -- Send notification to NUI
    SendNUIMessage({
        type = 'SHOW_NOTIFICATION',
        notification = notification
    })
    
    debugPrint('Notification sent: ' .. notification.title)
    return true
end)

-- Command to test notifications
RegisterCommand('test:notification', function(source, args, rawCommand)
    local testType = args[1] or 'success'
    local testTitle = args[2] or 'Test Notification'
    local testDescription = args[3] or 'This is a test notification'
    
    exports['botz_notify']:showNotification({
        type = testType,
        title = testTitle,
        description = testDescription,
        expiry = 5000,
        iconAnimation = 'bounce',
        icon = 'fa-bell'
    })
end, false)

-- Event handler for server-triggered notifications
RegisterNetEvent('botz_notify:showNotification')
AddEventHandler('botz_notify:showNotification', function(notificationData)
    exports['botz_notify']:showNotification(notificationData)
end)

RegisterCommand('show:nui', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'SHOW_PAGE' })
    debugPrint('Opened')
end)

RegisterCommand('hide:nui', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'CLOSE_PAGE' })
    debugPrint('Closed')
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)

RegisterNUICallback("debugLog", function(data, cb)
    print("^3[DEBUG]^7 " .. (data.message or "No message"))
    if data.data then
        print(json.encode(data.data))
    end
    cb("ok")
end)


RegisterCommand('test:notifyMenu', function()
    lib.registerContext({
        id = 'notify_test_menu',
        title = 'Notification Tester',
        options = {
            {
                title = 'Success (Bounce)',
                description = 'Green notification with bounce animation',
                icon = 'check',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'success',
                        title = 'Success!',
                        description = 'Everything worked perfectly.',
                        expiry = 5000,
                        iconAnimation = 'bounce',
                        icon = 'fa-check',
                    })
                    lib.showContext('notify_test_menu')
                end
                
            },
            {
                title = 'Warning (Pulse)',
                description = 'Yellow warning with pulse animation',
                icon = 'triangle-exclamation',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'warning',
                        title = 'Warning!',
                        description = 'Something might be wrong.',
                        expiry = 5000,
                        iconAnimation = 'pulse',
                        icon = 'fa-triangle-exclamation',
                    })
                    lib.showContext('notify_test_menu')
                end
                
            },
            {
                title = 'Error (Shake)',
                description = 'Red error with shake animation',
                icon = 'xmark',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'error',
                        title = 'Error!',
                        description = 'An error has occurred.',
                        expiry = 5000,
                        iconAnimation = 'shake',
                        icon = 'fa-xmark',
                    })
                    lib.showContext('notify_test_menu')
                end
                
            },
            {
                title = 'Info (Fade)',
                description = 'Blue info with fade animation',
                icon = 'circle-info',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'info',
                        title = 'Information',
                        description = 'Just letting you know.',
                        expiry = 5000,
                        iconAnimation = 'fade',
                        icon = 'fa-circle-info',
                    })
                    lib.showContext('notify_test_menu')
                end
            },
            {
                title = 'Success (Spin)',
                description = 'Green success with spinning icon',
                icon = 'check',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'success',
                        title = 'Processing...',
                        description = 'Your request is being processed.',
                        expiry = 5000,
                        iconAnimation = 'spin',
                        icon = 'fa-spinner',
                    })
                    lib.showContext('notify_test_menu')
                end
            },
            {
                title = 'Warning (Beat)',
                description = 'Yellow warning with beat animation',
                icon = 'triangle-exclamation',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'warning',
                        title = 'Caution!',
                        description = 'Proceed carefully.',
                        expiry = 5000,
                        iconAnimation = 'beat',
                        icon = 'fa-exclamation',
                    })
                    lib.showContext('notify_test_menu')
                end
            },
            {
                title = 'Error (Spin Pulse)',
                description = 'Red error with spin + pulse animation',
                icon = 'xmark',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'error',
                        title = 'Critical Error',
                        description = 'System failure detected.',
                        expiry = 5000,
                        iconAnimation = 'spinPulse',
                        icon = 'fa-bug',
                    })
                    lib.showContext('notify_test_menu')
                end
            },
            {
                title = 'Info (BeatFade)',
                description = 'Blue info with beat + fade animation',
                icon = 'circle-info',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'info',
                        title = 'Heads Up',
                        description = 'Here is some important info.',
                        expiry = 5000,
                        iconAnimation = 'beatFade',
                        icon = 'fa-lightbulb',
                    })
                    lib.showContext('notify_test_menu')
                end
            },
            {
                title = 'Custom Color',
                description = 'Purple notification with custom colors',
                icon = 'palette',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'info',
                        title = 'Custom Theme',
                        description = 'This one uses a custom purple style.',
                        expiry = 5000,
                        iconAnimation = 'pulse',
                        icon = 'fa-palette',
                        borderColor = '#a855f7',
                        iconColor = '#a855f7',
                    })
                    lib.showContext('notify_test_menu')
                end
            },
            {
                title = 'Long Expiry',
                description = 'Stays visible for 15 seconds',
                icon = 'clock',
                onSelect = function()
                    exports['botz_notify']:showNotification({
                        type = 'success',
                        title = 'Extended Notification',
                        description = 'This will stay on screen longer.',
                        expiry = 15000,
                        iconAnimation = 'bounce',
                        icon = 'fa-clock',
                    })
                    lib.showContext('notify_test_menu')
                end
            },
        }
    })

    lib.showContext('notify_test_menu')
end, false)
