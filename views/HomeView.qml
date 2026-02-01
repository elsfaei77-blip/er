import QtQuick 2.15
import QtQuick.Controls 2.15
import "../components"
import "../"

Item {
    id: root
    property alias model: feedList.model
    
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
            username: model.userName
            timeAgo: model.time
            contentText: model.txt
            replyCount: model.replies
            likeCount: model.likes
            avatarUrl: model.avatar
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
