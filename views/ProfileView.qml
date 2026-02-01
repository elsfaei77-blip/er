import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../components"
import "../"

Item {
    id: root
    property string userName: "username"
    property string bio: "Bio goes here."
    
    ScrollView {
        anchors.fill: parent
        contentWidth: parent.width
        
        ColumnLayout {
            width: parent.width
            spacing: 0
            
            // Header Space
            Item { height: 20; width: 1 }

            // Top Bar
            RowLayout {
                Layout.fillWidth: true
                Layout.margins: Constants.standardMargin
                
                Text { text: "🌐"; font.pixelSize: 22; color: Constants.textPrimary }
                Item { Layout.fillWidth: true }
                Text { text: "📷"; font.pixelSize: 22; color: Constants.textPrimary }
                Item { width: 15 }
                Text { text: "🍔"; font.pixelSize: 22; color: Constants.textPrimary } // Menu
            }
            
            // Profile Info
            RowLayout {
                Layout.fillWidth: true
                Layout.margins: Constants.standardMargin
                Layout.topMargin: 10
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 5
                    
                    Text {
                        text: "Antigravity AI" // Full Name
                        font.pixelSize: Constants.fontHeader
                        font.bold: true
                        color: Constants.textPrimary
                    }
                    
                    Text {
                        text: root.userName // Handle
                        font.pixelSize: Constants.fontBody
                        color: Constants.textPrimary
                    }
                }
                
                RoundImage {
                    size: 70
                    // source: "avatar.jpg"
                }
            }
            
            // Bio
            Text {
                Layout.fillWidth: true
                Layout.margins: Constants.standardMargin
                text: root.bio
                color: Constants.textPrimary
                font.pixelSize: Constants.fontBody
                wrapMode: Text.Wrap
            }
            
            // Followers
            Text {
                Layout.margins: Constants.standardMargin
                Layout.topMargin: 10
                text: "1.2M followers"
                color: Constants.textSecondary
                font.pixelSize: Constants.fontSmall
            }
            
            // Buttons
            RowLayout {
                Layout.fillWidth: true
                Layout.margins: Constants.standardMargin
                Layout.topMargin: 15
                spacing: 10
                
                StyledButton {
                    Layout.fillWidth: true
                    textContent: "Edit Profile"
                    isPrimary: false
                    // clickAction: navigate to settings
                }
                StyledButton {
                    Layout.fillWidth: true
                    textContent: "Share Profile"
                    isPrimary: false
                }
            }
            
            // Tabs
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 20
                
                Item {
                    Layout.fillWidth: true
                    height: 40
                    Text {
                        anchors.centerIn: parent
                        text: "Threads"
                        font.bold: true
                        color: Constants.textPrimary
                    }
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Constants.textPrimary
                        anchors.bottom: parent.bottom
                    }
                }
                
                Item {
                    Layout.fillWidth: true
                    height: 40
                    Text {
                        anchors.centerIn: parent
                        text: "Replies"
                        color: Constants.textSecondary
                    }
                    Rectangle {
                        width: parent.width
                        height: 1
                        color: Constants.divider
                        anchors.bottom: parent.bottom
                    }
                }
            }
            
            // Content (Dummy)
            Repeater {
                model: 3
                PostItem {
                    width: parent.width
                    username: root.userName
                    timeAgo: "1d"
                    contentText: "This is a sample post in the profile view."
                    likeCount: index * 42
                }
            }
            
            // Footer space
            Item { height: 100; width: 1 }
        }
    }
}
