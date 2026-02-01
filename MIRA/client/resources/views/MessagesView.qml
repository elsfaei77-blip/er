import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../components"
import "../assets"
import "../"

StackView {
    id: root
    initialItem: convoList

    Component {
        id: convoList
        Item {
            
            Component.onCompleted: NetworkManager.fetchConversations()
            
            Connections {
                target: NetworkManager
                function onConversationsReceived(convos) {
                    convoModel.clear()
                    for (var i = 0; i < convos.length; i++) convoModel.append(convos[i])
                }
            }
            
            ListModel { id: convoModel }

            ColumnLayout {
                anchors.fill: parent
                spacing: 0
                
                // Header
                Rectangle {
                    Layout.fillWidth: true
                    height: 60
                    color: "transparent"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "MESSAGES"
                        color: Constants.textPrimary
                        font.bold: true
                        font.letterSpacing: 2
                    }
                }
                
                // Chat List
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: convoModel
                    
                    delegate: Item {
                        width: parent.width
                        height: 80
                        
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            Rectangle {
                                anchors.fill: parent
                                color: Constants.neonBlue
                                opacity: 0.05
                                visible: mouseArea.pressed
                            }
                        }
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 15
                            spacing: 15
                            
                            RoundImage {
                                size: 50
                                source: model.avatar || "" 
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                
                                RowLayout {
                                    Text {
                                        text: model.username
                                        color: Constants.textPrimary
                                        font.bold: true
                                    }
                                    Item { Layout.fillWidth: true }
                                }
                                
                                Text {
                                    text: model.last_message || ""
                                    color: Constants.textSecondary
                                    font.pixelSize: 13
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                        }
                        
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            onClicked: {
                                root.push(chatComponent, { 
                                    partnerId: model.user_id,
                                    partnerName: model.username 
                                })
                            }
                        }
                        
                        Rectangle {
                            width: parent.width - 80
                            height: 1
                            color: Constants.divider
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                        }
                    }
                }
            }
        }
    }
    
    Component {
        id: chatComponent
        ChatView {
            onBackClicked: root.pop()
        }
    }
}
