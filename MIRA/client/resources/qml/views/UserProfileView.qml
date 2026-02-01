import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    color: Theme.background
    
    property var userData: ({ "id": 0, "username": "...", "avatarColor": Theme.gray })
    
    ProfileViewModel {
        id: profileViewModel
    }

    ThreadModel {
        id: userFeedModel
    }
    
    Component.onCompleted: {
        if (userData.id > 0) {
            profileViewModel.loadProfile(userData.id)
            userFeedModel.refresh(userData.id) // Fetch specific user posts
        }
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
                anchors.leftMargin: Theme.space8; anchors.rightMargin: Theme.space16
                Item {
                    width: 48; height: 48
                    MiraIcon { anchors.centerIn: parent; name: "back"; size: 22; color: Theme.textPrimary; active: true }
                    MouseArea { anchors.fill: parent; onClicked: mainStack.pop() }
                }
                Item { Layout.fillWidth: true }
                RowLayout {
                    spacing: 20
                    MiraIcon { 
                        name: "help"; size: 22; active: true
                        MouseArea { anchors.fill: parent; onClicked: infoPopup.open() }
                    }
                    MiraIcon { 
                        name: "direct"; size: 22; active: true 
                        MouseArea { anchors.fill: parent; onClicked: mainStack.push(chatView, { chatPartner: { "id": root.userData.id, "username": root.userData.username, "avatarColor": root.userData.avatarColor } }) }
                    }
                    MiraIcon { 
                        name: "share"; size: 22; active: true 
                        MouseArea { anchors.fill: parent; onClicked: profileOptionsSheet.open() }
                    }
                }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }

        ListView {
            id: userFeed
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: userFeedModel
            
            header: ColumnLayout {
                width: parent.width
                spacing: 0
                
                // Profile Section
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.space24; Layout.rightMargin: Theme.space24
                    Layout.topMargin: Theme.space24; Layout.bottomMargin: Theme.space24
                    spacing: Theme.space20
                    
                    RowLayout {
                        Layout.fillWidth: true
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            RowLayout {
                                spacing: 4
                                Text { 
                                    text: profileViewModel.username
                                    color: Theme.textPrimary
                                    font.pixelSize: 26; font.weight: Theme.weightBold; font.family: Theme.fontFamily 
                                }
                                MiraIcon { visible: profileViewModel.isVerified; name: "verified"; size: 16 }
                            }
                            Text { 
                                text: "@" + profileViewModel.username
                                color: Theme.textSecondary; font.pixelSize: 15; font.family: Theme.fontFamily 
                            }
                        }
                        
                        MiraAvatar {
                            userId: profileViewModel.userId
                            username: profileViewModel.username
                            avatarSource: profileViewModel.avatarColor
                            size: 80
                            clickable: true
                        }
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        text: profileViewModel.bio
                        color: Theme.textPrimary; font.pixelSize: 15; wrapMode: Text.WordWrap; font.family: Theme.fontFamily
                        lineHeight: 1.3
                    }
                    
                    // Stats Row
                    RowLayout {
                        id: statsRow
                        spacing: Theme.space12
                        
                        opacity: 0
                        transform: Translate { id: statsTranslate; y: 10 }
                        SequentialAnimation {
                            id: entryAnim
                            PauseAnimation { duration: 300 }
                            ParallelAnimation {
                                NumberAnimation { target: statsRow; property: "opacity"; to: 1; duration: Theme.animNormal }
                                NumberAnimation { target: statsTranslate; property: "y"; to: 0; duration: Theme.animNormal; easing.type: Theme.luxuryEasing }
                            }
                        }
                        Component.onCompleted: entryAnim.start()

                        Text {
                            text: profileViewModel.followersCount + " followers"
                            color: Theme.textTertiary; font.pixelSize: 14; font.family: Theme.fontFamily; font.weight: Theme.weightMedium
                        }
                        Rectangle { width: 3; height: 3; radius: 1.5; color: Theme.textTertiary; opacity: 0.5 }
                        Text {
                            text: profileViewModel.postsCount + " posts"
                            color: Theme.textTertiary; font.pixelSize: 14; font.family: Theme.fontFamily; font.weight: Theme.weightMedium
                        }
                    }
                    
                // Interaction Buttons
                RowLayout {
                    Layout.fillWidth: true
                    spacing: Theme.space12
                    
                    MiraButton {
                        Layout.fillWidth: true
                        text: profileViewModel.isFollowing ? qsTr("Following") : qsTr("Follow")
                        type: profileViewModel.isFollowing ? "secondary" : "primary"
                        onClicked: profileViewModel.toggleFollow()
                    }
                    
                    MiraButton {
                        Layout.fillWidth: true
                        text: qsTr("Mention")
                        type: "secondary"
                    }
                }
            }
            
            // Tabs (Harmonized with ProfileView.qml)
            Item {
                id: tabBarContainer
                Layout.fillWidth: true
                Layout.topMargin: Theme.space20
                Layout.preferredHeight: 48
                
                property int activeTab: 0

                Rectangle {
                    id: tabIndicator
                    width: parent.width / 2
                    height: 1.5
                    color: Theme.textPrimary
                    anchors.bottom: parent.bottom
                    x: tabBarContainer.activeTab * (parent.width / 2)
                    z: 10
                    Behavior on x { NumberAnimation { duration: Theme.animNormal; easing.type: Theme.luxuryEasing } }
                }

                Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
                
                RowLayout {
                    anchors.fill: parent
                    spacing: 0
                    Repeater {
                        model: [qsTr("Threads"), qsTr("Replies")]
                        Item {
                            Layout.fillWidth: true; Layout.fillHeight: true
                            
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                color: index === tabBarContainer.activeTab ? Theme.textPrimary : Theme.textSecondary
                                font.weight: index === tabBarContainer.activeTab ? Font.DemiBold : Font.Normal
                                font.pixelSize: 15; font.family: Theme.fontFamily
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    tabBarContainer.activeTab = index
                                    if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                                }
                            }
                        }
                    }
                }
            }
            }
            
            delegate: PostCard {
                width: userFeed.width
                // visible: model.author === profileViewModel.username // No longer needed
                // height: visible ? implicitHeight : 0
                username: model.author
                content: model.content
                timestamp: model.time
                avatarColor: model.avatarColor
                isVerified: model.isVerified
                likes: model.likesCount || 0; replies: model.replyCount || 0; isLiked: model.isLiked || false
                reactionType: model.reactionType || ""
                reactionSummary: model.reactionSummary || ""
                postIndex: index
                userId: model.userId
                showThreadLine: index < userFeedModel.count - 1
                viewModel: userFeedModel

                onClicked: {
                    mainStack.push(PostDetailView, { 
                        threadData: { 
                            "id": model.id,
                            "author": model.author, "content": model.content, 
                            "time": model.time, "avatarColor": model.avatarColor,
                            "isVerified": model.isVerified, "likesCount": model.likesCount,
                            "replyCount": model.replyCount, "isLiked": model.isLiked,
                            "reactionType": model.reactionType,
                            "reactionSummary": model.reactionSummary,
                            "userId": model.userId
                        }, 
                        threadIndex: index,
                        viewModel: userFeedModel
                    })
                }
            }
        }
    }
    Popup {
        id: infoPopup
        anchors.centerIn: parent
        width: parent.width * 0.8; height: 260
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        background: Rectangle {
            color: Theme.surface
            radius: 16
            border.color: Theme.divider
            border.width: 1
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15
            
            Text {
                text: "Account Insights"
                color: Theme.textPrimary; font.pixelSize: 18; font.weight: Theme.weightBold; Layout.alignment: Qt.AlignHCenter
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.divider }
            
            GridLayout {
                columns: 2
                rowSpacing: 10
                columnSpacing: 20
                
                Text { text: "Device:"; color: Theme.textSecondary; font.pixelSize: 14 }
                Text { text: profileViewModel.deviceType; color: Theme.textPrimary; font.weight: Theme.weightMedium; font.pixelSize: 14 }
                
                Text { text: "Created on:"; color: Theme.textSecondary; font.pixelSize: 14 }
                Text { text: profileViewModel.createdAt; color: Theme.textPrimary; font.weight: Theme.weightMedium; font.pixelSize: 14 }
                
                Text { text: "Country:"; color: Theme.textSecondary; font.pixelSize: 14 }
                Text { text: profileViewModel.country; color: Theme.textPrimary; font.weight: Theme.weightMedium; font.pixelSize: 14 }
            }
            
            Item { Layout.fillHeight: true }
            
            MiraButton {
                Layout.fillWidth: true
                text: qsTr("Done")
                type: "primary"
                onClicked: infoPopup.close()
            }
        }
    }

    ActionSheet {
        id: profileOptionsSheet
        model: [
            { "label": profileViewModel.isBlocked ? qsTr("Unblock") : qsTr("Block"), "icon": "🚫", "isDestructive": true },
            { "label": qsTr("Share Profile"), "icon": "📤" },
            { "label": qsTr("Report"), "icon": "🚩", "isDestructive": true }
        ]
        onItemClicked: (idx, label) => {
            if (label.indexOf(qsTr("Block")) !== -1 || label.indexOf(qsTr("Unblock")) !== -1) {
                profileViewModel.blockUser()
            }
        }
    }
}
