import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects 
import QtMultimedia
import "../assets"
import "../"

Item {
    id: root
    width: parent.width
    height: layout.implicitHeight + Constants.standardMargin * 2 // Auto height

    property string username: "username"
    property string timeAgo: "2h"
    property string contentText: "This is a sample thread post. It looks like the real thing!"
    property string avatarUrl: ""
    property int likeCount: 0
    property int replyCount: 0
    property string imageSource: ""
    property string mediaType: "none"
    property int postId: 0
    signal clicked()

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Constants.standardMargin
        spacing: Constants.smallMargin
        
        // Left Column: Avatar + Thread Line
        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            spacing: 5
            
            RoundImage {
                size: 36
                source: root.avatarUrl
            }
            
            // Thread connecting line (visual flair)
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 2
                Layout.fillHeight: true
                Layout.minimumHeight: 20
                color: Constants.divider
                visible: true // Typically visible if there are replies
            }
        }

        // Right Column: Content
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            // Header: Username + Time + Options
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: root.username
                    font.bold: true
                    font.pixelSize: Constants.fontNormal
                    color: Constants.textPrimary
                }
                
                Item { Layout.fillWidth: true } // Spacer

                Text {
                    text: root.timeAgo
                    font.pixelSize: Constants.fontSmall
                    color: Constants.textSecondary
                }
                
                Text {
                    text: "•••"
                    font.pixelSize: Constants.fontSmall
                    color: Constants.textSecondary
                }
            }



            // Body Text
            Text {
                text: root.contentText
                font.pixelSize: Constants.fontNormal
                color: Constants.textPrimary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                visible: text.length > 0
            }
            


            // Post Media Container
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: width * 0.5625 // 16:9
                visible: root.imageSource !== "" && root.imageSource !== "http://localhost:5000/static/uploads/"
                


                // IMAGE (Simple)
                Image {
                    id: postImg
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: root.imageSource
                    visible: root.mediaType === "image"
                }

                // VIDEO (Simple)
                Video {
                    id: postVideo
                    anchors.fill: parent
                    source: root.mediaType === "video" ? root.imageSource : ""
                    fillMode: VideoOutput.PreserveAspectCrop
                    visible: root.mediaType === "video"
                    loops: MediaPlayer.Infinite
                    
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: postVideo.playbackState === MediaPlayer.PlayingState ? postVideo.pause() : postVideo.play()
                    }
                    
                    Rectangle {
                         anchors.centerIn: parent
                         width: 50; height: 50
                         radius: 25; color: "#80000000"
                         visible: postVideo.playbackState !== MediaPlayer.PlayingState && root.mediaType === "video"
                         Text { anchors.centerIn: parent; text: "▶"; color: "white"; font.pixelSize: 24 }
                    }
                }
            }

            // Action Icons Row
            RowLayout {
                spacing: 20
                Layout.topMargin: 12
                
                // Like
                IconButton {
                    width: 20; height: 20
                    iconPath: Icons.heartOutline // Should toggle to heart
                    iconColor: Constants.textPrimary
                    onClicked: NetworkManager.toggleLike(root.postId)
                }
                
                // Comment
                IconButton {
                    width: 20; height: 20
                    iconPath: Icons.comment
                    iconColor: Constants.textPrimary
                    onClicked: console.log("Comment clicked")
                }
                
                // Repost
                IconButton {
                    width: 22; height: 22
                    iconPath: Icons.repost
                    iconColor: Constants.textPrimary
                }
                
                // Share
                IconButton {
                    width: 20; height: 20
                    iconPath: Icons.share
                    iconColor: Constants.textPrimary
                }
                
                Item { Layout.fillWidth: true } // Push left
            }
            
            // Footer: Likes/Replies
            Text {
                text: root.replyCount + " replies · " + root.likeCount + " likes"
                font.pixelSize: Constants.fontSmall
                color: Constants.textSecondary
                Layout.topMargin: 4
                visible: root.replyCount > 0 || root.likeCount > 0
            }
        }
    }
    
    // Bottom Divider
    Rectangle {
        width: parent.width
        height: 1
        color: Constants.divider
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        // Often inset in threads
        anchors.left: parent.left
        anchors.leftMargin: 60 // Align with text
    }
}
