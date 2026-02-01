import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    color: "transparent" // Let Nebula background show through
    
    ConversationModel {
        id: conversationModel
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
                anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20
                
                Item {
                    width: 48; height: 48
                    MiraIcon { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; name: "back"; size: 22; color: Theme.textPrimary; active: true }
                    MouseArea { anchors.fill: parent; onClicked: mainStack.pop() }
                }
                
                Text { 
                    text: Loc.getString("messages")
                    color: Theme.textPrimary
                    font.pixelSize: 18
                    font.weight: Theme.weightBold
                    font.family: Theme.fontFamily 
                    Layout.alignment: Qt.AlignVCenter
                }
                Item { Layout.fillWidth: true }
                MiraIcon { 
                    name: "create_plus"; size: 22; active: true; color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mainStack.push(groupChatView)
                    }
                }
            }
            Rectangle { anchors.top: parent.bottom; width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }
        }

        // --- NEW: Featured Actions (Groups & Calls) ---
        RowLayout {
            Layout.fillWidth: true
            Layout.margins: Theme.space20
            spacing: 16
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                radius: 16
                color: Theme.surface
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "👥"; font.pixelSize: 24; Layout.alignment: Qt.AlignHCenter }
                    Text { text: qsTr("Group Chats"); color: Theme.textPrimary; font.pixelSize: 12; font.weight: Font.Bold }
                }
                MouseArea { anchors.fill: parent; onClicked: mainStack.push(groupChatView) }
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                radius: 16
                color: Theme.surface
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "📞"; font.pixelSize: 24; Layout.alignment: Qt.AlignHCenter }
                    Text { text: qsTr("Video Calls"); color: Theme.textPrimary; font.pixelSize: 12; font.weight: Font.Bold }
                }
            }
        }
        
        Rectangle { Layout.fillWidth: true; height: 1; color: Theme.divider; opacity: 0.3 }
        
        // Conversation List
        ListView {
            id: convList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: conversationModel
            
            delegate: Item {
                id: delegateRoot
                width: convList.width; height: 84
                
                // Background Delete Action
                Rectangle {
                    anchors.fill: parent
                    color: Theme.likeRed
                    RowLayout {
                        anchors.right: parent.right; anchors.rightMargin: 24; anchors.verticalCenter: parent.verticalCenter
                        Text { text: qsTr("Delete"); color: Theme.background; font.weight: Theme.weightBold; font.family: Theme.fontFamily }
                    }
                }
                
                // Foreground content
                Rectangle {
                    id: contentRect
                    width: parent.width; height: parent.height
                    color: Theme.surface // Glassy
                    
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20; spacing: Theme.space16
                        
                        MiraAvatar {
                            userId: model.partner_id
                            username: model.username
                            avatarSource: model.avatar
                            size: 56
                            clickable: true
                        }
                        
                        ColumnLayout {
                            spacing: 2; Layout.fillWidth: true
                            RowLayout {
                                Text { 
                                    text: model.username
                                    color: Theme.textPrimary
                                    font.weight: model.unread ? Theme.weightBold : Theme.weightMedium
                                    font.pixelSize: 15; font.family: Theme.fontFamily 
                                }
                                Item { Layout.fillWidth: true }
                                Text { 
                                    text: model.time
                                    color: Theme.textTertiary
                                    font.pixelSize: 12; font.family: Theme.fontFamily 
                                }
                            }
                            Text { 
                                text: model.lastMsg
                                color: model.unread ? Theme.textPrimary : Theme.textSecondary
                                font.pixelSize: 14; elide: Text.ElideRight
                                font.weight: model.unread ? Theme.weightMedium : Theme.weightRegular 
                                font.family: Theme.fontFamily
                                opacity: model.unread ? 1.0 : 0.7
                            }
                        }
                        
                        Rectangle {
                            visible: model.unread
                            width: 8; height: 8; radius: 4; color: Theme.accent
                        }
                    }
                    
                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        drag.target: contentRect
                        drag.axis: Drag.XAxis
                        drag.minimumX: -100
                        drag.maximumX: 0
                        
                        onReleased: {
                            if (contentRect.x < -60) {
                                deleteAnim.start()
                            } else {
                                resetAnim.start()
                            }
                        }
                        onClicked: mainStack.push(chatView, { chatPartner: { "id": model.partnerId, "username": model.username, "avatarColor": model.avatarColor } })
                    }
                    
                    NumberAnimation { id: resetAnim; target: contentRect; property: "x"; to: 0; duration: 250; easing.type: Easing.OutQuart }
                    NumberAnimation { id: deleteAnim; target: contentRect; property: "x"; to: -delegateRoot.width; duration: 300; easing.type: Easing.InQuart; onFinished: conversationModel.deleteConversation(index) }
                }
                
                Rectangle { 
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.leftMargin: 88; anchors.right: parent.right
                    height: 1; color: Theme.divider 
                }
            }
        }
    }
    
    // ListModel { ... } removed
    
    Component.onCompleted: {
        // Refresh conversations
        if (typeof conversationModel !== "undefined")
            conversationModel.refresh()
    }
}
