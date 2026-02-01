import QtQuick 2.15
import QtQuick.Layouts 1.15
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
            }

            // Action Icons Row
            RowLayout {
                spacing: 15
                Layout.topMargin: 8
                
                Text { text: "❤️"; font.pixelSize: 18; color: Constants.textPrimary }
                Text { text: "💬"; font.pixelSize: 18; color: Constants.textPrimary }
                Text { text: "🔁"; font.pixelSize: 18; color: Constants.textPrimary }
                Text { text: "🚀"; font.pixelSize: 18; color: Constants.textPrimary }
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
