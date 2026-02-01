import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Dialog {
    id: root
    width: parent ? Math.min(parent.width - 40, 480) : 360
    height: 400 // Fixed height or auto
    x: parent ? (parent.width - width) / 2 : 0
    y: parent ? (parent.height - height) / 2 : 0
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape
    
    // Properties to be set by caller
    property string currentBio: ""
    property string currentAvatar: ""
    
    signal profileUpdated(string bio, string avatar)
    
    background: Rectangle {
        color: Theme.background
        radius: 16
        border.color: Theme.divider
        border.width: 1
    }
    
    header: Item {
        width: parent.width
        height: 50
        
        Text {
            anchors.centerIn: parent
            text: "Edit profile"
            color: Theme.textPrimary
            font.weight: Font.Bold
            font.pixelSize: 16
        }
        
        Text {
            anchors.left: parent.left; anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            text: "Cancel"
            color: Theme.textPrimary
            font.pixelSize: 15
            MouseArea { anchors.fill: parent; onClicked: root.close() }
        }
        
        Text {
            anchors.right: parent.right; anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            text: "Done"
            color: Theme.textPrimary
            font.weight: Font.Bold
            font.pixelSize: 15
            MouseArea { 
                anchors.fill: parent
                onClicked: {
                     root.profileUpdated(bioArea.text, root.currentAvatar)
                     root.close()
                }
            }
        }
        
        Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
    }
    
    contentItem: ColumnLayout {
        spacing: 20
        
        // Avatar Section
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            
            Rectangle {
                id: avatarContainer
                width: 80; height: 80
                radius: 40
                color: Theme.surface
                anchors.centerIn: parent
                border.color: Theme.divider
                
                CircleImage {
                    anchors.fill: parent
                    source: root.currentAvatar.includes("/") ? root.currentAvatar : ""
                }
                
                Text {
                    anchors.centerIn: parent
                    visible: !root.currentAvatar.includes("/")
                    text: "?"
                    color: Theme.textPrimary
                    font.pixelSize: 30
                }
            }
            
            Text {
                anchors.top: avatarContainer.bottom; anchors.topMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Change profile picture"
                color: Theme.blue
                font.weight: Font.DemiBold
                font.pixelSize: 14
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // In a real app, open FileDialog. 
                        // For now, we cycle through some presets or just allow text input for URL?
                        // Let's toggle a preset for demo "activation"
                        if (root.currentAvatar === "") 
                            root.currentAvatar = "https://api.dicebear.com/7.x/avataaars/svg?seed=" + Math.random()
                        else 
                            root.currentAvatar = "" // Clear
                    }
                }
            }
        }
        
        // Bio Section
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
            
            Text {
                text: "Bio"
                color: Theme.textPrimary
                font.weight: Font.Bold
                font.pixelSize: 14
            }
            
            TextArea {
                id: bioArea
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                text: root.currentBio
                color: Theme.textPrimary
                font.pixelSize: 15
                wrapMode: TextArea.WordWrap
                background: Rectangle {
                     color: "transparent"
                     border.color: Theme.divider
                     border.width: 1
                     radius: 8
                }
            }
        }
        
        // Link Section (Placeholder)
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8
             Text {
                text: "Link"
                color: Theme.textPrimary
                font.weight: Font.Bold
                font.pixelSize: 14
            }
             Text {
                text: "+ Add link"
                color: Theme.textSecondary
                font.pixelSize: 15
            }
        }
        
        Item { Layout.fillHeight: true } // Spacer
    }
    
    onOpened: {
        bioArea.text = currentBio
        // avatar set by property binding
    }
}
