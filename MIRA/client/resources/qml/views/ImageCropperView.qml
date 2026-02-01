import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt5Compat.GraphicalEffects
import MiraApp
import "../components"

Rectangle {
    id: root
    color: "black"

    property string imagePath: ""
    signal cropped(string path)
    signal cancelled()

    // Top Bar
    RowLayout {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.headerHeight
        z: 10

        Text {
            text: Loc.getString("cancel")
            color: "white"
            font.family: Theme.fontFamily
            font.pixelSize: 16
            Layout.leftMargin: 20
            MouseArea { anchors.fill: parent; onClicked: root.cancelled() }
        }

        Item { Layout.fillWidth: true }

        Text {
            text: Loc.getString("choose")
            color: "white"
            font.weight: Theme.weightBold
            font.family: Theme.fontFamily
            font.pixelSize: 16
            Layout.rightMargin: 20
            MouseArea { 
                anchors.fill: parent; 
                onClicked: cropAndSave()
            }
        }
    }

    // Crop Area
    Item {
        id: cropContainer
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height)
        height: width
        
        // This item will be grabbed (with circular mask)
        Item {
            id: captureArea
            anchors.fill: parent
            visible: true
            
            // The image to resize/pan
            Item {
                anchors.fill: parent
                clip: true 
                
                Image {
                    id: sourceImage
                    source: root.imagePath
                    fillMode: Image.PreserveAspectFit
                    cache: false
                    
                    // Initial centering
                    onStatusChanged: {
                        if (status === Image.Ready) {
                            x = (cropContainer.width - width) / 2
                            y = (cropContainer.height - height) / 2
                            scale = 1
                        }
                    }

                    // Panning and Zooming
                    PinchArea {
                        anchors.fill: parent
                        pinch.target: sourceImage
                        pinch.minimumScale: 0.5
                        pinch.maximumScale: 5.0
                        pinch.dragAxis: Pinch.XAndYAxis
                        
                        MouseArea {
                            anchors.fill: parent
                            drag.target: sourceImage
                            drag.axis: Drag.XAndYAxis
                            scrollGestureEnabled: false
                        }
                    }
                }
            }
        }
        
        // Display version with circular mask
        OpacityMask {
            id: maskedImage
            anchors.fill: parent
            source: captureArea
            maskSource: circleMask
            visible: false // Only used for saving
        }
        
        // Circular mask definition
        Rectangle {
            id: circleMask
            anchors.fill: parent
            radius: width / 2
            visible: false
            color: "white"
        }
        
        // Dark overlay (outside circle)
        Rectangle {
            color: Qt.rgba(0,0,0,0.6)
            anchors.left: parent.left; anchors.right: parent.right; anchors.top: parent.top
            height: (parent.height - (parent.width * 0.9)) / 2
        }
        Rectangle {
            color: Qt.rgba(0,0,0,0.6)
            anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
            height: (parent.height - (parent.width * 0.9)) / 2
        }
        Rectangle {
            color: Qt.rgba(0,0,0,0.6)
            anchors.left: parent.left; anchors.top: parent.top; anchors.bottom: parent.bottom
            width: (parent.width - (parent.width * 0.9)) / 2
            anchors.topMargin: (parent.height - (parent.width * 0.9)) / 2
            anchors.bottomMargin: (parent.height - (parent.width * 0.9)) / 2
        }
        Rectangle {
            color: Qt.rgba(0,0,0,0.6)
            anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom
            width: (parent.width - (parent.width * 0.9)) / 2
            anchors.topMargin: (parent.height - (parent.width * 0.9)) / 2
            anchors.bottomMargin: (parent.height - (parent.width * 0.9)) / 2
        }
        
        // Circular Border Indicator
        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.9
            height: width
            radius: width / 2
            color: "transparent"
            border.color: "white"
            border.width: 2
        }
    }
    
    function cropAndSave() {
        // Temporarily show masked image for capture
        maskedImage.visible = true;
        
        // Grab the masked circular image
        maskedImage.grabToImage(function(result) {
            var tempName = "cropped_" + new Date().getTime() + ".png"
            var success = result.saveToFile(tempName);
            maskedImage.visible = false; // Hide again
            root.cropped(tempName); 
        }, Qt.size(500, 500));
    }
}

