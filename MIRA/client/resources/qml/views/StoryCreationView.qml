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
    
    signal closed()
    signal storyPosted()
    
    ThreadModel { id: threadModel }
    
    property string selectedImagePath: ""
    property var stickers: [] // Array of {x, y, text, scale, rotation}
    property bool isDrawing: false
    property color brushColor: "white"
    
    // Canvas for Drawing
    Canvas {
        id: drawingCanvas
        anchors.fill: parent
        z: 5
        visible: root.isDrawing
        
        property int lastX: 0
        property int lastY: 0
        
        onPaint: {
            var ctx = getContext("2d");
            ctx.lineWidth = 5;
            ctx.lineCap = "round";
            ctx.strokeStyle = root.brushColor;
            ctx.beginPath();
            ctx.moveTo(lastX, lastY);
            ctx.lineTo(drawArea.mouseX, drawArea.mouseY);
            ctx.stroke();
            lastX = drawArea.mouseX;
            lastY = drawArea.mouseY;
        }
        
        MouseArea {
            id: drawArea
            anchors.fill: parent
            enabled: root.isDrawing
            onPressed: {
                drawingCanvas.lastX = mouseX;
                drawingCanvas.lastY = mouseY;
            }
            onPositionChanged: drawingCanvas.requestPaint()
        }
    }

    // Main Content Layer
    Item {
        id: contentArea
        anchors.fill: parent
        
        // 1. Background Image
        Image {
            id: bgImage
            anchors.fill: parent
            source: root.selectedImagePath
            fillMode: Image.PreserveAspectCrop
            visible: root.selectedImagePath !== ""
        }
        
        // Placeholder
        Rectangle {
            anchors.fill: parent
            color: Theme.surface
            visible: root.selectedImagePath === ""
            
            Column {
                anchors.centerIn: parent
                spacing: 20
                MiraIcon { name: "camera"; size: 64; color: Theme.textSecondary; anchors.horizontalCenter: parent.horizontalCenter }
                Text { text: qsTr("Tap to create story"); color: Theme.textPrimary; font.pixelSize: 18 }
            }
            MouseArea { anchors.fill: parent; onClicked: fileDialog.open() }
        }

        // 2. Stickers Layer
        Repeater {
            model: root.stickers
            delegate: Item {
                x: modelData.x; y: modelData.y
                width: 100; height: 100
                rotation: modelData.rotation || 0
                scale: modelData.scale || 1.0
                
                Text {
                    anchors.centerIn: parent
                    text: modelData.text
                    font.pixelSize: 64
                }
                
                MouseArea {
                    anchors.fill: parent
                    drag.target: parent
                    drag.axis: Drag.XAndYAxis
                    // Pinch/Rotate logic would go here
                }
            }
        }
        
        // 3. Text Overlay (Single scalable item for now)
        Item {
            id: textOverlay
            x: 100; y: 200
            visible: textInputObj.text !== "" && !textInputObj.visible
            
            Text {
                text: textInputObj.text
                color: textInputObj.color
                font.pixelSize: 32
                font.weight: Theme.weightBold
                style: Text.Outline; styleColor: "black"
            }
            
            MouseArea {
                anchors.fill: parent
                drag.target: textOverlay
            }
        }
    }

    // UI Controls (Overlay)
    Item {
        id: uiControls
        anchors.fill: parent
        z: 10
        visible: !textInputObj.visible
        
        // Top Bar
        RowLayout {
            anchors.top: parent.top; anchors.topMargin: 16
            anchors.left: parent.left; anchors.right: parent.right
            anchors.margins: 16
            
            MiraIcon {
                name: "close"
                size: 28
                color: "white"
                MouseArea { anchors.fill: parent; onClicked: root.closed() }
            }
            
            Item { Layout.fillWidth: true }
            
            // Tools
            RowLayout {
                spacing: 20
                
                MiraIcon {
                    name: "text_aa"; size: 28; color: "white"
                    MouseArea { anchors.fill: parent; onClicked: { textInputObj.visible = true; textInputObj.forceActiveFocus() } }
                }
                
                MiraIcon {
                    name: "sparkle" // Sticker icon
                    size: 28; color: "white"
                    MouseArea { anchors.fill: parent; onClicked: stickerDrawer.open() }
                }
                
                MiraIcon {
                    name: "create" // Draw icon
                    size: 28; color: root.isDrawing ? Theme.accent : "white"
                    MouseArea { 
                        anchors.fill: parent; 
                        onClicked: {
                            root.isDrawing = !root.isDrawing
                            // Clear canvas if toggled off? or Keep?
                        } 
                    }
                }
            }
        }
        
        // Bottom Controls
        ColumnLayout {
            anchors.bottom: parent.bottom
            anchors.left: parent.left; anchors.right: parent.right
            spacing: 16
            
            // Filter Selector
            ScrollView {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                contentWidth: filtersRow.implicitWidth + 32
                clip: true
                visible: root.selectedImagePath !== ""
                
                RowLayout {
                    id: filtersRow
                    anchors.centerIn: parent
                    spacing: 12
                    
                    Repeater {
                        model: ["Normal", "Paris", "Oslo", "Lagos", "Melbourne", "Jakarta", "Abu Dhabi"]
                        delegate: Column {
                            spacing: 4
                            Rectangle {
                                width: 50; height: 50; radius: 25
                                color: "transparent"
                                clip: true
                                border.color: index === 0 ? "white" : "transparent"
                                border.width: 2
                                Image {
                                    anchors.fill: parent; anchors.margins: 2
                                    source: root.selectedImagePath; fillMode: Image.PreserveAspectCrop
                                    opacity: 0.7
                                }
                            }
                            Text { 
                                text: modelData; color: "white"; font.pixelSize: 10; anchors.horizontalCenter: parent.horizontalCenter 
                                font.weight: index === 0 ? Font.Bold : Font.Normal
                            }
                        }
                    }
                }
            }
            
            // Action Bar
            RowLayout {
                Layout.fillWidth: true
                Layout.margins: 20
                Layout.bottomMargin: 20
                
                // Save Button
                Rectangle {
                    width: 40; height: 40; radius: 20
                    color: Qt.rgba(1,1,1,0.2)
                    MiraIcon { anchors.centerIn: parent; name: "download"; size: 20; color: "white" }
                }
                
                Item { Layout.fillWidth: true }
                
                // Post Button
                Rectangle {
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 44
                    radius: 22
                    color: "white"
                    
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        Image { 
                            source: authService.currentUser.avatar || ""
                            sourceSize: Qt.size(24,24)
                            Layout.preferredWidth: 24; Layout.preferredHeight: 24
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: Rectangle { width: 24; height: 24; radius: 12 }
                            }
                        }
                        Text { text: qsTr("Your Story"); color: "black"; font.weight: Font.Bold }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onPressed: parent.scale = 0.95
                        onReleased: parent.scale = 1.0
                        onClicked: {
                            // Save logic
                             contentArea.grabToImage(function(result) {
                                var tempName = "story_" + new Date().getTime() + ".png"
                                result.saveToFile(tempName);
                                var fileToUpload = tempName;
                                threadModel.createStory(fileToUpload); 
                                root.storyPosted()
                            });
                        }
                    }
                    Behavior on scale { NumberAnimation { duration: 100 } }
                }
                
                // Close Friends
                Rectangle {
                    width: 44; height: 44; radius: 22
                    color: Theme.successGreen
                    MiraIcon { anchors.centerIn: parent; name: "star"; size: 20; color: "white" }
                }
            }
        }
    }
    
    // Text Input Overlay
    Rectangle {
        id: textInputOverlay
        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.8)
        visible: textInputObj.visible
        z: 20
        
        MouseArea { anchors.fill: parent; onClicked: textInputObj.visible = false }
        
        TextArea {
            id: textInputObj
            anchors.centerIn: parent
            width: parent.width - 40
            placeholderText: qsTr("Type something...")
            color: "white"
            font.pixelSize: 32
            font.weight: Theme.weightBold
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            background: null
            visible: false
            onVisibleChanged: if(visible) forceActiveFocus()
        }
        
        // Color Palette
        RowLayout {
            anchors.bottom: parent.bottom; anchors.bottomMargin: 300 // above keyboard usually
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12
            Repeater {
                model: ["white", "black", "#FF0055", "#00FFaa", "#00AAFF", "#FFFF00"]
                Rectangle {
                    width: 30; height: 30; radius: 15
                    color: modelData
                    border.color: "white"; border.width: 2
                    MouseArea { anchors.fill: parent; onClicked: textInputObj.color = modelData }
                }
            }
        }
    }
    
    // Components
    StickerDrawer {
        id: stickerDrawer
        onStickerSelected: (source) => {
            var newStickers = root.stickers
            newStickers.push({
                x: parent.width / 2 - 50,
                y: parent.height / 2 - 50,
                text: source, // Emoji is text
                scale: 1.0,
                rotation: 0
            })
            root.stickers = newStickers // Trigger update
        }
    }

    FileDialog {
        id: fileDialog
        nameFilters: ["Images (*.png *.jpg *.jpeg)"]
        onAccepted: {
            var path = selectedFile.toString();
            if (Qt.platform.os === "windows") path = path.replace(/^(file:\/{3})|(file:)/, "");
            else path = path.replace(/^file:\/\//, "");
            root.selectedImagePath = "file:///" + path
        }
    }
}
