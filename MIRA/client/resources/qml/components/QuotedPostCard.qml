import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import MiraApp

Rectangle {
    id: root
    width: parent.width
    implicitHeight: contentColumn.implicitHeight + 32
    color: Theme.surfaceLow
    radius: 16
    border.color: Theme.divider
    border.width: 1
    
    Behavior on scale { NumberAnimation { duration: 200; easing.type: Theme.springEasing } }
    
    property var quotedThreadData: null
    
    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8
        
        // Original author info
        RowLayout {
            spacing: 8
            
            Rectangle {
                width: 32
                height: 32
                radius: 16
                color: root.quotedThreadData ? root.quotedThreadData.avatarColor : Theme.accent
                
                Text {
                    anchors.centerIn: parent
                    text: root.quotedThreadData && root.quotedThreadData.author ? 
                          root.quotedThreadData.author.charAt(0).toUpperCase() : "?"
                    color: "white"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                }
            }
            
            ColumnLayout {
                spacing: 2
                
                RowLayout {
                    spacing: 4
                    
                    Text {
                        text: root.quotedThreadData ? root.quotedThreadData.author : qsTr("User")
                        color: Theme.textPrimary
                        font.pixelSize: 14
                        font.weight: Font.Bold
                    }
                    
                    MiraIcon {
                        name: "verified"
                        size: 14
                        color: Theme.accent
                        visible: root.quotedThreadData && root.quotedThreadData.isVerified
                    }
                }
                
                Text {
                    text: root.quotedThreadData ? root.quotedThreadData.time : ""
                    color: Theme.textSecondary
                    font.pixelSize: 12
                }
            }
        }
        
        // Quoted content
        Text {
            Layout.fillWidth: true
            text: root.quotedThreadData ? root.quotedThreadData.content : ""
            color: Theme.textPrimary
            font.pixelSize: 14
            wrapMode: Text.WordWrap
            maximumLineCount: 3
            elide: Text.ElideRight
        }
        
        // Quoted image (if exists) (PHASE 10 Fix)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            radius: 8
            clip: true
            visible: innerImg.source != ""
            
            Image {
                id: innerImg
                anchors.fill: parent
                source: root.quotedThreadData && root.quotedThreadData.imageUrl ? 
                        root.quotedThreadData.imageUrl : ""
                fillMode: Image.PreserveAspectCrop
            }
        }

        // MICRO-SHIMMER (PHASE 10)
        Rectangle {
            anchors.fill: parent
            radius: 16
            color: "transparent"
            clip: true
            z: 10
            
            LinearGradient {
                anchors.fill: parent
                start: Qt.point(shimmerPos - 100, 0)
                end: Qt.point(shimmerPos, 100)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Theme.isDarkMode ? Qt.rgba(1,1,1,0.02) : Qt.rgba(0,0,0,0.02) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
                property real shimmerPos: -100
                SequentialAnimation on shimmerPos {
                    loops: Animation.Infinite
                    PauseAnimation { duration: 12000 }
                    NumberAnimation { from: -200; to: root.width + 200; duration: 3000; easing.type: Easing.InOutSine }
                }
            }
        }
    }
    
    // Hover/Press overlay
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: Theme.hoverOverlay
        visible: cardMouse.pressed
    }
    
    MouseArea {
        id: cardMouse
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onPressed: root.scale = 0.98
        onReleased: root.scale = 1.0
        onClicked: {
            // Navigate to original thread
            if (root.quotedThreadData && root.quotedThreadData.id) {
                mainStack.push(PostDetailView, {
                    threadData: root.quotedThreadData,
                    threadIndex: -1
                })
            }
        }
    }
}
