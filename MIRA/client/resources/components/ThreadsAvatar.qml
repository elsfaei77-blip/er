// ThreadsAvatar.qml - Exact Threads avatar component
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    
    property int size: ThreadsConstants.avatarMedium
    property string source: ""
    property bool showStoryRing: false
    property bool showOnlineDot: false
    
    width: size
    height: size
    
    // Story ring (gradient border)
    Rectangle {
        visible: showStoryRing
        anchors.fill: parent
        radius: width / 2
        color: "transparent"
        border.width: 2
        border.color: ThreadsConstants.threadsBlue
    }
    
    // Avatar image
    Rectangle {
        anchors.centerIn: parent
        width: showStoryRing ? parent.width - 4 : parent.width
        height: width
        radius: width / 2
        color: ThreadsConstants.surface
        clip: true
        
        Image {
            anchors.fill: parent
            source: root.source
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
            
            // Fallback for missing image
            Rectangle {
                visible: parent.status !== Image.Ready
                anchors.fill: parent
                color: ThreadsConstants.divider
                
                Text {
                    anchors.centerIn: parent
                    text: "👤"
                    font.pixelSize: parent.width * 0.5
                }
            }
        }
        
        // Border
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "transparent"
            border.width: 1
            border.color: ThreadsConstants.divider
        }
    }
    
    // Online status dot
    Rectangle {
        visible: showOnlineDot
        width: size * 0.25
        height: width
        radius: width / 2
        color: ThreadsConstants.success
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        border.width: 2
        border.color: ThreadsConstants.background
    }
}
