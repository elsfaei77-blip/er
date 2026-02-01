import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../assets" 

Page {
    id: root
    property int partnerId: 0
    property string partnerName: "User"
    property string partnerAvatar: ""
    
    signal backClicked() // Added signal
    
    background: Rectangle { color: Constants.background }
    
    // Messages Model
    ListModel {
        id: messagesModel
    }
    
    Connections {
        target: NetworkManager
        function onMessagesReceived(messages) {
            messagesModel.clear()
            for (var i = 0; i < messages.length; i++) {
                messagesModel.append(messages[i])
            }
            // Scroll to bottom
            messagesList.positionViewAtEnd()
        }
    }
    
    Component.onCompleted: {
        if (partnerId > 0) {
            NetworkManager.fetchMessages(partnerId)
        }
    }
    
    header: Rectangle {
        height: 60
        color: Constants.background
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Constants.standardMargin
            spacing: 12
            
            IconButton {
                iconPath: Icons.arrowBack
                iconColor: Constants.textPrimary
                onClicked: root.backClicked()
            }
            
            RoundImage {
                size: 32
                source: root.partnerAvatar
            }
            
            Text {
                text: root.partnerName
                font.bold: true
                font.pixelSize: Constants.fontHeader
                color: Constants.textPrimary
                Layout.fillWidth: true
            }
            
            IconButton {
                iconPath: Icons.user // Info or Profile
                iconColor: Constants.textPrimary
            }
        }
        
        // Bottom border
        Rectangle {
            width: parent.width
            height: 1
            color: Constants.divider
            anchors.bottom: parent.bottom
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        ListView {
            id: messagesList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: messagesModel
            spacing: 8
            
            // Add some top margin
            header: Item { width: 1; height: 10 }
            
            delegate: Item {
                width: parent.width
                height: bubble.height
                
                property bool isMe: model.is_me
                
                Rectangle {
                    id: bubble
                    width: Math.min(msgText.implicitWidth + 24, parent.width * 0.7)
                    height: msgText.implicitHeight + 20
                    color: isMe ? Constants.textPrimary : Constants.surface
                    radius: 18
                    
                    anchors.right: isMe ? parent.right : undefined
                    anchors.left: isMe ? undefined : parent.left
                    anchors.margins: Constants.standardMargin
                    
                    Text {
                        id: msgText
                        anchors.centerIn: parent
                        width: parent.width - 24
                        text: model.content
                        color: isMe ? Constants.background : Constants.textPrimary
                        wrapMode: Text.Wrap
                    }
                }
            }
        }
        
        // Input Area
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: Constants.background
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                
                TextField {
                    id: chatInput
                    placeholderText: "Message..."
                    Layout.fillWidth: true
                    color: Constants.textPrimary
                    background: Rectangle {
                        color: Constants.surface
                        radius: 20
                    }
                }
                
                Text {
                    text: "Send"
                    font.bold: true
                    color: chatInput.text.length > 0 ? Constants.textPrimary : Constants.textSecondary
                    visible: chatInput.text.length > 0
                    
                    MouseArea {
                        anchors.fill: parent
                        enabled: chatInput.text.length > 0
                        onClicked: {
                            NetworkManager.sendMessage(root.partnerId, chatInput.text)
                            // Optimistic append
                            messagesModel.append({
                                "content": chatInput.text,
                                "is_me": true,
                                "timestamp": "Now"
                            })
                            chatInput.text = ""
                            messagesList.positionViewAtEnd()
                        }
                    }
                }
            }
        }
    }
}
