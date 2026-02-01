import QtQuick
import QtQuick.Controls
import MiraApp

Rectangle {
    id: fab
    width: 56
    height: 56
    radius: 28
    
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#444" }
        GradientStop { position: 1.0; color: "#222" }
    }
    
    border.color: Theme.divider
    border.width: 1
    
    signal clicked()

    // Shadow effect (Subtle)
    Rectangle {
        anchors.fill: parent
        radius: 28
        color: "#000000"
        opacity: 0.2
        z: -1
        anchors.topMargin: 2
    }

    Text {
        anchors.centerIn: parent
        text: "+"
        font.pixelSize: 32
        color: "#FFFFFF"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: fab.clicked()
        onPressed: fab.scale = 0.9
        onReleased: fab.scale = 1.0
    }

    Behavior on scale {
        NumberAnimation { duration: 100 }
    }
}
