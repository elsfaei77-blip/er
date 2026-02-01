import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import MiraApp

Item {
    id: root
    width: parent.width
    height: 60
    z: 2000
    
    property string mode: "logo" // "logo" or "spinner"
    property real pullPercentage: 0.0
    property bool refreshing: false
    
    onPullPercentageChanged: {
        // Native+ Pull Resistance Haptics
        var threshold = Math.floor(pullPercentage * 10) / 10
        if (threshold > 0 && threshold < 1.0 && threshold !== lastPullThreshold) {
            if (typeof HapticManager !== "undefined") HapticManager.triggerImpactLight()
            lastPullThreshold = threshold
        }
    }
    property real lastPullThreshold: 0
    
    onRefreshingChanged: {
        if (refreshing) {
            if (typeof HapticManager !== "undefined") HapticManager.triggerImpactMedium()
            if (typeof nativeToast !== "undefined") nativeToast.show("Updating your feed", "info")
        }
    }
    
    // Luxurious Bloom/Glow Layer
    Rectangle {
        id: bloomEffect
        anchors.centerIn: root.mode === "logo" ? logoContainer : spinnerContainer
        width: root.mode === "logo" ? 120 : 60; height: width
        radius: width/2
        visible: (refreshing || pullPercentage > 0.8)
        
        // Elastic Bloom Logic
        scale: refreshing ? 1.0 : (pullPercentage > 0.8 ? (pullPercentage - 0.8) * 2 : 0)
        opacity: refreshing ? 0.3 : (pullPercentage > 0.8 ? (pullPercentage - 0.8) * 0.5 : 0)
        
        RadialGradient {
            anchors.fill: parent
            visible: true
            gradient: Gradient {
                GradientStop { position: 0.0; color: root.mode === "logo" ? Theme.aiAccent : Theme.blue }
                GradientStop { position: 0.7; color: "transparent" }
            }
        }
        
        // Breathing pulse when refreshing
        SequentialAnimation on opacity {
            running: refreshing
            loops: Animation.Infinite
            NumberAnimation { from: 0.15; to: 0.35; duration: 1200; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.35; to: 0.15; duration: 1200; easing.type: Easing.InOutSine }
        }
    }

    // MODE 1: THE PREMIUM LOGO (Home Page)
    Item {
        id: logoContainer
        visible: root.mode === "logo"
        anchors.centerIn: parent
        width: 44; height: 44
        rotation: refreshing ? rotationTimer.angle : (pullPercentage * 360)
        
        // ELASTIC SENSATION: Bulge past 1.0 pull
        scale: {
            if (refreshing) return 1.0;
            if (pullPercentage <= 1.0) return 1.0;
            return 1.0 + (pullPercentage - 1.0) * 0.4; // Elastic stretch
        }
        
        MiraIcon {
            anchors.centerIn: parent
            name: "mira"
            size: 30
            color: refreshing ? Theme.aiAccent : Theme.textPrimary
            active: true
            strokeWidth: 2.8
            
            layer.enabled: refreshing
            layer.effect: DropShadow { 
                color: Qt.alpha(Theme.aiAccent, 0.4)
                radius: 8; samples: 16
            }
        }
    }
    
    // MODE 2: THE ELEGANT SPINNER (Other Pages)
    Item {
        id: spinnerContainer
        visible: root.mode === "spinner"
        anchors.centerIn: parent
        width: 24; height: 24
        rotation: rotationTimer.angle
        opacity: Math.min(pullPercentage * 2, 1.0)
        scale: Math.min(pullPercentage, 1.0)
        
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d");
                ctx.reset();
                ctx.strokeStyle = Theme.blue;
                ctx.lineWidth = 2.5;
                ctx.lineCap = "round";
                ctx.beginPath();
                ctx.arc(12, 12, 9, 0, Math.PI * 1.6);
                ctx.stroke();
            }
        }
    }

    QtObject {
        id: rotationTimer
        property real angle: 0
    }
    
    NumberAnimation {
        target: rotationTimer; property: "angle"; from: 0; to: 360
        duration: 900; loops: Animation.Infinite; running: refreshing
    }

    // Elegant Subtle Progress Line
    Rectangle {
        anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * Math.min(pullPercentage, 1.0); height: 1.5
        visible: pullPercentage > 0.1
        opacity: 0.6
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: root.mode === "logo" ? Theme.aiAccent : Theme.blue }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }
}
