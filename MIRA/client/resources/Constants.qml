pragma Singleton
import QtQuick 2.15

QtObject {
    // --- SADEEM (NEBULA) PALETTE ---
    
    // Backgrounds
    property color background: "#050510"     // Deep Midnight Blue (Base)
    property color surface: "#181825"        // Glassy Dark
    property color surfaceHighlight: "#222233"
    
    // Accents
    property color neonBlue: "#4CC9F0"       // Starlight Cyan (Primary)
    property color neonPink: "#F72585"       // Nebula Purple/Pink (Secondary)
    property color neonGreen: "#00DA60"      // Success (kept same or tweaked)
    property color goldAccent: "#FFD700"     // Gold for stars/premium

    // Text
    property color textPrimary: "#FFFFFF"    // Star White
    property color textSecondary: "#B8C1EC"  // Stardust Grey
    property color textGlow: "#4CC9F0"       // Subtle cyan glow for text if needed
    
    // UI Lines
    property color divider: "#2A2A40"        // Subtle Blue-Grey
    property color borderGlow: "#4CC9F0"     // Cyan glow for borders
    
    // --- Architecture ---
    property int screenWidth: 400
    property int screenHeight: 800
    property int smallMargin: 8
    property int standardMargin: 16
    property int largeMargin: 24
    
    // --- Typography ---
    // Modern Sans
    property string fontFamily: "Segoe UI" 
    
    property int fontSmall: 13
    property int fontBody: 15
    property int fontTitle: 17
    property int fontHeader: 20
    property int fontDisplay: 28
    
    // --- Effects ---
    property color glowColor: "#4CC9F0"
}
