import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: Theme.background
    
    property var closeFriendsList: []
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            color: Theme.surface
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                
                MiraIcon {
                    name: "back"
                    size: 24
                    color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mainStack.pop()
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    
                    Text {
                        text: "Close Friends"
                        color: Theme.textPrimary
                        font.pixelSize: 18
                        font.weight: Font.Bold
                    }
                    
                    Text {
                        text: root.closeFriendsList.length + " friends"
                        color: Theme.textSecondary
                        font.pixelSize: 12
                    }
                }
                
                Rectangle {
                    Layout.preferredWidth: addText.implicitWidth + 24
                    Layout.preferredHeight: 36
                    radius: 18
                    color: Theme.aiAccent
                    
                    Text {
                        id: addText
                        anchors.centerIn: parent
                        text: "Add"
                        color: "white"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
        
        // Info banner
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Qt.rgba(139, 92, 246, 0.1)
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                
                Text {
                    text: "⭐"
                    font.pixelSize: 32
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    
                    Text {
                        text: "Share with Close Friends Only"
                        color: Theme.textPrimary
                        font.pixelSize: 15
                        font.weight: Font.Bold
                    }
                    
                    Text {
                        text: "Stories and posts shared with close friends will have a green ring"
                        color: Theme.textSecondary
                        font.pixelSize: 13
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }
                }
            }
        }
        
        // Friends list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 0
            
            model: ListModel {
                ListElement { username: "alice"; fullName: "Alice Johnson"; isCloseFriend: true }
                ListElement { username: "bob"; fullName: "Bob Smith"; isCloseFriend: true }
                ListElement { username: "charlie"; fullName: "Charlie Brown"; isCloseFriend: false }
                ListElement { username: "diana"; fullName: "Diana Prince"; isCloseFriend: false }
            }
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 72
                color: "transparent"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12
                    
                    // Avatar with indicator
                    Item {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        
                        Rectangle {
                            anchors.centerIn: parent
                            width: 48
                            height: 48
                            radius: 24
                            color: Theme.blue
                            
                            Text {
                                anchors.centerIn: parent
                                text: model.username.charAt(0).toUpperCase()
                                color: "white"
                                font.pixelSize: 20
                                font.weight: Font.Bold
                            }
                        }
                        
                        // Green ring for close friends
                        Rectangle {
                            anchors.fill: parent
                            radius: 24
                            color: "transparent"
                            border.color: "#00C853"
                            border.width: 3
                            visible: model.isCloseFriend
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: model.fullName
                            color: Theme.textPrimary
                            font.pixelSize: 15
                            font.weight: Font.Bold
                        }
                        
                        Text {
                            text: "@" + model.username
                            color: Theme.textSecondary
                            font.pixelSize: 13
                        }
                    }
                    
                    // Toggle button
                    Rectangle {
                        Layout.preferredWidth: model.isCloseFriend ? removeText.implicitWidth + 24 : addButtonText.implicitWidth + 24
                        Layout.preferredHeight: 36
                        radius: 18
                        color: model.isCloseFriend ? "transparent" : Theme.aiAccent
                        border.color: model.isCloseFriend ? Theme.divider : "transparent"
                        border.width: model.isCloseFriend ? 1 : 0
                        
                        Text {
                            id: removeText
                            anchors.centerIn: parent
                            text: model.isCloseFriend ? "Remove" : ""
                            color: Theme.textPrimary
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            visible: model.isCloseFriend
                        }
                        
                        Text {
                            id: addButtonText
                            anchors.centerIn: parent
                            text: model.isCloseFriend ? "" : "Add"
                            color: "white"
                            font.pixelSize: 13
                            font.weight: Font.Bold
                            visible: !model.isCloseFriend
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                model.isCloseFriend = !model.isCloseFriend
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
