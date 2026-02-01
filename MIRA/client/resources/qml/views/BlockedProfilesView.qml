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
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space8
                Item {
                    width: 48; height: 48
                    MiraIcon { anchors.centerIn: parent; name: "back"; size: 22; color: Theme.textPrimary; active: true }
                    MouseArea { anchors.fill: parent; onClicked: mainStack.pop() }
                }
                Text { text: Loc.getString("blockedProfiles"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 18; font.family: Theme.fontFamily }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }
        
        ListView {
            id: blockedList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: 3 // Mock blocked users
            
            header: Item {
                width: parent.width; height: 72
                Text {
                    anchors.margins: Theme.space20; anchors.fill: parent
                    text: Loc.getString("blockedDesc")
                    color: Theme.textSecondary; font.pixelSize: 13; wrapMode: Text.WordWrap; font.family: Theme.fontFamily; lineHeight: 1.3
                }
            }
            
            delegate: Rectangle {
                width: blockedList.width
                height: 72
                color: "transparent"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20
                    spacing: Theme.space12
                    
                    Rectangle {
                        width: 44; height: 44; radius: 22
                        color: Theme.surface
                        clip: true
                        Image {
                            anchors.fill: parent; anchors.margins: 2
                            source: "https://api.dicebear.com/7.x/avataaars/svg?seed=blocked" + index
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: "user_blocked_" + (index + 1); color: Theme.textPrimary; font.weight: Theme.weightBold; font.family: Theme.fontFamily; font.pixelSize: 15 }
                        Text { text: qsTr("Blocked on MIRA"); color: Theme.textSecondary; font.pixelSize: 13; font.family: Theme.fontFamily }
                    }
                    
                    Rectangle {
                        width: 88; height: 32; radius: 8
                        color: "transparent"; border.color: Theme.divider; border.width: 1
                        Text { anchors.centerIn: parent; text: Loc.getString("unblock"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 13; font.family: Theme.fontFamily }
                        
                        MouseArea {
                            anchors.fill: parent
                            onPressed: parent.opacity = 0.5
                            onReleased: parent.opacity = 1.0
                            onCanceled: parent.opacity = 1.0
                        }
                    }
                }
                
                Rectangle {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.leftMargin: 76; anchors.right: parent.right; anchors.rightMargin: Theme.space20
                    height: 1; color: Theme.divider
                }
            }
        }
    }
}
