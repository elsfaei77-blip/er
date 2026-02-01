import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: Theme.background
    
    property string groupName: "Group Chat"
    property var members: []
    
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
                spacing: 12
                
                MiraIcon {
                    name: "back"
                    size: 24
                    color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mainStack.pop()
                    }
                }
                
                // Group avatar
                Rectangle {
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    radius: 20
                    color: Theme.blue
                    
                    Text {
                        anchors.centerIn: parent
                        text: root.groupName.charAt(0).toUpperCase()
                        color: "white"
                        font.pixelSize: 18
                        font.weight: Font.Bold
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    
                    Text {
                        text: root.groupName
                        color: Theme.textPrimary
                        font.pixelSize: 16
                        font.weight: Font.Bold
                    }
                    
                    Text {
                        text: root.members.length + " members"
                        color: Theme.textSecondary
                        font.pixelSize: 12
                    }
                }
                
                MiraIcon {
                    name: "phone"
                    size: 22
                    color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                
                MiraIcon {
                    name: "video"
                    size: 22
                    color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
        
        // Messages area
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            verticalLayoutDirection: ListView.BottomToTop
            spacing: 12
            
            model: ListModel {
                ListElement { sender: "Alice"; message: "Hey everyone!"; isOwn: false }
                ListElement { sender: "You"; message: "Hi Alice!"; isOwn: true }
                ListElement { sender: "Bob"; message: "What's up?"; isOwn: false }
            }
            
            delegate: RowLayout {
                width: ListView.view.width
                spacing: 8
                layoutDirection: model.isOwn ? Qt.RightToLeft : Qt.LeftToRight
                
                Item { Layout.fillWidth: true }
                
                ColumnLayout {
                    Layout.maximumWidth: parent.width * 0.7
                    spacing: 4
                    
                    Text {
                        text: model.sender
                        color: Theme.textSecondary
                        font.pixelSize: 11
                        visible: !model.isOwn
                    }
                    
                    Rectangle {
                        Layout.preferredWidth: messageText.implicitWidth + 24
                        Layout.preferredHeight: messageText.implicitHeight + 16
                        radius: 18
                        color: model.isOwn ? Theme.blue : Theme.surfaceElevated
                        
                        Text {
                            id: messageText
                            anchors.centerIn: parent
                            text: model.message
                            color: model.isOwn ? "white" : Theme.textPrimary
                            font.pixelSize: 14
                            wrapMode: Text.WordWrap
                        }
                    }
                }
            }
        }
        
        // Input area
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Theme.surface
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12
                
                MiraIcon {
                    name: "image"
                    size: 24
                    color: Theme.textSecondary
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    radius: 20
                    color: Theme.background
                    
                    TextField {
                        anchors.fill: parent
                        anchors.margins: 12
                        placeholderText: "Message..."
                        background: Item {}
                        font.pixelSize: 14
                    }
                }
                
                MiraIcon {
                    name: "mic"
                    size: 24
                    color: Theme.blue
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
                
                MiraIcon {
                    name: "send"
                    size: 24
                    color: Theme.blue
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}
