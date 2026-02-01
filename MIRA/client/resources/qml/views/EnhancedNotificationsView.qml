import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    color: Theme.background
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            
            Text {
                anchors.centerIn: parent
                text: qsTr("Notifications")
                color: Theme.textPrimary
                font.pixelSize: 18
                font.weight: Font.Bold
            }
            
            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: Theme.space20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 16
                
                MiraIcon {
                    name: "mira" // Use loop/refresh icon if available, or just logo for now acting as refresh
                    size: 22
                    color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: notificationModel.refresh()
                    }
                }

                MiraIcon {
                    name: "settings"
                    size: 22
                    color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
        
        // Filter tabs
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            contentWidth: filtersRow.implicitWidth
            clip: true
            
            RowLayout {
                id: filtersRow
                height: parent.height
                spacing: 12
                
                Repeater {
                    model: [qsTr("All"), qsTr("Mentions"), qsTr("Likes"), qsTr("Comments"), qsTr("Follows"), qsTr("Requests")]
                    
                    Rectangle {
                        Layout.preferredHeight: 36
                        Layout.preferredWidth: filterText.implicitWidth + 24
                        radius: 18
                        color: index === 0 ? Theme.accent : "transparent"
                        border.color: Theme.divider
                        border.width: index === 0 ? 0 : 1
                        
                        Text {
                            id: filterText
                            anchors.centerIn: parent
                            text: modelData
                            color: index === 0 ? "white" : Theme.textPrimary
                            font.pixelSize: 14
                            font.weight: Font.Medium
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }
        }
        
        // Notifications list
        ListView {
            id: notifList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 0
            
            model: NotificationModel {
                id: notificationModel
                userId: (authService.currentUser && authService.currentUser.id !== undefined) ? authService.currentUser.id : 0
                Component.onCompleted: refresh()
            }
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 80
                color: model.isRead ? "transparent" : (Theme.isDarkMode ? Qt.rgba(0.02, 0, 0.48, 0.2) : Qt.rgba(0, 0.48, 1, 0.05))
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12
                    
                    // Avatar
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 24
                        color: Theme.surfaceElevated
                        
                        // User Avatar
                        CircleImage {
                           anchors.fill: parent
                           source: model.actorAvatar && model.actorAvatar !== "" ? 
                                   (model.actorAvatar.startsWith("http") ? model.actorAvatar : NetworkManager.baseUrl + "/uploads/" + model.actorAvatar) : 
                                   "https://api.dicebear.com/7.x/avataaars/svg?seed=" + model.actorName
                        }
                        
                        // Type badge
                        Rectangle {
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            width: 20
                            height: 20
                            radius: 10
                            color: Theme.background
                            border.color: Theme.divider
                            border.width: 1
                            
                            Text {
                                anchors.centerIn: parent
                                text: model.type === "like" ? "❤️" :
                                      model.type === "reply" ? "💬" :
                                      model.type === "follow" ? "👤" : 
                                      model.type === "message" ? "📩" : "@"
                                font.pixelSize: 10
                            }
                        }
                    }
                    
                    // Content
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        RowLayout {
                            spacing: 4
                            
                            Text {
                                text: model.actorName
                                color: Theme.textPrimary
                                font.pixelSize: 14
                                font.weight: Font.Bold
                                font.family: Theme.fontFamily
                            }
                            
                            Text {
                                text: {
                                    if (model.type === "like") return qsTr("liked your post")
                                    if (model.type === "reply") return qsTr("replied to your post")
                                    if (model.type === "follow") return qsTr("started following you")
                                    if (model.type === "message") return qsTr("sent you a message")
                                    return qsTr("interacted with you")
                                }
                                color: Theme.textSecondary
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                                font.family: Theme.fontFamily
                            }
                        }
                        
                        Text {
                            text: model.time
                            color: Theme.textTertiary
                            font.pixelSize: 12
                            font.family: Theme.fontFamily
                        }
                    }
                    
                    // Action button
                    Rectangle {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 32
                        radius: 16
                        color: model.type === "follow" ? Theme.gray : "transparent"
                        border.color: Theme.divider
                        border.width: model.type === "follow" ? 0 : 1
                        visible: model.type === "follow" || model.type === "reply"
                        
                        Text {
                            anchors.centerIn: parent
                            text: model.type === "follow" ? qsTr("Follow") : qsTr("View")
                            color: model.type === "follow" ? "white" : Theme.textPrimary
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            font.family: Theme.fontFamily
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                // TODO: Handle follow back or view post
                            }
                        }
                    }
                }
                
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 76
                    anchors.right: parent.right
                    height: 1
                    color: Theme.divider
                }
            }
        }
    }
}
