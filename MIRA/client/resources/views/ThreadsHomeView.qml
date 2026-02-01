// ThreadsHomeView.qml - Exact Threads home feed
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"

Item {
    id: root
    
    // Mock data model - will be replaced with real data
    ListModel {
        id: postsModel
        
        ListElement {
            username: "zuck"
            avatar: ""
            verified: true
            timeAgo: "2h"
            content: "Welcome to Threads! We're building a positive and creative space for you to express your ideas."
            imageUrl: ""
            likeCount: 12453
            replyCount: 234
            isLiked: false
        }
        
        ListElement {
            username: "threads"
            avatar: ""
            verified: true
            timeAgo: "4h"
            content: "Threads is where communities come together to discuss everything from the topics you care about today to what'll be trending tomorrow."
            imageUrl: ""
            likeCount: 8932
            replyCount: 156
            isLiked: false
        }
        
        ListElement {
            username: "instagram"
            avatar: ""
            verified: true
            timeAgo: "6h"
            content: "Share your thoughts, follow the topics and people you care about, and join in the conversation. 🧵"
            imageUrl: ""
            likeCount: 15678
            replyCount: 342
            isLiked: true
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 56
            color: ThreadsConstants.surface // Glassy background
            
            // Threads logo
            Text {
                anchors.centerIn: parent
                text: "threads"
                font.family: ThreadsConstants.fontFamily
                font.pixelSize: 24
                font.weight: ThreadsConstants.weightBold
                color: ThreadsConstants.textPrimary
            }
            
            // Bottom border
            Rectangle {
                width: parent.width
                height: 1
                color: ThreadsConstants.divider
                anchors.bottom: parent.bottom
            }
        }
        
        // Posts Feed
        ListView {
            id: feedList
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: postsModel
            clip: true
            
            // Pull to refresh
            property bool refreshing: false
            
            header: Item {
                width: parent.width
                height: refreshing ? 50 : 0
                visible: refreshing
                
                BusyIndicator {
                    anchors.centerIn: parent
                    running: parent.visible
                }
            }
            
            delegate: ThreadsPostItem {
                width: feedList.width
                username: model.username
                avatar: model.avatar
                verified: model.verified
                timeAgo: model.timeAgo
                content: model.content
                imageUrl: model.imageUrl
                likeCount: model.likeCount
                replyCount: model.replyCount
                isLiked: model.isLiked
                
                onClicked: {
                    console.log("Post clicked:", model.username)
                    // TODO: Navigate to thread detail
                }
                
                onLikeClicked: {
                    // Toggle like
                    postsModel.setProperty(index, "isLiked", !model.isLiked)
                    postsModel.setProperty(index, "likeCount", 
                        model.isLiked ? model.likeCount - 1 : model.likeCount + 1)
                }
                
                onReplyClicked: {
                    console.log("Reply clicked")
                    // TODO: Navigate to thread detail with composer focused
                }
                
                onShareClicked: {
                    console.log("Share clicked")
                    // TODO: Show share sheet
                }
                
                onMoreClicked: {
                    console.log("More clicked")
                    // TODO: Show action sheet
                }
            }
            
            // Pull-to-refresh gesture
            MouseArea {
                id: refreshArea
                anchors.fill: parent
                propagateComposedEvents: true
                
                property int startY: 0
                property int dragDistance: 0
                
                onPressed: {
                    startY = mouse.y
                    mouse.accepted = feedList.atYBeginning
                }
                
                onPositionChanged: {
                    if (feedList.atYBeginning && startY > 0) {
                        dragDistance = mouse.y - startY
                        if (dragDistance > 80) {
                            feedList.refreshing = true
                            refreshTimer.start()
                        }
                    }
                }
                
                onReleased: {
                    startY = 0
                    dragDistance = 0
                }
            }
            
            Timer {
                id: refreshTimer
                interval: 1500
                onTriggered: {
                    feedList.refreshing = false
                    console.log("Feed refreshed")
                    // TODO: Fetch new posts
                }
            }
            
            // Scroll to top button (appears when scrolled down)
            Rectangle {
                visible: !feedList.atYBeginning
                width: 48
                height: 48
                radius: 24
                color: ThreadsConstants.textPrimary
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 16
                
                Text {
                    anchors.centerIn: parent
                    text: "↑"
                    font.pixelSize: 24
                    color: ThreadsConstants.background
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: feedList.positionViewAtBeginning()
                }
            }
        }
    }
}
