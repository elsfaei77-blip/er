import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Item {
    id: root
    width: parent.width
    height: width
    
    property string imageSource: ""
    property string currentFilter: "none"
    
    Rectangle {
        anchors.fill: parent
        color: "black"
        
        Image {
            id: originalImage
            anchors.fill: parent
            source: root.imageSource
            fillMode: Image.PreserveAspectCrop
            visible: root.currentFilter === "none"
        }
        
        // Filtered versions (simulated with color overlays)
        Rectangle {
            anchors.fill: parent
            visible: root.currentFilter !== "none"
            
            Image {
                anchors.fill: parent
                source: root.imageSource
                fillMode: Image.PreserveAspectCrop
            }
            
            // Filter overlays
            Rectangle {
                anchors.fill: parent
                visible: root.currentFilter === "vintage"
                color: Qt.rgba(0.8, 0.6, 0.4, 0.3)
            }
            
            Rectangle {
                anchors.fill: parent
                visible: root.currentFilter === "cool"
                color: Qt.rgba(0.4, 0.6, 0.8, 0.2)
            }
            
            Rectangle {
                anchors.fill: parent
                visible: root.currentFilter === "warm"
                color: Qt.rgba(0.9, 0.5, 0.3, 0.25)
            }
            
            Rectangle {
                anchors.fill: parent
                visible: root.currentFilter === "bw"
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.5) }
                    GradientStop { position: 1.0; color: Qt.rgba(1, 1, 1, 0.5) }
                }
            }
        }
    }
    
    // Filter name overlay
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 12
        width: filterNameText.implicitWidth + 24
        height: 28
        radius: 14
        color: Qt.rgba(0, 0, 0, 0.7)
        visible: root.currentFilter !== "none"
        
        Text {
            id: filterNameText
            anchors.centerIn: parent
            text: root.currentFilter.charAt(0).toUpperCase() + root.currentFilter.slice(1)
            color: "white"
            font.pixelSize: 12
            font.weight: Font.Bold
        }
    }
}
