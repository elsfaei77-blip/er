import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../assets"
import "../components"

Item {
    id: root
    
    // Model for notifications
    ListModel {
        id: activityModel
    }
    
    Connections {
        target: NetworkManager
        function onNotificationsReceived(notifications) {
            activityModel.clear()
            for (var i = 0; i < notifications.length; i++) {
                activityModel.append(notifications[i])
            }
        }
    }
    
    Component.onCompleted: NetworkManager.fetchNotifications()
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            
            Text {
                text: "Activity"
                font.pixelSize: Constants.fontDisplay
                font.bold: true
                color: Constants.textPrimary
                anchors.left: parent.left
                anchors.leftMargin: Constants.standardMargin
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Filter Tabs (All, Replies, Mentions) - Visual only for now
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: Constants.standardMargin
            Layout.bottomMargin: 10
            spacing: 12
            
            Repeater {
                model: ["All", "Replies", "Mentions", "Verified"]
                Rectangle {
                    width: txt.implicitWidth + 24
                    height: 32
                    radius: 8
                    color: index === 0 ? Constants.textPrimary : Constants.background
                    border.color: Constants.divider
                    border.width: index === 0 ? 0 : 1
                    
                    Text {
                        id: txt
                        anchors.centerIn: parent
                        text: modelData
                        font.bold: true
                        color: index === 0 ? Constants.background : Constants.textPrimary
                    }
                }
            }
        }
        
        // List
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: activityModel
            clip: true
            
            delegate: Item {
                width: parent.width
                height: 70
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Constants.standardMargin
                    spacing: 12
                    
                    // Actor Avatar
                    RoundImage {
                        size: 40
                        source: model.actor_avatar || ""
                        Layout.alignment: Qt.AlignTop
                        
                        // Type Badge
                        Rectangle {
                            width: 16; height: 16
                            radius: 8
                            color: {
                                if (model.type === "like") return Constants.neonPink
                                if (model.type === "follow") return "#5C5CFF" // Purple
                                return Constants.neonGreen
                            }
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            border.width: 2
                            border.color: Constants.background
                            
                            // Icon inside badge (Simple shapes)
                            Rectangle {
                                anchors.centerIn: parent
                                width: 8; height: 8
                                color: "white"
                                radius: model.type === "like" ? 0 : 4 // Heart/Circle distinction
                            }
                        }
                    }
                    
                    // Content
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: "<b>" + model.actor_name + "</b>" + " " + getTimeText()
                            color: Constants.textSecondary
                            font.pixelSize: Constants.fontSmall
                            Layout.fillWidth: true
                            textFormat: Text.RichText
                            
                            function getTimeText() {
                                // Basic parsing, real app needs moment.js/equivalent
                                return "2m" 
                            }
                        }
                        
                        Text {
                            text: getContentText()
                            color: Constants.textPrimary
                            font.pixelSize: Constants.fontBody
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        
                        function getContentText() {
                            if (model.type === "like") return "Liked your post"
                            if (model.type === "follow") return "Followed you"
                            if (model.type === "comment") return "Replied: Nice post!"
                            return "Interacted with you"
                        }
                    }
                    
                    // Action Button (Follow Back) or Post Preview
                    Item {
                        visible: model.type === "follow"
                        width: 80
                        height: 32
                        
                        Rectangle {
                            anchors.fill: parent
                            color: "transparent"
                            border.color: Constants.divider
                            border.width: 1
                            radius: 8
                        }
                        Text {
                            anchors.centerIn: parent
                            text: "Follow"
                            font.bold: true
                            color: Constants.textPrimary
                        }
                    }
                }
            }
        }
    }
}
