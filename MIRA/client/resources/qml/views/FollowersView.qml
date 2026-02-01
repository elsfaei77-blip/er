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
                Text { text: profileViewModel.username; color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 18; font.family: Theme.fontFamily }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }
        
        // Tab Bar (Premium Underline Style)
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: 48
            spacing: 0
            property int activeTab: 0
            
            Repeater {
                model: [qsTr("Followers"), qsTr("Following")]
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    Text { 
                        anchors.centerIn: parent
                        text: modelData
                        color: parent.parent.activeTab === index ? Theme.textPrimary : Theme.textTertiary
                        font.weight: parent.parent.activeTab === index ? Theme.weightBold : Theme.weightMedium
                        font.family: Theme.fontFamily
                        font.pixelSize: 15
                    }
                    
                    Rectangle { 
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width * 0.8
                        height: 1.5
                        color: Theme.textPrimary
                        visible: parent.parent.activeTab === index
                        radius: 1
                    }
                    
                    MouseArea { anchors.fill: parent; onClicked: parent.parent.activeTab = index }
                }
            }
        }
        
        Rectangle { width: parent.width; height: 1; color: Theme.divider }
        
        // List
        ListView {
            id: followerList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: 15
            
            delegate: Rectangle {
                width: followerList.width
                height: 76
                color: "transparent"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20
                    spacing: Theme.space12
                    
                    Rectangle {
                        width: 48; height: 48; radius: 24
                        color: Theme.surface
                        clip: true
                        Image {
                            anchors.fill: parent
                            source: "https://api.dicebear.com/7.x/avataaars/svg?seed=follower" + index
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: "user_handle_" + (index + 1); color: Theme.textPrimary; font.weight: Theme.weightBold; font.family: Theme.fontFamily; font.pixelSize: 15 }
                        Text { text: qsTr("Followed by someone you know"); color: Theme.textSecondary; font.pixelSize: 13; font.family: Theme.fontFamily; opacity: 0.8 }
                    }
                    
                    Rectangle {
                        width: 96; height: 34; radius: 10
                        color: "transparent"; border.color: Theme.divider; border.width: 1
                        Text { anchors.centerIn: parent; text: qsTr("Follow"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 14; font.family: Theme.fontFamily }
                        
                        MouseArea {
                            anchors.fill: parent
                            onPressed: parent.color = Theme.hoverOverlay
                            onReleased: parent.color = "transparent"
                            onCanceled: parent.color = "transparent"
                        }
                    }
                }
                
                Rectangle {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.leftMargin: 84; anchors.right: parent.right; anchors.rightMargin: Theme.space20
                    height: 1; color: Theme.divider
                }
            }
        }
    }
}
