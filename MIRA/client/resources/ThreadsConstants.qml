import QtQuick 2.15

QtObject {
    // ============ SADEEM (NEBULA) EXACT COLORS ============
    
    // Backgrounds
    readonly property color background: "#050510"           // Deep Midnight Blue
    readonly property color backgroundDark: "#000000"       // Pure black
    readonly property color surface: "#B3181825"            // Glassy Dark (70% opacity)
    
    // Text Colors
    readonly property color textPrimary: "#FFFFFF"          // Star White
    readonly property color textSecondary: "#B8C1EC"        // Stardust Grey
    readonly property color textTertiary: "#7F8CA3"         // Muted Blue-Grey
    readonly property color textDisabled: "#4A4A60"         // Dark Grey
    
    // Brand Colors
    // Mapping Threads constants to Nebula constants for compatibility
    readonly property color threadsBlue: "#4CC9F0"          // Starlight Cyan
    readonly property color threadsBluePressed: "#3AB0D6"   // Darker Cyan
    readonly property color accentPurple: "#F72585"         // Nebula Pink/Purple
    
    // UI Elements
    readonly property color divider: "#2A2A40"              // Subtle Blue-Grey
    readonly property color border: "#4CC9F0"               // Cyan Border (Glowing)
    readonly property color error: "#FF0033"                // Red
    readonly property color success: "#00DA60"              // Green
    readonly property color warning: "#FFA500"              // Orange
    
    // Interactive States
    readonly property color hoverOverlay: "#4CC9F010"       // Cyan tint
    readonly property color pressedOverlay: "#4CC9F020"     // Cyan tint
    readonly property color selectedOverlay: "#4CC9F030"
    
    // ============ TYPOGRAPHY ============
    
    // Font Family
    readonly property string fontFamily: "Segoe UI"
    readonly property string fontFamilyFallback: "system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"
    
    // Font Sizes
    readonly property int fontXLarge: 28        
    readonly property int fontLarge: 22         
    readonly property int fontTitle: 18         
    readonly property int fontBody: 15          
    readonly property int fontCaption: 13       
    readonly property int fontSmall: 11         
    
    // Font Weights
    readonly property int weightLight: 300
    readonly property int weightRegular: 400
    readonly property int weightMedium: 500
    readonly property int weightSemiBold: 600
    readonly property int weightBold: 700
    
    // Line Heights
    readonly property real lineHeightTight: 1.2
    readonly property real lineHeightNormal: 1.4
    readonly property real lineHeightRelaxed: 1.6
    
    // ============ SPACING & SIZING ============
    
    readonly property int spacing1: 4
    readonly property int spacing2: 8
    readonly property int spacing3: 12
    readonly property int spacing4: 16
    readonly property int spacing5: 20
    readonly property int spacing6: 24
    readonly property int spacing8: 32
    readonly property int spacing10: 40
    readonly property int spacing12: 48
    
    // Component Sizes
    readonly property int avatarSmall: 24       
    readonly property int avatarMedium: 32      
    readonly property int avatarLarge: 64       
    readonly property int avatarXLarge: 88      
    
    readonly property int buttonHeight: 32      
    readonly property int buttonHeightLarge: 44 
    
    readonly property int iconSmall: 20
    readonly property int iconMedium: 24
    readonly property int iconLarge: 28
    
    // ============ BORDER RADIUS ============
    
    readonly property int radiusSmall: 8
    readonly property int radiusMedium: 12
    readonly property int radiusLarge: 16
    readonly property int radiusFull: 999       
    
    // ============ ANIMATIONS ============
    
    readonly property int animationFast: 150
    readonly property int animationNormal: 250
    readonly property int animationSlow: 400
    
    readonly property string easingStandard: "cubic-bezier(0.4, 0.0, 0.2, 1)"
}
