import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: Theme.background

    // --- AMBIENT NEURAL GLOW & PARTICLES (PHASE 7) ---
    Item {
        id: bgGlowContainer
        anchors.fill: parent
        z: -1
        opacity: aiService.isProcessing ? 0.4 : 0.2
        
        Behavior on opacity { NumberAnimation { duration: 1500 } }

        Rectangle {
            id: aura
            anchors.centerIn: parent
            width: parent.width * 1.5; height: width
            radius: width/2
            gradient: RadialGradient {
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Theme.aiAccent }
                    GradientStop { position: 0.7; color: "transparent" }
                }
            }
            
            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 1.2; duration: aiService.isProcessing ? 3000 : 8000; easing.type: Easing.InOutSine }
                NumberAnimation { from: 1.2; to: 1.0; duration: aiService.isProcessing ? 3000 : 8000; easing.type: Easing.InOutSine }
            }
        }

        // Neural Particles: Drifting aesthetic dots
        Repeater {
            model: 12
            Rectangle {
                width: Math.floor(Math.random() * 4) + 2; height: width; radius: width/2
                color: Theme.aiAccent; opacity: 0.15
                
                property real startX: Math.random() * 400
                property real startY: Math.random() * 700
                x: startX; y: startY
                
                SequentialAnimation on x {
                    loops: Animation.Infinite
                    NumberAnimation { from: x; to: x + (Math.random() * 100 - 50); duration: 10000 + Math.random() * 5000; easing.type: Easing.InOutSine }
                    NumberAnimation { to: x; duration: 10000 + Math.random() * 5000; easing.type: Easing.InOutSine }
                }
                SequentialAnimation on y {
                    loops: Animation.Infinite
                    NumberAnimation { from: y; to: y + (Math.random() * 100 - 50); duration: 10000 + Math.random() * 5000; easing.type: Easing.InOutSine }
                    NumberAnimation { to: y; duration: 10000 + Math.random() * 5000; easing.type: Easing.InOutSine }
                }
                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    NumberAnimation { from: 0.05; to: 0.2; duration: 3000 + Math.random() * 2000 }
                    NumberAnimation { from: 0.2; to: 0.05; duration: 3000 + Math.random() * 2000 }
                }
            }
        }
    }

    AIService {
        id: aiService
        onResponseReceived: (response) => {
            chatModel.append({ "text": response, "isAi": true })
        }
    }

    ListModel {
        id: chatModel
        Component.onCompleted: {
            append({ "text": qsTr("Hello! I am MIRA AI. How can I help you today?"), "isAi": true })
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space20
                anchors.rightMargin: Theme.space20
                
                MiraIcon {
                    name: "back"
                    size: 24
                    active: true
                    color: Theme.textPrimary
                    MouseArea { anchors.fill: parent; onClicked: mainStack.pop() }
                }
                
                Text {
                    Layout.fillWidth: true
                    text: qsTr("MIRA AI")
                    color: Theme.textPrimary
                    font.pixelSize: 18; font.weight: Theme.weightBold; font.family: Theme.fontFamily
                    horizontalAlignment: Text.AlignHCenter
                }
                
                Item { width: 24 } // Spacer
            }
        }

        // Chat Area
        ListView {
            id: chatList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: chatModel
            clip: true
            spacing: 12
            topMargin: 20
            bottomMargin: 20
            
            delegate: Item {
                width: chatList.width
                height: contentRow.implicitHeight
                
                RowLayout {
                    id: contentRow
                    anchors.left: model.isAi ? parent.left : undefined
                    anchors.right: model.isAi ? undefined : parent.right
                    anchors.leftMargin: 20; anchors.rightMargin: 20
                    spacing: 8
                    
                    Rectangle {
                        visible: model.isAi
                        width: 28; height: 28; radius: 14
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: Theme.aiGradientStart }
                            GradientStop { position: 1.0; color: Theme.aiGradientEnd }
                        }
                        Text { anchors.centerIn: parent; text: "M"; color: Theme.background; font.pixelSize: 12; font.weight: Font.Bold }
                    }
                    
                    Rectangle {
                        Layout.maximumWidth: chatList.width * 0.7
                        implicitWidth: bubbleText.implicitWidth + 32
                        implicitHeight: bubbleText.implicitHeight + 20
                        radius: 18
                        color: model.isAi ? Theme.surface : Theme.accent
                        border.color: model.isAi ? Theme.divider : "transparent"
                        border.width: 1
                        
                        // Phase 4: Message Entry Animation
                        opacity: 0
                        transform: Translate { y: 10 }
                        Component.onCompleted: {
                            entryAnim.start()
                        }
                        
                        ParallelAnimation {
                            id: entryAnim
                            NumberAnimation { target: parent; property: "opacity"; to: 1; duration: Theme.animNormal; easing.type: Theme.luxuryEasing }
                            NumberAnimation { target: parent.transform[0]; property: "y"; to: 0; duration: Theme.animNormal; easing.type: Theme.luxuryEasing }
                        }
                        
                        Text {
                            id: bubbleText
                            anchors.centerIn: parent
                            width: parent.width - 32
                            text: model.text
                            color: model.isAi ? Theme.textPrimary : Theme.background
                            font.family: Theme.fontFamily; font.pixelSize: 15
                            wrapMode: Text.WordWrap
                        }
                    }
                }
                
                Component.onCompleted: chatList.positionViewAtEnd()
            }
            
            footer: Item {
                width: chatList.width
                height: 40
                visible: aiService.isProcessing
                RowLayout {
                    anchors.left: parent.left; anchors.leftMargin: 20
                    spacing: 8
                    
                    Rectangle {
                        width: 28; height: 28; radius: 14; color: Theme.surface
                        border.color: Theme.divider; border.width: 1
                        Text { anchors.centerIn: parent; text: "M"; color: Theme.textTertiary; font.pixelSize: 10 }
                    }
                    
                    RowLayout {
                        spacing: 4
                        Repeater {
                            model: 3
                            Rectangle {
                                width: 8; height: 8; radius: 4; color: Theme.accent
                                opacity: 0.3
                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    PauseAnimation { duration: index * 200 }
                                    NumberAnimation { to: 0.8; duration: 600; easing.type: Easing.InOutSine }
                                    NumberAnimation { to: 0.3; duration: 600; easing.type: Easing.InOutSine }
                                }
                                SequentialAnimation on scale {
                                    loops: Animation.Infinite
                                    PauseAnimation { duration: index * 200 }
                                    NumberAnimation { from: 1.0; to: 1.2; duration: 600; easing.type: Easing.InOutSine }
                                    NumberAnimation { from: 1.2; to: 1.0; duration: 600; easing.type: Easing.InOutSine }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Input Area
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Theme.background
            
            Rectangle {
                anchors.top: parent.top; width: parent.width; height: 1; color: Theme.divider
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 44
                    radius: 22
                    color: Theme.surface
                    border.color: Theme.divider
                    
                    TextField {
                        id: messageInput
                        anchors.fill: parent
                        anchors.leftMargin: 20; anchors.rightMargin: 20
                        placeholderText: qsTr("Ask MIRA anything...")
                        placeholderTextColor: Theme.textSecondary
                        color: Theme.textPrimary
                        font.family: Theme.fontFamily; font.pixelSize: 15
                        background: null
                        onAccepted: {
                            if (text.length > 0) {
                                chatModel.append({ "text": text, "isAi": false })
                                aiService.askMira(text)
                                text = ""
                            }
                        }
                    }
                }
                
                Rectangle {
                    width: 44; height: 44; radius: 22
                    color: messageInput.text.length > 0 ? Theme.aiAccent : Theme.surface
                    
                    MiraIcon {
                        anchors.centerIn: parent
                        name: "create_plus" // Should have a 'send' icon really
                        size: 20
                        color: Theme.background
                        active: true
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (messageInput.text.length > 0) {
                                chatModel.append({ "text": messageInput.text, "isAi": false })
                                aiService.askMira(messageInput.text)
                                messageInput.text = ""
                            }
                        }
                    }
                }
            }
        }
    }
}
