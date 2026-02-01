import QtQuick
import QtQuick.Controls
import MiraApp

Rectangle {
    id: root
    anchors.fill: parent
    color: "black"
    z: 9999
    
    signal finished()
    
    // Ambient background glow
    Rectangle {
        id: glow
        anchors.centerIn: parent
        width: 300; height: 300
        radius: 150
        color: Qt.rgba(1, 1, 1, 0.03)
        scale: 0.5
        opacity: 0
    }
    
    // Logo Container
    Item {
        id: logoContainer
        anchors.centerIn: parent
        width: 120; height: 120
        scale: 0.8
        opacity: 0
        
        MiraIcon {
            name: "mira"
            size: 80
            anchors.centerIn: parent
            color: "white"
            strokeWidth: 3.5
        }
        
        Text {
            anchors.top: parent.bottom
            anchors.topMargin: 24
            anchors.horizontalCenter: parent.horizontalCenter
            text: "S A D E E M"
            color: "white"
            font.pixelSize: 18
            font.letterSpacing: 8
            font.weight: Font.DemiBold
            font.family: Theme.fontFamily
        }
    }
    
    SequentialAnimation {
        running: true
        
        // Entry
        ParallelAnimation {
            NumberAnimation { target: logoContainer; property: "opacity"; from: 0; to: 1; duration: 1200; easing.type: Easing.OutCubic }
            NumberAnimation { target: logoContainer; property: "scale"; from: 0.8; to: 1.0; duration: 1500; easing.type: Easing.OutBack }
            NumberAnimation { target: glow; property: "opacity"; from: 0; to: 1; duration: 2000 }
            NumberAnimation { target: glow; property: "scale"; from: 0.5; to: 1.5; duration: 3000; easing.type: Easing.OutCubic }
        }
        
        PauseAnimation { duration: 800 }
        
        // Exit
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 0; duration: 800; easing.type: Easing.InOutQuart }
            NumberAnimation { target: logoContainer; property: "scale"; to: 1.2; duration: 800; easing.type: Easing.InBack }
        }
        
        onFinished: root.finished()
    }
}
