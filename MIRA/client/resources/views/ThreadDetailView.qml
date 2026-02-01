import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../assets" // Asusming Constants is here

Page {
    id: root
    property var postData: ({}) // Passed from previous view
    
    background: Rectangle { color: Constants.background }
    
    // Comments Model
    ListModel {
        id: commentsModel
    }
    
    Connections {
        target: NetworkManager
        function onCommentsReceived(comments) {
            commentsModel.clear()
            for (var i = 0; i < comments.length; i++) {
                commentsModel.append(comments[i])
            }
        }
    }
    
    Component.onCompleted: {
        if (postData && postData.id) {
            NetworkManager.fetchComments(postData.id)
        }
    }
    
    header: Rectangle {
        height: 50
        color: Constants.background
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Constants.standardMargin
            
            IconButton {
                iconPath: Icons.arrowBack // Assuming this exists or generic arrow
                iconColor: Constants.textPrimary
                onClicked: appStack.pop()
            }
            
            Text {
                text: "Thread"
                font.bold: true
                font.pixelSize: Constants.fontHeader
                color: Constants.textPrimary
                Layout.alignment: Qt.AlignCenter
            }
            
            Item { Layout.fillWidth: true } // Spacer
        }
        
        // Bottom border
        Rectangle {
            width: parent.width
            height: 1
            color: Constants.divider
            anchors.bottom: parent.bottom
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        ListView {
            id: commentsList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: commentsModel
            
            // Header: The Main Post
            header: PostItem {
                width: parent.width
                username: postData.username || ""
                timeAgo: "Now" // timestamp conversion needed
                contentText: postData.content || ""
                likeCount: postData.likes || 0
                replyCount: postData.replies || 0
                avatarUrl: postData.avatar || ""
                imageSource: postData.media_url || ""
                mediaType: postData.media_type || "none"
                
                // Disabling click-through for details since we are already here
                enabled: false 
                
                // Visual tweak to show it's the parent
                Rectangle {
                    width: 2
                    color: Constants.divider
                    anchors.top: avatar.bottom // Pseudo-code anchor, PostItem needs to support this connector
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 30 // Approx center of avatar
                    visible: commentsModel.count > 0
                }
            }
            
            delegate: Item {
                width: parent.width
                height: contentLayout.implicitHeight + 20
                
                RowLayout {
                    id: contentLayout
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: Constants.standardMargin
                    spacing: 10
                    
                    // Avatar
                    RoundImage {
                        size: 30
                        source: model.avatar || ""
                        Layout.alignment: Qt.AlignTop
                    }
                    
                    // Content
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        RowLayout {
                            Text {
                                text: model.username
                                font.bold: true
                                color: Constants.textPrimary
                            }
                            Text {
                                text: "2m" // Placeholder time
                                color: Constants.textSecondary
                            }
                        }
                        
                        Text {
                            text: model.content
                            color: Constants.textPrimary
                            wrapMode: Text.Wrap
                            Layout.fillWidth: true
                        }
                    }
                }
                
                // Connector line from parent
                Rectangle {
                    width: 2
                    color: Constants.divider
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom // Or half height for last item
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    visible: index < commentsModel.count - 1
                }
            }
        }
        
        // Footer: Comment Input
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: Constants.background
            // Top Border
            Rectangle {
                width: parent.width
                height: 1
                color: Constants.divider
                anchors.top: parent.top
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                
                TextField {
                    id: commentInput
                    placeholderText: "Reply to " + (postData.username || "thread") + "..."
                    Layout.fillWidth: true
                    color: Constants.textPrimary
                    background: Rectangle {
                        color: Constants.surface
                        radius: 15
                    }
                }
                
                Button {
                    text: "Post"
                    enabled: commentInput.text.length > 0
                    onClicked: {
                        NetworkManager.postComment(postData.id, commentInput.text)
                        commentInput.text = ""
                        // Optmistic update: Add to model immediately
                        commentsModel.append({
                            "username": "me_myself_i", // Should get from session
                            "avatar": "",
                            "content": commentInput.text,
                            "timestamp": "Just now"
                        })
                    }
                }
            }
        }
    }
}
