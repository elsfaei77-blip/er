import QtQuick
import QtQuick.Layouts
import MiraApp

Rectangle {
    id: root
    width: parent.width
    height: 120
    color: "transparent"
    radius: Theme.radius12
    clip: true

    // Entry Animation
    opacity: 0
    transform: Translate { id: entryTrans; y: 10 }
    
    SequentialAnimation {
        id: entryAnim
        PauseAnimation { duration: index * 50 }
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 1; duration: 400; easing.type: Easing.OutCubic }
            NumberAnimation { target: entryTrans; property: "y"; to: 0; duration: 400; easing.type: Easing.OutCubic }
        }
    }
    
    Component.onCompleted: entryAnim.start()

    RowLayout {
        anchors.fill: parent
        anchors.margins: Theme.space16
        spacing: Theme.space12

        // Avatar Placeholder
        Rectangle {
            width: Theme.avatarLarge; height: Theme.avatarLarge
            radius: width/2
            color: Theme.surfaceElevated
            clip: true
            
            ShimmerEffect {}
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: Theme.space8

            // Username Placeholder
            Rectangle {
                width: 100; height: 14; radius: 4
                color: Theme.surfaceElevated
                clip: true
                ShimmerEffect {}
            }

            // Content Placeholders
            Rectangle {
                Layout.fillWidth: true; height: 12; radius: 4
                color: Theme.surfaceElevated
                clip: true
                ShimmerEffect {}
            }
            Rectangle {
                width: parent.width * 0.7; height: 12; radius: 4
                color: Theme.surfaceElevated
                clip: true
                ShimmerEffect {}
            }
        }
    }

    // Organic Angled Shimmer Component
    component ShimmerEffect: Rectangle {
        anchors.fill: parent
        color: "transparent"
        
        Rectangle {
            id: shimmerBar
            width: parent.width * 2
            height: parent.height * 4
            anchors.centerIn: parent
            rotation: 25
            
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.4; color: "transparent" }
                GradientStop { position: 0.5; color: Theme.hoverOverlay }
                GradientStop { position: 0.6; color: "transparent" }
                GradientStop { position: 1.0; color: "transparent" }
            }
            
            PropertyAnimation on x {
                from: -parent.width * 1.5
                to: parent.width * 1.5
                duration: 2000
                loops: Animation.Infinite
                easing.type: Easing.InOutSine
            }
        }
        
        // Background Pulse
        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { from: 0.6; to: 1.0; duration: 1000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 1.0; to: 0.6; duration: 1000; easing.type: Easing.InOutSine }
        }
    }
}
