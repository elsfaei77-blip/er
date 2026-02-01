import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import Qt5Compat.GraphicalEffects
import "../components"

Rectangle {
    id: root
    color: "transparent" // Nebula background visible through this
    
    signal messagesClicked()
    property bool isLoading: true
    property alias feedList: feedList
    property alias refreshTimer: refreshTimer
    
    property int activeReplyIndex: -1
    property int lastScrollTick: 0
    property string currentFeedType: "for_you" // "for_you" or "following"
    
    ReplyDialog {
        id: replyDialog
        onTextAccepted: (text) => {
            threadsModel.addComment(activeReplyIndex, text, authService.currentUser.id || 0)
        }
    }
    
    ThreadModel {
        id: threadsModel
        onReplyRequested: (index, author) => {
            root.activeReplyIndex = index
            replyDialog.placeholder = qsTr("Reply to %1...").arg(author)
            replyDialog.open()
        }
    }
    
    Timer {
        interval: 1800; running: true; repeat: false
        onTriggered: root.isLoading = false
    }

    Component.onCompleted: {
        threadsModel.refresh()
        threadsModel.refreshStories()
    }

    Item {
        anchors.fill: parent
        
        // 1. Content Area (ListView)
        ListView {
            id: feedList
            anchors.fill: parent
            topMargin: Theme.headerHeight 
            bottomMargin: 20
            clip: true
            model: root.isLoading ? 0 : threadsModel
            snapMode: ListView.SnapToItem
            boundsBehavior: Flickable.DragAndOvershootBounds
            cacheBuffer: 1000
            opacity: root.isLoading ? 0 : 1
            
            Behavior on opacity { NumberAnimation { duration: 400 } }

            // --- Overshoot Bloom Logic Removed ---
            property real overshootOpacity: 0
            
            // Bloom Rectangle Removed

            header: Column {
                width: parent.width
                Loader { sourceComponent: storiesBarHelper; width: parent.width; height: 110 }
                Item { width: 1; height: Theme.space12 }
            }

            delegate: PostCard {
                width: feedList.width
                username: model.author; content: model.content; timestamp: model.time
                avatarColor: model.avatarColor; isVerified: model.isVerified || false
                likes: model.likesCount || 0; replies: model.replyCount || 0; isLiked: model.isLiked || false
                imageUrl: model.imageUrl || ""
                videoUrl: model.videoUrl || ""
                reactionType: model.reactionType || ""
                reactionSummary: model.reactionSummary || ""
                postIndex: index
                entryIndex: index
                userId: model.userId
                showThreadLine: index < feedList.count - 1
                viewModel: threadsModel
                
                onClicked: {
                    mainStack.push(postDetailView, { 
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
                        viewModel: threadsModel
                    })
                }
            }

            onContentYChanged: {
                if (contentY < -120 && dragging && !refreshTimer.running) {
                    refreshTimer.start()
                }
                var currentTick = Math.floor(contentY / 180)
                if (currentTick !== root.lastScrollTick) {
                    if (typeof HapticManager !== "undefined") HapticManager.triggerImpactLight()
                    root.lastScrollTick = currentTick
                }
            }
            
            onAtYBeginningChanged: if (atYBeginning && flicking) if (typeof HapticManager !== "undefined") HapticManager.triggerImpactMedium()
            onAtYEndChanged: if (atYEnd && flicking) if (typeof HapticManager !== "undefined") HapticManager.triggerImpactMedium()
            
            footer: Item { width: parent.width; height: Theme.navHeight }
        }

        // 2. PREMIUM HEADER
        Item {
            id: headerWrapper
            width: parent.width; height: Theme.headerHeight
            z: 100
            
            Rectangle {
                anchors.fill: parent
                anchors.margins: 8
                radius: Theme.radiusLarge
                color: Theme.surface // Glassy transparency
                border.color: Theme.divider
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.space24; anchors.rightMargin: Theme.space24
                    spacing: Theme.space8
                    
                    MiraIcon {
                        name: "direct"; size: 22; active: true; color: Theme.gray
                        MouseArea { anchors.fill: parent; onClicked: root.messagesClicked() }
                    }
                    
                    Item {
                        Layout.fillWidth: true; height: 40
                        RowLayout {
                            anchors.centerIn: parent; spacing: 20
                            Text { 
                                text: qsTr("Following"); font.pixelSize: 17; font.family: Theme.fontFamily
                                color: root.currentFeedType === "following" ? Theme.textPrimary : Theme.textSecondary
                                font.weight: root.currentFeedType === "following" ? Font.Bold : Font.Normal
                                MouseArea { anchors.fill: parent; onClicked: { root.currentFeedType = "following"; threadsModel.refresh(0, "following") } }
                            }
                            Text { 
                                text: qsTr("For You"); font.pixelSize: 17; font.family: Theme.fontFamily
                                color: root.currentFeedType === "for_you" ? Theme.textPrimary : Theme.textSecondary
                                font.weight: root.currentFeedType === "for_you" ? Font.Bold : Font.Normal
                                MouseArea { anchors.fill: parent; onClicked: { root.currentFeedType = "for_you"; threadsModel.refresh(0, "for_you") } }
                            }
                        }
                    }
                    
                    MiraIcon {
                        name: "ai"; size: 24; active: true; color: Theme.aiAccent
                        MouseArea { anchors.fill: parent; onClicked: mainStack.push(miraAIView) }
                    }
                }
            }
        }

        // 3. Skeleton Loading State
        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: Theme.headerHeight
            visible: root.isLoading
            spacing: 0
            Repeater {
                model: 6
                SkeletonCard { Layout.fillWidth: true }
            }
        }
    }
    
    Timer {
        id: refreshTimer
        interval: 2000; repeat: false
        onTriggered: {
            threadsModel.refresh(0, root.currentFeedType)
            threadsModel.refreshStories()
        }
    }

    // Stories Bar Component
    Component {
        id: storiesBarHelper
        Item {
            width: parent.width
            height: 100
            
            ListView {
                anchors.fill: parent
                anchors.leftMargin: 10
                orientation: ListView.Horizontal
                spacing: 12
                clip: false
                
                model: threadsModel.stories // Real data (List of user objects)
                // We need to prepend 'Add Story' manually or handle it?
                // Simplest: The model from C++ is just friend stories. 
                // We can put "Add Story" outside the repeater or using a visual item at the start.
                // But ListView expects one model.
                // We can use a DelegatedModel or just put "Add Story" in a header of the horizontal list?
                // ListView Horizontal doesn't support 'header' well for horizontal layout flow unless we use layoutDirection?
                // Actually header is supported but it's attached to the start.
                header: Row {
                    spacing: 12
                    // Your Story
                    Item {
                        width: 72; height: 90
                        Item {
                            width: 72; height: 72
                            anchors.horizontalCenter: parent.horizontalCenter
                            MiraAvatar {
                                anchors.centerIn: parent
                                userId: (authService.currentUser && authService.currentUser.id) ? authService.currentUser.id : 0
                                username: (authService.currentUser && authService.currentUser.username) ? authService.currentUser.username : ""
                                avatarSource: (authService.currentUser && authService.currentUser.avatar) ? authService.currentUser.avatar : ""
                                size: 68
                                clickable: true
                                
                                Rectangle {
                                    width: 22; height: 22; radius: 11; color: Theme.accent; border.color: Theme.background; border.width: 2
                                    anchors.right: parent.right; anchors.bottom: parent.bottom; anchors.rightMargin: -2; anchors.bottomMargin: -2
                                    Text { anchors.centerIn: parent; text: "+"; color: Theme.background; font.pixelSize: 14; font.weight: Font.Bold }
                                }
                            }
                            MouseArea { anchors.fill: parent; onClicked: storyCreationPopup.open() }
                        }
                        Text {
                            anchors.top: parent.children[0].bottom; anchors.topMargin: 4; anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Your Story"); color: Theme.textSecondary; font.pixelSize: 11; font.family: Theme.fontFamily
                        }
                    }

                    // --- NEW: Challenges Story ---
                    Item {
                        width: 72; height: 90
                        Item {
                            width: 72; height: 72
                            anchors.horizontalCenter: parent.horizontalCenter
                            
                            Rectangle {
                                id: challengeRing
                                anchors.fill: parent; radius: 36
                                color: Theme.surface
                                border.color: Theme.divider; border.width: 1
                                
                                Text { anchors.centerIn: parent; text: "⚡"; font.pixelSize: 28 }
                                
                                // Premium Animated Ring
                                Rectangle {
                                    anchors.fill: parent; radius: 36; border.color: Theme.accent; border.width: 1.5; color: "transparent"
                                    opacity: 0.4
                                    
                                    SequentialAnimation on opacity {
                                        loops: Animation.Infinite
                                        NumberAnimation { from: 0.2; to: 0.8; duration: 1500; easing.type: Easing.InOutSine }
                                        NumberAnimation { from: 0.8; to: 0.2; duration: 1500; easing.type: Easing.InOutSine }
                                    }
                                }
                            }
                            
                            MouseArea { 
                                id: challengeMouse
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: mainStack.push(hashtagChallengesView) 
                                onPressed: {
                                    if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                                }
                            }
                            
                            scale: challengeMouse.pressed ? 0.92 : 1.0
                            Behavior on scale { NumberAnimation { duration: 250; easing.type: Theme.springEasing } }
                        }
                        Text {
                            anchors.top: parent.children[0].bottom; anchors.topMargin: 4; anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Explore"); color: Theme.textSecondary; font.pixelSize: 11; font.weight: Font.Bold; font.family: Theme.fontFamily
                        }
                    }
                }

                delegate: Item {
                    width: (userStory.isFollowing || userStory.userId == authService.currentUser.id) ? 72 : 0
                    height: 90
                    visible: userStory.isFollowing || userStory.userId == authService.currentUser.id
                    clip: true
                    
                    // modelData is { username, avatar, stories: [...] }
                    property var userStory: modelData
                    
                    Item {
                        width: 72; height: 72
                        anchors.horizontalCenter: parent.horizontalCenter
                        
                        Rectangle {
                            id: storyAvatarRing
                            anchors.fill: parent
                            radius: 36
                            border.color: Theme.storyRing
                            border.width: 2
                            color: Theme.surface
                            
                            CircleImage {
                                anchors.fill: parent; anchors.margins: 4
                                source: userStory.avatar || ""
                                fillMode: Image.PreserveAspectCrop
                            }
                        }
                        
                        MouseArea {
                            id: storyMouse
                            anchors.fill: parent
                            onClicked: {
                                storyViewPopup.openWithStories(userStory.stories, userStory.username, userStory.avatar, userStory.userId)
                            }
                            onPressed: {
                                if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                            }
                        }

                        scale: storyMouse.pressed ? 0.92 : 1.0
                        Behavior on scale { NumberAnimation { duration: 250; easing.type: Theme.springEasing } }
                    }
                    
                    Text {
                        anchors.top: parent.children[0].bottom; anchors.topMargin: 4
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: userStory.username
                        color: Theme.textSecondary
                        font.pixelSize: 11
                    }
                }
                    
                    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider; opacity: 0.3 }
                } // End ListView
            } // End Item
        } // End Component

    Popup {
        id: storyCreationPopup
        width: parent.width
        height: parent.height
        x: 0; y: 0
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        contentItem: StoryCreationView {
            onClosed: storyCreationPopup.close()
            onStoryPosted: {
                storyCreationPopup.close()
            }
        }
    }
    
    Popup {
        id: storyViewPopup
        width: parent.width
        height: parent.height
        x: 0; y: 0
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        
        property var currentStoryData: []
        function openWithStories(stories, username, avatar, userId) {
            storyViewItem.stories = stories
            storyViewItem.username = username
            storyViewItem.userAvatar = avatar
            storyViewItem.userId = userId
            storyViewItem.start()
            open()
        }
        
        contentItem: StoryView {
            id: storyViewItem
            onClosed: storyViewPopup.close()
            onNextUser: storyViewPopup.close()
            onDeleteRequested: (sid) => {
                threadsModel.deleteStory(sid)
                storyViewPopup.close()
            }
            onProfileClicked: (uid) => {
                storyViewPopup.close()
                console.log("From Story to Profile: " + uid)
                mainStack.push(userProfileView, {
                    userData: {
                        "id": uid,
                        "username": storyViewItem.username,
                        "avatarColor": storyViewItem.userAvatar
                    }
                })
            }
        }
    }
}
