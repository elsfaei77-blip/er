import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../components"
import "../"

StackView {
    id: profileStack
    initialItem: profileMain
    
    // Public API
    property string userName: "username"
    property string bio: ""
    property int userId: 0 // 0 = self
    
    Component {
        id: profileMain
        
        Item {
            id: root
            property int userId: profileStack.userId
            property string username: profileStack.userName
            property string bio: profileStack.bio
            property string avatar: ""
            property int followers: 0
            
            Component.onCompleted: NetworkManager.fetchProfile(userId)
            
            Connections {
                target: NetworkManager
                function onProfileReceived(data) {
                    root.username = data.username
                    profileStack.userName = data.username // Sync back up
                    
                    root.bio = data.bio
                    profileStack.bio = data.bio
                    
                    root.avatar = data.avatar || ""
                    root.followers = data.followers
                }
            }
            
            ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: Constants.background
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: Constants.standardMargin
                
                Icon { pathData: Icons.lock; width: 18; height: 18; color: Constants.textPrimary; visible: false } // Placeholder for private account
                
                Item { Layout.fillWidth: true }
                
                IconButton {
                    iconPath: Icons.menu
                    iconColor: Constants.textPrimary
                    onClicked: internalStack.push("SettingsView.qml")
                }
            }
        }

        ScrollView {
                anchors.fill: parent
                contentWidth: parent.width
                
                ColumnLayout {
                    width: parent.width
                    spacing: 0
                    
                    // Header Space
                    Item { height: 10; width: 1 }

                    // Top Icons Row
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.margins: Constants.standardMargin
                        
                        Text { text: "🌐"; font.pixelSize: 22; color: Constants.textPrimary }
                        Item { Layout.fillWidth: true }
                        Text { text: "📷"; font.pixelSize: 22; color: Constants.textPrimary } // Instagram link
                        Item { width: 15 }
                        IconButton { 
                            iconPath: Icons.create // Placeholder for Menu
                            iconColor: Constants.textPrimary
                        }
                    }
                    
                    // Profile Info (Left Aligned Threads Style)
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.margins: Constants.standardMargin
                        Layout.topMargin: 10
                        // alignment: Qt.AlignTop // Removed invalid property
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5
                            
                            Text {
                                text: root.username
                                font.pixelSize: Constants.fontHeader
                                font.bold: true
                                color: Constants.textPrimary
                            }
                            
                            Text {
                                text: root.username // Handle
                                font.pixelSize: Constants.fontBody
                                color: Constants.textPrimary
                            }
                            
                            Text {
                                text: root.bio
                                color: Constants.textPrimary
                                font.pixelSize: Constants.fontBody
                                wrapMode: Text.Wrap
                                Layout.fillWidth: true
                                Layout.topMargin: 5
                            }
                            
                            Text {
                                text: root.followers + " followers"
                                color: Constants.textSecondary
                                font.pixelSize: Constants.fontSmall
                                Layout.topMargin: 10
                            }
                        }
                        
                        RoundImage {
                            size: 70
                            source: root.avatar
                            Layout.alignment: Qt.AlignTop
                        }
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
                            height: 34
                            onClicked: profileStack.push("EditProfileView.qml", {
                                currentBio: root.bio,
                                currentAvatar: root.avatar
                            })
                        }
                        StyledButton {
                            Layout.fillWidth: true
                            textContent: "Share Profile"
                            isPrimary: false
                            height: 34
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
                    
                    // Content placeolder (should be user's posts)
                    Repeater {
                        model: 1
                        PostItem {
                            width: parent.width
                            username: root.username
                            timeAgo: "Now"
                            contentText: "Start your first thread..."
                            likeCount: 0
                        }
                    }
                }
            }
        }
    }
}
}
