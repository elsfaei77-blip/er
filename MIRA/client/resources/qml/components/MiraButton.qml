import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import MiraApp

Item {
    id: root
    
    // API
    property string text: ""
    property string icon: ""
    property string type: "primary" // primary, secondary, destructive, ghost, outline
    property bool disabled: false
    property bool loading: false
    property int heightFixed: 44
    property int radius: Theme.radiusFull
    property int fontSize: 15
    
    signal clicked()
    
    implicitHeight: heightFixed
    implicitWidth: contentLayout.implicitWidth + (type === "ghost" ? 16 : 32)
    
    // Logic
    property color bgColor: {
        if (disabled) return Theme.surfaceElevated;
        switch(type) {
            case "primary": return Theme.accent;
            case "secondary": return Theme.surface;
            case "destructive": return Theme.likeRed;
            case "ghost": return "transparent";
            case "outline": return "transparent";
            default: return Theme.accent;
        }
    }
    
    property color textColor: {
        if (disabled) return Theme.textTertiary;
        switch(type) {
            case "primary": return Theme.background; // Block on White/White on Black
            case "secondary": return Theme.textPrimary;
            case "destructive": return "white";
            case "ghost": return Theme.textPrimary;
            case "outline": return Theme.textPrimary;
            default: return Theme.background;
        }
    }
    
    property color borderColor: {
        if (type === "outline") return Theme.divider;
        if (type === "secondary") return Theme.divider;
        return "transparent";
    }
    
    property var gradientData: null
    
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: root.radius
        color: root.gradientData ? "transparent" : root.bgColor
        gradient: root.gradientData
        border.color: root.borderColor
        border.width: (type === "outline" || type === "secondary") ? 1 : 0
        
        Behavior on color { ColorAnimation { duration: Theme.animFast } }
        Behavior on scale { 
            NumberAnimation { 
                duration: Theme.animNormal; 
                easing.type: Theme.springEasing
                easing.amplitude: Theme.springOvershoot 
            } 
        }
        
        // Premium Glow/Shadow
        layer.enabled: root.type === "primary"
        layer.effect: DropShadow {
            transparentBorder: true
            color: Theme.shadowColor
            radius: Theme.shadowSoft
            samples: 16
            verticalOffset: 4
            horizontalOffset: 0
        }
    }
    
    property string emoji: ""
    
    RowLayout {
        id: contentLayout
        anchors.centerIn: parent
        spacing: 6
        
        MiraIcon {
            visible: root.icon !== "" && !root.loading && root.emoji === ""
            name: root.icon
            size: root.fontSize + 4
            color: root.textColor
        }
        
        Text {
            visible: root.emoji !== "" && !root.loading
            text: root.emoji
            font.pixelSize: root.fontSize
        }
        
        Text {
            visible: !root.loading
            text: root.text
            color: root.textColor
            font.pixelSize: root.fontSize
            font.weight: Font.Bold
            font.family: Theme.fontFamily
        }
        
        BusyIndicator {
            visible: root.loading
            running: root.loading
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !root.disabled && !root.loading
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onPressed: {
            bg.scale = 0.96
            kineticWave.start()
        }
        onReleased: {
            bg.scale = 1.0
            root.clicked()
            if (typeof HapticManager !== "undefined") {
                if (root.type === "destructive") HapticManager.triggerImpactHeavy()
                else HapticManager.triggerImpactLight()
            }
        }
        onCanceled: {
            bg.scale = 1.0
        }
    }

    // KINETIC FEEDBACK: Expanding subtle wave
    Rectangle {
        id: wave
        width: 10; height: 10; radius: 5
        color: "white"; opacity: 0
        anchors.centerIn: parent
        visible: root.type === "primary"
        
        ParallelAnimation {
            id: kineticWave
            NumberAnimation { target: wave; property: "width"; from: 10; to: root.width * 2; duration: 400; easing.type: Easing.OutQuart }
            NumberAnimation { target: wave; property: "height"; from: 10; to: root.width * 2; duration: 400; easing.type: Easing.OutQuart }
            SequentialAnimation {
                NumberAnimation { target: wave; property: "opacity"; from: 0; to: 0.15; duration: 100 }
                NumberAnimation { target: wave; property: "opacity"; to: 0; duration: 300 }
            }
            // GLOW BLOOM (PHASE 9)
            SequentialAnimation {
                NumberAnimation { target: glowBloom; property: "glowRadius"; from: 0; to: 40; duration: 400; easing.type: Easing.OutQuart }
                NumberAnimation { target: glowBloom; property: "opacity"; from: 0; to: 0.3; duration: 50 }
                NumberAnimation { target: glowBloom; property: "opacity"; to: 0; duration: 350 }
            }
        }
    }

    RectangularGlow {
        id: glowBloom
        anchors.fill: parent
        glowRadius: 0
        spread: 0.2
        color: root.type === "primary" ? Theme.accent : Theme.surfaceElevated
        cornerRadius: root.radius + glowRadius
        opacity: 0
        z: -1
    }
}
