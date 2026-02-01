pragma Singleton
import QtQuick

QtObject {
    id: themeRoot
    property bool isDarkMode: true
    property bool isPlatinumUser: false
    property bool isLuxuryEnabled: true
    
    // Phase 4: Internal animation clock for global transitions
    property real themeTransition: isDarkMode ? 1.0 : 0.0
    
    // --- MONOCHROMATIC LUXURY PALETTE (THE MONOLITH) ---
    // --- SADEEM (NEBULA) PALETTE ---
    property color background: "#050510" // Deep Midnight Blue
    readonly property color bgGradientStart: "#050510"
    readonly property color bgGradientEnd: "#1A1A2E" // Slightly lighter blue-purple

    readonly property color textPrimary: "#FFFFFF" // Star White
    readonly property color textSecondary: "#B8C1EC" // Stardust Grey
    readonly property color textTertiary: "#7F8CA3" // Muted Blue-Grey

    property color surface: "#B3181825" // Glassy Dark (High Transparency for Glassmorphism)
    property color surfaceLow: "#181825"
    property color surfaceHigh: "#2A2A40"
    property color surfaceElevated: "#33334D"
    property color surfaceAccent: "#4CC9F0" // Cyan
    property color toastBackground: "#2A2A40"

    property color divider: isDarkMode ? "#222222" : "#E5E5E5"
    property color storyRing: isDarkMode ? "#333333" : "#E5E5E5"
    
    // Core Accent: Pure White for Dark, Black for Light
    // Core Accent
    property color accent: "#4CC9F0" // Starlight Cyan
    property color blue: "#4CC9F0"
    property color premiumBlue: "#4CC9F0"
    
    // Functional
    property color gray: "#7F8CA3"
    property color successGreen: "#00DA60"
    property color likeRed: "#F72585" // Pink instead of Red for love
    property color purple: "#F72585"
    
    property color border: isDarkMode ? "#333333" : "#CCCCCC"
    property color glassBackground: isDarkMode ? Qt.rgba(0.05, 0.05, 0.15, 0.6) : Qt.rgba(1, 1, 1, 0.6)
    property color glassBorder: isDarkMode ? Qt.rgba(1, 1, 1, 0.1) : Qt.rgba(0, 0, 0, 0.1)
    property color hoverOverlay: isDarkMode ? Qt.rgba(255, 255, 255, 0.05) : Qt.rgba(0, 0, 0, 0.05)
    
    // --- REMOVED: LUXURY GLASSMORPHISM ---
    // readonly property real glassBlur: 20.0
    // readonly property real glassOpacity: 0.8
    
    // --- PREMIUM SHADOWS ---
    // --- PREMIUM SHADOWS ---
    readonly property color shadowColor: Qt.rgba(0, 0, 0, 0.5)
    readonly property int shadowSoft: 15
    readonly property int shadowSharp: 5

    // --- AI & INTELLIGENCE ---
    readonly property color aiAccent: "#F72585"
    readonly property color aiGlow: "#4CC9F0"
    readonly property color aiGradientStart: "#F72585"
    readonly property color aiGradientEnd: "#4CC9F0"

    // --- TYPOGRAPHY ---
    readonly property string fontFamily: "Inter, -apple-system, system-ui, sans-serif"
    readonly property int fontUsername: 15
    readonly property int fontContent: 15
    readonly property int fontTimestamp: 13
    readonly property int fontHeader: 17
    property int weightRegular: Font.Normal
    property int weightMedium: Font.Medium
    property int weightBold: Font.Bold
    
    // --- DIMENSIONS & SPACING ---
    readonly property int space4: 4
    readonly property int space8: 8
    readonly property int space12: 12
    readonly property int space16: 16
    readonly property int space20: 20
    readonly property int space24: 24
    readonly property int space32: 32
    readonly property int avatarLarge: 44
    readonly property int navHeight: 68
    readonly property int headerHeight: 56
    readonly property int screenWidth: 400
    readonly property int screenHeight: 700
    readonly property real threadLine: 1.5
    readonly property int radiusSmall: 12
    readonly property int radius12: radiusSmall // Alias for compatibility
    readonly property int radiusMedium: 24
    readonly property int radiusLarge: 32
    readonly property int radiusExtraLarge: 44
    readonly property int radiusFull: 999
    
    // --- ANIMATIONS ---
    readonly property int animFast: 150
    readonly property int animNormal: 250
    readonly property int animLuxury: 500
    
    // --- NATIVE+ EASING ---
    readonly property var springEasing: Easing.OutBack
    readonly property real springOvershoot: 1.2
    readonly property var luxuryEasing: Easing.InOutQuint
    readonly property var elasticEasing: Easing.OutElastic
    
    // --- STAGGER DELAYS ---
    readonly property int staggerDelay: 50
    
    // Helper to toggle theme with animation
    function toggleTheme() {
        isDarkMode = !isDarkMode;
    }
}
