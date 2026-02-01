import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects // Qt 6.5+ standard effects

Item {
    id: root
    property alias source: image.source
    property int size: 40

    width: size
    height: size

    Image {
        id: image
        anchors.fill: parent
        sourceSize.width: root.size
        sourceSize.height: root.size
        fillMode: Image.PreserveAspectCrop
        visible: false // Hidden because it's used as source for MultiEffect
        
        onStatusChanged: { 
            if (status === Image.Error) {
               // handle error
            }
        }
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        radius: width / 2
        visible: false
        color: "black" // Color doesn't matter for mask, alpha does
    }

    MultiEffect {
        anchors.fill: parent
        source: image
        maskEnabled: true
        maskSource: mask
    }
    
    // Fallback/Placeholder
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: "#333"
        visible: image.status !== Image.Ready || image.source == ""
        
        Text {
            anchors.centerIn: parent
            text: "User"
            font.pixelSize: 8
            color: "#aaa"
            visible: true
        }
    }
}

