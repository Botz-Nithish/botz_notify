# Botz Notify - FiveM Notification System

A modern, customizable notification system for FiveM with beautiful animations and flexible positioning.

## Features

- 🎨 **Beautiful UI** - Modern glassmorphism design with backdrop blur
- 🎭 **Multiple Animation Types** - Spin, pulse, bounce, shake, and more
- 🎯 **Flexible Positioning** - Icon can be positioned at top, bottom, left, or right
- 🌈 **Custom Colors** - Override default colors with custom hex values
- 📱 **Responsive Design** - Works on all screen sizes
- ⚡ **Easy Integration** - Simple exports for other resources

## Installation

1. Download the resource
2. Place it in your server's resources folder
3. Add `ensure botz_notify` to your server.cfg
4. Start your server

## Usage

### Client-Side Exports

#### Basic Usage
```lua
-- Simple notification
exports['botz_notify']:showNotification({
    type = 'success',
    title = 'Success!',
    description = 'Operation completed successfully.'
})
```

#### Advanced Usage
```lua
-- Full featured notification
exports['botz_notify']:showNotification({
    type = 'warning',
    title = 'Fuel Warning',
    description = 'Fuel level is getting low. Consider pit stop strategy.',
    expiry = 5000,                    -- Duration in milliseconds (default: 5000)
    iconAnimation = 'pulse',          -- Animation type
    icon = 'fa-exclamation-triangle', -- Font Awesome icon
    iconColor = '#ff6b35',           -- Custom icon color
    borderColor = '#ff8800',         -- Custom border color
    positionIcon = 'top'             -- Icon position: 'top', 'bottom', 'left', 'right'
})
```

### Server-Side Exports

#### Send to Specific Player
```lua
-- Send notification to a specific player
exports['botz_notify']:sendNotificationToPlayer(playerId, {
    type = 'info',
    title = 'Server Message',
    description = 'This is a server notification.',
    icon = 'fa-server',
    iconAnimation = 'spin'
})
```

#### Send to All Players
```lua
-- Send notification to all players
exports['botz_notify']:sendNotificationToAll({
    type = 'success',
    title = 'Server Restart',
    description = 'Server will restart in 5 minutes.',
    expiry = 10000,
    icon = 'fa-sync',
    iconAnimation = 'spinPulse'
})
```

## Notification Types

- `success` - Green theme (default)
- `warning` - Yellow theme (default)
- `error` - Red theme (default)
- `info` - Blue theme (default)

## Animation Types

- `spin` - Continuous rotation
- `spinPulse` - Rotation with pulsing effect
- `spinReverse` - Counter-clockwise rotation
- `pulse` - Fading in and out
- `beat` - Bouncing effect
- `fade` - Opacity animation
- `beatFade` - Combined bounce and fade
- `bounce` - Bouncing animation
- `shake` - Shaking effect

## Icon Positions

- `top` - Icon above the notification (default)
- `bottom` - Icon below the notification
- `left` - Icon to the left of the notification
- `right` - Icon to the right of the notification

## Font Awesome Icons

You can use any Font Awesome icon by specifying the class name:

```lua
-- Examples
icon = 'fa-bell'           -- Bell icon
icon = 'fa-trophy'         -- Trophy icon
icon = 'fa-exclamation-triangle'  -- Warning triangle
icon = 'fa-check-circle'   -- Check mark
icon = 'fa-info-circle'    -- Info circle
icon = 'fa-times-circle'   -- X mark
icon = 'fa-heart'          -- Heart
icon = 'fa-star'           -- Star
icon = 'fa-rocket'         -- Rocket
icon = 'fa-crown'          -- Crown
```

## Examples

### Banking System
```lua
-- Money received
exports['botz_notify']:showNotification({
    type = 'success',
    title = 'Money Received',
    description = 'You received $5,000 from John Doe.',
    icon = 'fa-dollar-sign',
    iconAnimation = 'bounce',
    iconColor = '#22c55e'
})

-- Insufficient funds
exports['botz_notify']:showNotification({
    type = 'error',
    title = 'Insufficient Funds',
    description = 'You don\'t have enough money for this transaction.',
    icon = 'fa-times-circle',
    iconAnimation = 'shake',
    borderColor = '#ef4444'
})
```

### Vehicle System
```lua
-- Engine damage
exports['botz_notify']:showNotification({
    type = 'warning',
    title = 'Engine Warning',
    description = 'Your engine is taking damage. Consider repairs.',
    icon = 'fa-engine-warning',
    iconAnimation = 'pulse',
    iconColor = '#ff6b35',
    positionIcon = 'left'
})
```

### Job System
```lua
-- Job completed
exports['botz_notify']:showNotification({
    type = 'success',
    title = 'Job Completed!',
    description = 'You earned $1,500 for completing the delivery.',
    icon = 'fa-truck',
    iconAnimation = 'bounce',
    iconColor = '#ffd700',
    borderColor = '#00ff88'
})
```

## Commands

### Client Commands
- `/test:notification [type] [title] [description]` - Test client-side notifications
- `/show:nui` - Show the demo interface
- `/hide:nui` - Hide the demo interface

### Server Commands
- `/test:serverNotification [type] [title] [description]` - Test server-side notifications

## Customization

### Colors
You can customize colors by providing hex values:
- `iconColor` - Color of the icon
- `borderColor` - Color of the border and glow effect

### Duration
Set `expiry` in milliseconds to control how long the notification stays visible.

### Icon Position
Use `positionIcon` to change where the icon appears relative to the notification content.

## Dependencies

ox_lib for the menu

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue on the GitHub repository or contact the developer.

