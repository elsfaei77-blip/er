import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: Theme.background
    
    property string originalVideoUrl: ""
    property string mode: "duet" // "duet" or "stitch"
    
    RowLayout {
        anchors.fill: parent
        spacing: 2
        
        // Original video (left side for duet, top for stitch)
        Rectangle {
            Layout.fillWidth: root.mode === "duet"
            Layout.fillHeight: true
            Layout.preferredWidth: root.mode === "duet" ? parent.width / 2 : parent.width
            color: Theme.surface
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 12
                
                Text {
                    text: "📹"
                    font.pixelSize: 48
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Text {
                    text: "Original Video"
                    color: Theme.textPrimary
                    font.pixelSize: 16
                    Layout.alignment: Qt.AlignHCenter
                }
            }
            
            // Creator badge
            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.margins: 16
                width: creatorText.implicitWidth + 24
                height: 32
                radius: 16
                color: Qt.rgba(0, 0, 0, 0.7)
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    Rectangle {
                        width: 24
                        height: 24
                        radius: 12
                        color: Theme.blue
                        
                        Text {
                            anchors.centerIn: parent
                            text: "U"
                            color: "white"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                        }
                    }
                    
                    Text {
                        id: creatorText
                        text: "@creator"
                        color: Theme.textPrimary
                        font.pixelSize: 12
                    }
                }
            }
        }
        
        // Your video (right side for duet, bottom for stitch)
        Rectangle {
            Layout.fillWidth: root.mode === "duet"
            Layout.fillHeight: true
            Layout.preferredWidth: root.mode === "duet" ? parent.width / 2 : parent.width
            color: Theme.surfaceElevated
            
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 12
                
                Text {
                    text: "🎥"
                    font.pixelSize: 48
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Text {
                    text: "Your Video"
                    color: Theme.textPrimary
                    font.pixelSize: 16
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Rectangle {
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 44
                    radius: 22
                    color: Theme.likeRed
                    
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Text {
                            text: "⏺"
                            color: Theme.textPrimary
                            font.pixelSize: 20
                        }
                        
                        Text {
                            text: "Record"
                            color: Theme.textPrimary
                            font.pixelSize: 14
                            font.weight: Font.Bold
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
    
    // Top controls
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 60
        color: Qt.rgba(0, 0, 0, 0.8)
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            
            MiraIcon {
                name: "close"
                size: 24
                color: Theme.textPrimary
                MouseArea {
                    anchors.fill: parent
                    onClicked: mainStack.pop()
                }
            }
            
            Text {
                Layout.fillWidth: true
                text: root.mode === "duet" ? "Duet" : "Stitch"
                color: Theme.textPrimary
                font.pixelSize: 18
                font.weight: Font.Bold
                horizontalAlignment: Text.AlignHCenter
            }
            
            // Mode toggle
            Rectangle {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 36
                radius: 18
                color: Qt.rgba(255, 255, 255, 0.2)
                
                Text {
                    anchors.centerIn: parent
                    text: root.mode === "duet" ? "Switch to Stitch" : "Switch to Duet"
                    color: "white"
                    font.pixelSize: 11
                    font.weight: Font.Bold
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.mode = root.mode === "duet" ? "stitch" : "duet"
                    }
                }
            }
        }
    }
}
