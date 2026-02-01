import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    color: Theme.background
    anchors.fill: parent
    
    // Properties passed in
    property var stories: [] // Array of {url: "", type: "image", time: ""}
    property string username: ""
    property string userAvatar: ""
    property int userId: 0 // New
    
    signal closed()
    signal profileClicked(int userId) // New
    signal nextUser() // To skip to next user
    signal prevUser()
    signal deleteRequested(int storyId)
    
    property int currentIndex: 0
    property int duration: 5000 // 5 seconds per story
    property bool isPaused: false
    
    function start() {
        currentIndex = 0
        storyTimer.elapsed = 0
        storyTimer.restart()
    }
    
    // Progress Bars
    RowLayout {
        id: progressRow
        anchors.top: parent.top; anchors.topMargin: 10
        anchors.left: parent.left; anchors.right: parent.right
        anchors.leftMargin: 10; anchors.rightMargin: 10
        spacing: 4
        z: 20
        
        Repeater {
            model: root.stories.length
            delegate: Rectangle {
                Layout.fillWidth: true; height: 2; radius: 1
                color: Theme.gray
                
                Rectangle {
                    width: (index < root.currentIndex) ? parent.width : (index === root.currentIndex ? (storyTimer.elapsed / root.duration) * parent.width : 0)
                    height: parent.height
                    color: Theme.textPrimary
                    opacity: 1
                }
            }
        }
    }
    
    // Header
    RowLayout {
        anchors.top: progressRow.bottom; anchors.topMargin: 10
        anchors.left: parent.left; anchors.leftMargin: 10
        spacing: 10
        z: 20
        
        Rectangle {
            width: 32; height: 32; radius: 16
            color: Theme.gray
            CircleImage { anchors.fill: parent; source: root.userAvatar; fillMode: Image.PreserveAspectCrop }
            MouseArea { anchors.fill: parent; onClicked: root.profileClicked(root.userId) }
        }
        
        Text {
            text: root.username
            color: Theme.textPrimary
            font.weight: Theme.weightBold
            font.pixelSize: 14
            MouseArea { anchors.fill: parent; onClicked: root.profileClicked(root.userId) }
        }
        
        Text {
            text: "12h" // Dynamic?
            color: Theme.textPrimary
            opacity: 0.6
            font.pixelSize: 14
        }
    }
    
    // Close Button
    MiraIcon {
        anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 20
        name: "close"; size: 24; color: Theme.textPrimary
        z: 20
        MouseArea { anchors.fill: parent; onClicked: root.closed() }
    }

    MiraIcon {
        visible: root.userId === (authService.currentUser ? authService.currentUser.id : -1)
        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 20
        name: "more"; size: 24; color: Theme.textPrimary
        z: 20
        MouseArea { 
            anchors.fill: parent; 
            onClicked: {
                if (root.stories[root.currentIndex]) {
                    root.deleteRequested(root.stories[root.currentIndex].id)
                }
            }
        }
    }
    
    // Main Content
    Item {
        anchors.fill: parent
        
        Image {
            id: storyImage
            anchors.fill: parent
            source: root.stories[root.currentIndex] ? root.stories[root.currentIndex].url : ""
            fillMode: Image.PreserveAspectCrop
            visible: root.stories[root.currentIndex] ? root.stories[root.currentIndex].type === "image" : false
        }
        
        // Navigation Areas
        Row {
            anchors.fill: parent
            
            // Left Tap (Prev)
            MouseArea {
                width: parent.width * 0.3; height: parent.height
                onClicked: {
                    if (root.currentIndex > 0) {
                        root.currentIndex--
                        storyTimer.restart()
                    } else {
                        root.prevUser()
                    }
                }
            }
            
            // Middle (Pause hold) - TODO
            
            // Right Tap (Next)
            MouseArea {
                width: parent.width * 0.7; height: parent.height
                onClicked: {
                   advance()
                }
            }
        }
    }
    
    // Timer
    // We need a custom timer roughly tracking progress for smooth bar
    property int elapsed: 0
    Timer {
        id: storyTimer
        interval: 16 // 60fps
        repeat: true
        running: !root.isPaused && root.visible
        property int elapsed: 0
        onTriggered: {
            elapsed += 16
            if (elapsed >= root.duration) {
                advance()
            }
            progressRow.requestPaint // Not needed for rectangle width binding usually unless strict
        }
    }
    
    function advance() {
        if (root.currentIndex < root.stories.length - 1) {
            root.currentIndex++
            storyTimer.elapsed = 0
            storyTimer.restart()
        } else {
            root.nextUser() // Or close if last
            if (!root.nextUser.connected) root.closed()
        }
    }
}
