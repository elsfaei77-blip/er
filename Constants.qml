pragma Singleton
import QtQuick 2.15

QtObject {
    // Methods for responsive sizing could be added here if needed
    
    // --- Colors ---
    // Deep black OLED friendly background
    property color background: "#000000"
    // Slightly lighter for cards/surfaces
    property color surface: "#121212"
    
    // Text
    property color textPrimary: "#FFFFFF"
    property color textSecondary: "#A0A0A0"
    property color textTertiary: "#666666" // timestamps or minor details
    
    // Brand Colors (Instagram/Threads Vibes)
    property color accentBlue: "#0095F6"
    property color accentPurple: "#D300C5"
    property color accentOrange: "#FF5E3A" // Gradient start/end often
    
    // UI Elements
    property color divider: "#262626"
    property color iconUnselected: "#B0B0B0"
    property color iconSelected: "#FFFFFF"
    property color danger: "#ED4956"

    // --- Dimensions ---
    property int screenWidth: 400
    property int screenHeight: 800
    property int standardMargin: 16
    property int smallMargin: 8
    property int largeMargin: 24
    
    // --- Typography ---
    property string fontFamily: "Segoe UI" // or generic system font
    
    property int fontSmall: 12
    property int fontBody: 14
    property int fontTitle: 17
    property int fontHeader: 22
    property int fontDisplay: 28
    
    // Font Weights (Qt use: Font.Normal, Font.Bold, etc. but we can store raw values if needed)
    // For convenience:
    property int weightLight: Font.Light
    property int weightNormal: Font.Normal
    property int weightMedium: Font.Medium
    property int weightBold: Font.Bold
    
    // --- Animation ---
    property int animDurationFast: 100
    property int animDurationNormal: 250
    property int animDurationSlow: 400
    
    // --- Effects ---
    property real defaultRadius: 12
}
