import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: Theme.background
    
    property int currentIndex: 0
    
    SwipeView {
        id: swipeView
        anchors.fill: parent
        orientation: Qt.Vertical
        currentIndex: root.currentIndex
        onCurrentIndexChanged: {
            if (typeof HapticManager !== "undefined") HapticManager.triggerImpactLight()
        }
        
        Repeater {
            model: 10 // Sample reels
            
            Rectangle {
                width: swipeView.width
                height: swipeView.height
                color: index % 2 === 0 ? Theme.surface : Theme.surfaceElevated
                
                MouseArea {
                    anchors.fill: parent
                    onDoubleClicked: {
                        heartAnimation.start()
                        if (typeof HapticManager !== "undefined") HapticManager.triggerImpactHeavy()
                    }
                }

                // DOUBLE TAP HEART (PHASE 10)
                MiraIcon {
                    id: heartOverlay
                    anchors.centerIn: parent
                    name: "like"
                    size: 120
                    color: Theme.likeRed
                    opacity: 0
                    scale: 0
                    active: true
                    z: 100
                    
                    SequentialAnimation {
                        id: heartAnimation
                        ParallelAnimation {
                            NumberAnimation { target: heartOverlay; property: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.OutBack }
                            NumberAnimation { target: heartOverlay; property: "scale"; from: 0; to: 1.2; duration: 250; easing.type: Easing.OutBack }
                        }
                        PauseAnimation { duration: 400 }
                        ParallelAnimation {
                            NumberAnimation { target: heartOverlay; property: "opacity"; to: 0; duration: 200 }
                            NumberAnimation { target: heartOverlay; property: "scale"; to: 1.5; duration: 200 }
                        }
                    }
                }
                
                // Video placeholder
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 16
                    
                    Text {
                        text: "🎬"
                        font.pixelSize: 64
                        Layout.alignment: Qt.AlignHCenter
                    }
                    
                    Text {
                        text: qsTr("Reel %1").arg(index + 1)
                        color: Theme.textPrimary
                        font.pixelSize: 24
                        font.weight: Font.Bold
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
                
                // Creator info overlay
                ColumnLayout {
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.margins: 20
                    spacing: 12
                    width: parent.width - 100
                    
                    RowLayout {
                        spacing: 12
                        
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 20
                            color: Theme.accent
                            
                            Text {
                                anchors.centerIn: parent
                                text: "U"
                                color: Theme.textPrimary
                                font.pixelSize: 18
                                font.weight: Font.Bold
                            }
                        }
                        
                        ColumnLayout {
                            spacing: 2
                            
                            Text {
                                text: "@creator" + (index + 1)
                                color: Theme.textPrimary
                                font.pixelSize: 15
                                font.weight: Font.Bold
                            }
                            
                            Rectangle {
                                Layout.preferredWidth: followText.implicitWidth + 16
                                Layout.preferredHeight: 24
                                radius: 12
                                color: Theme.accent
                                
                                Text {
                                    id: followText
                                    anchors.centerIn: parent
                                    text: qsTr("Follow")
                                    color: Theme.background
                                    font.pixelSize: 12
                                    font.weight: Font.Bold
                                    font.family: Theme.fontFamily
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onPressed: parent.scale = 0.95
                                    onReleased: parent.scale = 1.0
                                }
                                Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }
                            }
                        }
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Amazing content! Check this out 🔥 #MIRA #Reels")
                        color: Theme.textPrimary
                        font.pixelSize: 14
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                    
                    // Sound info
                    RowLayout {
                        spacing: 8
                        
                        MiraIcon {
                            name: "music"
                            size: 14
                            color: "white"
                        }
                        
                        Text {
                            text: qsTr("Original Audio")
                            color: Theme.textPrimary
                            font.pixelSize: 12
                        }
                    }
                }
                
                // Action buttons (right side)
                ColumnLayout {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 20
                    spacing: 24
                    
                    // Like
                    ColumnLayout {
                        spacing: 4
                        
                        Rectangle {
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 48
                            radius: 24
                            color: Qt.rgba(0, 0, 0, 0.4)
                            border.color: Theme.divider; border.width: 1
                            
                            MiraIcon {
                                anchors.centerIn: parent
                                name: "like"
                                size: 24
                                color: Theme.textPrimary
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onPressed: parent.scale = 0.9; onReleased: parent.scale = 1.0
                            }
                            Behavior on scale { NumberAnimation { duration: 200; easing.type: Theme.springEasing } }
                        }
                        
                        Text {
                            text: (Math.floor(Math.random() * 100) + 10) + "K"
                            color: Theme.textPrimary
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                    
                    // Comment
                    ColumnLayout {
                        spacing: 4
                        
                        Rectangle {
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 48
                            radius: 24
                            color: Qt.rgba(255, 255, 255, 0.2)
                            
                            MiraIcon {
                                anchors.centerIn: parent
                                name: "comment"
                                size: 24
                                color: Theme.textPrimary
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                        
                        Text {
                            text: (Math.floor(Math.random() * 50) + 5) + "K"
                            color: Theme.textPrimary
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                    
                    // Share
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 24
                        color: Qt.rgba(255, 255, 255, 0.2)
                        
                        MiraIcon {
                            anchors.centerIn: parent
                            name: "share"
                            size: 24
                            color: Theme.textPrimary
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                    
                    // More options
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 24
                        color: Qt.rgba(0, 0, 0, 0.4)
                        border.color: Theme.divider; border.width: 1
                        
                        Text {
                            anchors.centerIn: parent
                            text: "⋯"
                            color: Theme.textPrimary
                            font.pixelSize: 24
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: parent.scale = 0.9; onReleased: parent.scale = 1.0
                        }
                        Behavior on scale { NumberAnimation { duration: 200; easing.type: Theme.springEasing } }
                    }
                }
                
                // Close button
                Rectangle {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: 20
                    width: 36
                    height: 36
                    radius: 18
                    color: Qt.rgba(0, 0, 0, 0.5)
                    
                    MiraIcon {
                        anchors.centerIn: parent
                        name: "close"
                        size: 18
                        color: Theme.textPrimary
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mainStack.pop()
                    }
                }
            }
        }
    }
}
