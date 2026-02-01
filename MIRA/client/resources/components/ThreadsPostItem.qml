// ThreadsPostItem.qml - Exact Threads post layout
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Item {
    id: root
    
    // Post data properties
    property string username: ""
    property string avatar: ""  
    property bool verified: false
    property string timeAgo: ""
    property string content: ""
    property string imageUrl: ""
    property int likeCount: 0
    property int replyCount: 0
    property bool isLiked: false
    
    signal clicked()
    signal likeClicked()
    signal replyClicked()
    signal shareClicked()
    signal moreClicked()
    
    width: parent.width
    height: contentLayout.height + ThreadsConstants.spacing4 * 2
    
    RowLayout {
        id: contentLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: ThreadsConstants.spacing4
        spacing: ThreadsConstants.spacing3
        
        // Left: Avatar + Thread Line
        Item {
            Layout.preferredWidth: ThreadsConstants.avatarMedium
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignTop
            
            // Avatar
            ThreadsAvatar {
                id: avatarImg
                size: ThreadsConstants.avatarMedium
                source: root.avatar
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Thread line (connecting to replies if any)
            Rectangle {
                visible: root.replyCount > 0
                width: 2
                color: ThreadsConstants.divider
                anchors.top: avatarImg.bottom
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: ThreadsConstants.spacing2
            }
        }
        
        // Right: Content
        ColumnLayout {
            Layout.fillWidth: true
            spacing: ThreadsConstants.spacing2
            
            // Header: Username + Time + More
            RowLayout {
                Layout.fillWidth: true
                spacing: ThreadsConstants.spacing2
                
                // Username
                Text {
                    text: root.username
                    font.family: ThreadsConstants.fontFamily
                    font.pixelSize: ThreadsConstants.fontBody
                    font.weight: ThreadsConstants.weightSemiBold
                    color: ThreadsConstants.textPrimary
                }
                
                // Verified badge
                Text {
                    visible: root.verified
                    text: "✓"
                    font.pixelSize: 14
                    color: ThreadsConstants.threadsBlue
                }
                
                Item { Layout.fillWidth: true }
                
                // Time ago
                Text {
                    text: root.timeAgo
                    font.family: ThreadsConstants.fontFamily
                    font.pixelSize: ThreadsConstants.fontCaption
                    color: ThreadsConstants.textSecondary
                }
                
                // More button
                Item {
                    width: 20
                    height: 20
                    
                    Text {
                        anchors.centerIn: parent
                        text: "•••"
                        font.pixelSize: 16
                        color: ThreadsConstants.textSecondary
                        rotation: 90
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.moreClicked()
                    }
                }
            }
            
            // Post Content
            Text {
                Layout.fillWidth: true
                text: root.content
                font.family: ThreadsConstants.fontFamily
                font.pixelSize: ThreadsConstants.fontBody
                font.weight: ThreadsConstants.weightRegular
                color: ThreadsConstants.textPrimary
                wrapMode: Text.Wrap
                lineHeight: ThreadsConstants.lineHeightNormal
            }
            
            // Image (if any)
            Image {
                visible: root.imageUrl !== ""
                Layout.fillWidth: true
                Layout.preferredHeight: width * 0.75
                source: root.imageUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                smooth: true
                clip: true
                
                // Rounded corners achieved with clip
                layer.enabled: true
                layer.smooth: true
            }
            
            // Action Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: ThreadsConstants.spacing4
                Layout.topMargin: ThreadsConstants.spacing2
                
                // Like button
                ActionButton {
                    icon: root.isLiked ? "❤️" : "🤍"
                    active: root.isLiked
                    onClicked: root.likeClicked()
                }
                
                // Reply button
                ActionButton {
                    icon: "💬"
                    onClicked: root.replyClicked()
                }
                
                // Repost button
                ActionButton {
                    icon: "🔄"
                }
                
                // Share button
                ActionButton {
                    icon: "📤"
                    onClicked: root.shareClicked()
                }
            }
            
            // Engagement stats
            RowLayout {
                Layout.fillWidth: true
                spacing: ThreadsConstants.spacing3
                
                Text {
                    visible: root.replyCount > 0
                    text: root.replyCount + (root.replyCount === 1 ? " reply" : " replies")
                    font.family: ThreadsConstants.fontFamily
                    font.pixelSize: ThreadsConstants.fontCaption
                    color: ThreadsConstants.textSecondary
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.replyClicked()
                    }
                }
                
                Text {
                    visible: root.likeCount > 0
                    text: root.likeCount + (root.likeCount === 1 ? " like" : " likes")
                    font.family: ThreadsConstants.fontFamily
                    font.pixelSize: ThreadsConstants.fontCaption
                    color: ThreadsConstants.textSecondary
                }
            }
        }
    }
    
    // Bottom divider
    Rectangle {
        width: parent.width
        height: 1
        color: ThreadsConstants.divider
        anchors.bottom: parent.bottom
    }
    
    // Click area for entire post
    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
        z: -1 // Behind action buttons
    }
    
    // Action Button Component
    component ActionButton: Item {
        property string icon: ""
        property bool active: false
        signal clicked()
        
        width: 24
        height: 24
        
        Text {
            anchors.centerIn: parent
            text: parent.icon
            font.pixelSize: 20
            color: parent.active ? ThreadsConstants.error : ThreadsConstants.textPrimary
            
            // Like animation
            scale: parent.active ? 1.1 : 1.0
            Behavior on scale {
                NumberAnimation {
                    duration: ThreadsConstants.animationFast
                    easing.type: Easing.OutBack
                }
            }
        }
        
        MouseArea {
            anchors.fill: parent
            anchors.margins: -8 // Bigger hit area
            onClicked: parent.clicked()
            
            // Press effect
            Rectangle {
                anchors.centerIn: parent
                width: 36
                height: 36
                radius: 18
                color: parent.pressed ? ThreadsConstants.hoverOverlay : "transparent"
            }
        }
    }
}
