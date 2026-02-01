import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import MiraApp
import "../components"

Rectangle {
    id: root
    color: "transparent" // Let Nebula background show through
    
    // Data
    property var threadData: ({})
    property int threadIndex: 0 // Passed from outside
    property var viewModel: null // Passed from outside
    
    // LUMI-BACKGROUND (PHASE 10)
    RadialGradient {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: -200
        width: 600; height: 600
        opacity: Theme.isDarkMode ? 0.15 : 0.05
        z: -1
        gradient: Gradient {
            GradientStop { position: 0.0; color: root.threadData.avatarColor || Theme.accent }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }
    
    // Mock Replies (Local for now, could be in store)
    CommentModel {
        id: repliesModel
        postId: root.threadData.id || 0
    }
    
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: repliesModel.refresh()
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
                anchors.leftMargin: Theme.space8
                Item {
                    width: 48; height: 48
                    MiraIcon { anchors.centerIn: parent; name: "back"; size: 22; color: Theme.textPrimary; active: true }
                    MouseArea { anchors.fill: parent; onClicked: mainStack.pop() }
                }
                Text { text: Loc.getString("thread"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 18; font.family: Theme.fontFamily }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }
        
        ListView {
            id: detailList
            Layout.fillWidth: true; Layout.fillHeight: true
            clip: true
            model: repliesModel
            
            header: ColumnLayout {
                width: detailList.width
                spacing: 0

                PostCard {
                    postIndex: root.threadIndex
                    username: threadData.author || qsTr("User")
                    content: threadData.content || ""
                    timestamp: threadData.time || ""
                    avatarColor: threadData.avatarColor || Theme.gray
                    isVerified: false 
                    showThreadLine: false // Don't show line in detail view header
                    likes: threadData.likesCount || 0
                    replies: threadData.replyCount || 0
                    isLiked: threadData.isLiked || false
                    reactionType: threadData.reactionType || ""
                    reactionSummary: threadData.reactionSummary || ""
                    userId: threadData.userId || 0
                    viewModel: root.viewModel
                }
                
                // --- NEW: Premium Action Bar ---
                RowLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.space20
                    Layout.rightMargin: Theme.space20
                    Layout.bottomMargin: 16
                    spacing: 24
                    
                    Rectangle {
                        Layout.preferredWidth: 90; Layout.preferredHeight: 34; radius: 17
                        color: Theme.surface; border.color: Theme.divider
                        RowLayout {
                            anchors.centerIn: parent; spacing: 6
                            Text { text: "💬"; font.pixelSize: 12 }
                            Text { text: qsTr("Quote"); color: Theme.textPrimary; font.pixelSize: 12; font.weight: Font.Bold; font.family: Theme.fontFamily }
                        }
                        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                    }
                    
                    Rectangle {
                        Layout.preferredWidth: 80; Layout.preferredHeight: 34; radius: 17
                        color: Theme.surface; border.color: Theme.divider
                        RowLayout {
                            anchors.centerIn: parent; spacing: 6
                            Text { text: "💾"; font.pixelSize: 12 }
                            Text { text: qsTr("Save"); color: Theme.textPrimary; font.pixelSize: 12; font.weight: Font.Bold; font.family: Theme.fontFamily }
                        }
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: mainStack.push(savedView)
                        }
                    }
                    
                    Rectangle {
                        Layout.preferredWidth: 110; Layout.preferredHeight: 34; radius: 17
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Theme.accent }
                            GradientStop { position: 1.0; color: Theme.likeRed }
                        }
                        RowLayout {
                            anchors.centerIn: parent; spacing: 6
                            Text { text: "🎬"; font.pixelSize: 12 }
                            Text { text: qsTr("Share Reel"); color: Theme.background; font.pixelSize: 11; font.weight: Font.Bold; font.family: Theme.fontFamily }
                        }
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: mainStack.push(duetStitchView)
                        }
                    }
                    Item { Layout.fillWidth: true }
                }

                Rectangle { Layout.fillWidth: true; height: 8; color: Theme.divider; opacity: 0.1 }
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 48 // Match standard tab height
                    color: "transparent"
                    
                    RowLayout {
                        anchors.fill: parent
                        // Standardized Tab Style
                         Item {
                            Layout.fillWidth: true; Layout.fillHeight: true
                            Text { 
                                anchors.centerIn: parent; text: Loc.getString("thread");
                                color: Theme.textPrimary; font.weight: Theme.weightBold; font.family: Theme.fontFamily; font.pixelSize: 15 
                            }
                            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1.5; color: Theme.textPrimary }
                        }
                    }
                    Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider; z: -1 }
                }
            }
            
            delegate: PostCard {
                width: detailList.width
                username: model.author
                content: model.content
                timestamp: model.time
                avatarColor: model.avatarColor
                showThreadLine: index < repliesModel.count - 1
                isReply: true
            }
            
            footer: Item { width: parent.width; height: 100 }
        }
        
        // --- Sticky Comment Bar ---
        Rectangle {
            id: commentBar
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Theme.surface // Glassy
            border.color: Theme.divider
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 12
                
                Rectangle {
                    width: 32; height: 32; radius: 16
                    color: authService.currentUser.avatar || Theme.gray
                }
                
                TextField {
                    id: commentInput
                    Layout.fillWidth: true
                    placeholderText: qsTr("Reply to %1...").arg(threadData.author || "thread")
                    color: Theme.textPrimary
                    font.family: Theme.fontFamily; font.pixelSize: 14
                    background: null
                    activeFocusOnPress: true
                }
                
                Text {
                    text: qsTr("Post")
                    color: commentInput.text.length > 0 ? Theme.accent : Theme.textTertiary
                    font.weight: Theme.weightBold; font.pixelSize: 14; font.family: Theme.fontFamily
                    MouseArea {
                        anchors.fill: parent
                        enabled: commentInput.text.length > 0
                        onClicked: {
                            repliesModel.addComment(commentInput.text)
                            commentInput.text = ""
                            commentInput.focus = false
                        }
                    }
                }
            }
        }
    }
}
