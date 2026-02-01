import QtQuick
import QtQuick.Layouts
import MiraApp

Item {
    id: root
    
    property int userId: 0
    property string username: ""
    property string avatarSource: ""
    property real size: 40
    property bool clickable: true
    
    width: size; height: size
    
    // Story Indicator (Blue Border)
    Rectangle {
        id: storyBorder
        anchors.centerIn: parent
        width: parent.width + 4
        height: parent.height + 4
        radius: width / 2
        color: "transparent"
        border.width: 2
        border.color: Theme.storyRing
        
        // Phase 4: Story Ring Pulse Animation
        SequentialAnimation on border.color {
            loops: Animation.Infinite
            running: storyBorder.visible
            ColorAnimation { from: Theme.storyRing; to: Theme.accent; duration: 1500; easing.type: Easing.InOutSine }
            ColorAnimation { from: Theme.accent; to: Theme.storyRing; duration: 1500; easing.type: Easing.InOutSine }
        }
        
        // Visibility logic: Check if user has active stories in the global model
        // We'll use a global model instance from main.qml
        visible: (userId > 0) && (typeof globalStoryModel !== "undefined") && globalStoryModel.hasUserActiveStory(userId)
    }

    Rectangle {
        id: avatarContainer
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        radius: width / 2
        color: Theme.surface
        clip: true
        
        Image {
            id: avatarImage
            anchors.fill: parent
            source: {
                if (!avatarSource) return "";
                if (avatarSource.startsWith("http") || avatarSource.startsWith("/")) return avatarSource;
                return "https://api.dicebear.com/7.x/avataaars/svg?seed=" + (username || "user");
            }
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: false // Force reload for profile updates
            
            // Fallback for missing images
            onStatusChanged: {
                if (status === Image.Error) {
                    source = "https://api.dicebear.com/7.x/avataaars/svg?seed=" + (username || "user");
                }
            }
        }
    }
    
    scale: avatarMouseArea.containsMouse ? 1.05 : 1.0
    Behavior on scale { NumberAnimation { duration: Theme.animNormal; easing.type: Theme.springEasing } }

    MouseArea {
        id: avatarMouseArea
        anchors.fill: parent
        enabled: root.clickable
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (storyBorder.visible && typeof mainWindow !== "undefined" && mainWindow.openStory) {
                mainWindow.openStory(root.userId);
            } else if (typeof mainWindow !== "undefined" && mainWindow.openProfile) {
                mainWindow.openProfile(root.userId);
            }
        }
    }
}
