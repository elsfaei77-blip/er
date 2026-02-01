import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"
import "../"

Item {
    id: root
    property alias model: feedList.model
    signal messagesClicked()
    signal postClicked(var postData)
    
    // Header
    Rectangle {
        id: header
        width: parent.width
        height: 60
        color: Constants.background
        z: 10
        
        // Blurred background effect for header (optional)
        // For now solid color
        
        Text {
            anchors.centerIn: parent
            text: "@" // Logo/Icon placeholder 
            font.pixelSize: 32
            font.bold: true
            font.family: "Courier New" // Monospace for that "code" feel
            color: Constants.textPrimary
        }
        
        // Messages Icon (Top Right)
        IconButton {
            anchors.right: parent.right
            anchors.rightMargin: Constants.standardMargin
            anchors.verticalCenter: parent.verticalCenter
            // iconPath: Icons.message // Need to add this to Icons.qml? Or use a generic one
            // Using a standard text icon for now if Icons.message not defined, or assume Icons.comment acts as generic chat
            // Let's use a specialized "Send" icon looking thing
            
            width: 24
            height: 24
            
            // Temporary SVG for DM/Messenger
            iconPath: "M12 2C6.48 2 2 6.48 2 12c0 3.31 2.69 6 6 6 .55 0 1 .45 1 1v2.58c0 .89 1.08 1.34 1.71.71L12.9 20.1c.36-.36.85-.57 1.35-.57h2.75c3.31 0 6-2.69 6-6S20.31 2 17 2H12z" 
            iconColor: Constants.textPrimary
            
            onClicked: root.messagesClicked()
        }
    }

    ListView {
        id: feedList
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true
        
        topMargin: 10
        bottomMargin: 20
        spacing: 0 // Spacing handled inside item or divider

        delegate: PostItem {
            username: model.username // Was userName
            timeAgo: model.time
            contentText: model.content // Was txt
            replyCount: model.replies
            likeCount: model.likes
            avatarUrl: model.avatar
            imageSource: model.media_url || ""
            mediaType: model.media_type || "none" // Pass type
            postId: model.id
            
            onClicked: {
                var data = {
                    "id": model.id,
                    "username": model.username,
                    "avatar": model.avatar,
                    "content": model.content,
                    "media_url": model.media_url,
                    "media_type": model.media_type,
                    "likes": model.likes,
                    "replies": model.replies
                }
                root.postClicked(data)
            }
        }
        
        // Pull to refresh placeholder
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            y: -30
            text: "↻"
            color: Constants.textSecondary
            visible: feedList.contentY < -50
        }
    }
}
