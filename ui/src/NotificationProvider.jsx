'use client'

import React, { createContext, useContext, useState, useCallback, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Bell, CheckCircle, AlertTriangle, XCircle, Info } from 'lucide-react'

// Context
const NotificationContext = createContext(undefined)

export const useNotifications = () => {
  const context = useContext(NotificationContext)
  if (!context) throw new Error('useNotifications must be used within a NotificationProvider')
  return context
}

const getIcon = (type) => {
  switch (type) {
    case 'success': return CheckCircle
    case 'warning': return AlertTriangle
    case 'error': return XCircle
    case 'info': return Info
    default: return Bell
  }
}

// color presets
const getTypeColorPresets = (type) => {
  const presets = {
    success: { primary: '#22c55e', border: '#22c55e', glow: '#22c55e', iconBg: '#22c55e', iconColor: '#22c55e' },
    warning: { primary: '#eab308', border: '#eab308', glow: '#eab308', iconBg: '#eab308', iconColor: '#eab308' },
    error: { primary: '#ef4444', border: '#ef4444', glow: '#ef4444', iconBg: '#ef4444', iconColor: '#ef4444' },
    info: { primary: '#3b82f6', border: '#3b82f6', glow: '#3b82f6', iconBg: '#3b82f6', iconColor: '#3b82f6' },
  }
  return presets[type]
}

const getAnimationClass = (animation) => {
  switch (animation) {
    case 'spin': return 'animate-spin'
    case 'spinPulse': return 'animate-spin animate-pulse'
    case 'pulse': return 'animate-pulse'
    case 'beat': return 'animate-bounce'
    case 'fade': return 'animate-pulse opacity-50'
    case 'beatFade': return 'animate-bounce animate-pulse'
    case 'bounce': return 'animate-bounce'
    case 'shake': return 'animate-bounce'
    default: return ''
  }
}

// hex → rgba
const hexToRgba = (hex, opacity) => {
  const r = parseInt(hex.slice(1, 3), 16)
  const g = parseInt(hex.slice(3, 5), 16)
  const b = parseInt(hex.slice(5, 7), 16)
  return `rgba(${r}, ${g}, ${b}, ${opacity})`
}

const NotificationItem = ({ notification, index, onRemove }) => {
  const IconComponent = getIcon(notification.type)
  const typePresets = getTypeColorPresets(notification.type)
  const animationClass = getAnimationClass(notification.iconAnimation)
  const iconPosition = notification.positionIcon || 'top'

  useEffect(() => {
    const timer = setTimeout(() => onRemove(notification.id), notification.expiry || 5000)
    return () => clearTimeout(timer)
  }, [notification.id, notification.expiry, onRemove])

  // spread logic
  const GAP = 260
  let offsetX = 0
  if (index > 0) {
    const side = index % 2 === 0 ? 1 : -1
    const step = Math.ceil(index / 2)
    offsetX = side * step * GAP
  }

  const scale = index === 0 ? 1 : 0.8
  const opacity = index === 0 ? 1 : 0.6

  // colors
  const finalBorderColor = notification.borderColor || typePresets.border
  const finalIconColor = notification.iconColor || typePresets.iconColor
  const finalIconBgColor = notification.borderColor || typePresets.iconBg

  const borderStyle = { borderColor: finalBorderColor }
  const glowStyle = { boxShadow: `0 0 1px ${hexToRgba(finalBorderColor, 0.2)}` }
  const iconBgStyle = { backgroundColor: hexToRgba(finalIconBgColor, 0.2) }

  return (
    <motion.div
      initial={{ scale: 0.8, opacity: 0, y: 40 }}
      animate={{ x: offsetX, scale, opacity, zIndex: 50 - index }}
      exit={{ opacity: 0, scale: 0.5, y: -40 }}
      transition={{ type: "spring", stiffness: 300, damping: 30 }}
      className="absolute"
      style={{ transformOrigin: 'center center' }}
    >
      <div className={`relative ${iconPosition === 'top'
        ? 'flex flex-col items-center'
        : iconPosition === 'bottom'
          ? 'flex flex-col-reverse items-center'
          : iconPosition === 'left'
            ? 'flex flex-row items-center'
            : 'flex flex-row-reverse items-center'
        }`}
      >
        {/* Icon */}
        <div className={iconPosition === 'top' ? 'mb-6' : iconPosition === 'bottom' ? 'mt-6' : iconPosition === 'left' ? 'mr-6' : 'ml-6'}>
          <div className="w-14 absolute h-14 rotate-45 border-2 flex items-center justify-center relative"
            style={{
              backgroundColor: "rgba(0, 0, 0, 0.5)", // <-- translucent black
              border:`1px solid ${finalBorderColor}`,
              ...borderStyle,
              ...glowStyle
            }}>
            <div className="-rotate-45 rounded-full p-1" style={iconBgStyle}>
              {notification.icon
                ? <i className={`fa-solid ${notification.icon} text-2xl ${animationClass}`} style={{ color: finalIconColor }} />
                : <IconComponent className={`w-10 h-10 ${animationClass}`} style={{ color: finalIconColor }} />}
            </div>
          </div>
        </div>

        {/* Content */}
        <div
          className="relative w-80 p-3 rounded-2xl transition-all duration-300 overflow-hidden"
          style={{
            backgroundColor: "rgba(0, 0, 0, 0.5)", // <-- translucent black
            border:`1px solid ${finalBorderColor}`,
            ...borderStyle,
            ...glowStyle
          }}
        >
          <h3 className="text-white text-center font-bold text-lg mb-2 tracking-wide">{notification.title}</h3>
          <p className="text-gray-300 text-sm leading-relaxed">{notification.description}</p>

          <div className="absolute bottom-0 left-0 right-0 h-2 bg-white/10">
            <motion.div
              className="h-full"
              style={{
                backgroundColor: finalBorderColor,
                background: `linear-gradient(to right, ${finalBorderColor}, ${hexToRgba(finalBorderColor, 0.8)})`
              }}
              initial={{ width: '100%' }}
              animate={{ width: '0%' }}
              transition={{ duration: (notification.expiry || 5000) / 1000, ease: 'linear' }}
            />
          </div>
        </div>
      </div>
    </motion.div>
  )
}

export const NotificationProvider = ({ children }) => {
  const [notifications, setNotifications] = useState([])

  const addNotification = useCallback((notification) => {
    const id = `notification-${Date.now()}-${Math.random()}`
    setNotifications(prev => [{ ...notification, id }, ...prev])
  }, [])

  const removeNotification = useCallback((id) => {
    setNotifications(prev => prev.filter(n => n.id !== id))
  }, [])

  return (
    <NotificationContext.Provider value={{ notifications, addNotification, removeNotification }}>
      {children}
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" crossOrigin="anonymous" referrerPolicy="no-referrer" />
      <div className="fixed top-24 left-1/2 -translate-x-1/2 -translate-y-1/2 pointer-events-none z-50">
        <div className="relative w-[1000px] h-[500px] flex items-center justify-center">
          <AnimatePresence>
            {notifications.map((notification, index) => (
              <NotificationItem key={notification.id} notification={notification} index={index} onRemove={removeNotification} />
            ))}
          </AnimatePresence>
        </div>
      </div>
    </NotificationContext.Provider>
  )
}
