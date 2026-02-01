import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Rectangle {
    id: root
    width: parent.width
    implicitHeight: contentColumn.implicitHeight + 32
    radius: 20
    color: Theme.surfaceLow
    border.color: Theme.divider
    border.width: 1
    
    Behavior on scale { NumberAnimation { duration: 300; easing.type: Theme.elasticEasing } }
    
    property string question: "What's your favorite feature?"
    property var options: ["Carousel", "Reels", "Live", "Stories"]
    property var votes: [45, 30, 15, 10]
    property int totalVotes: 100
    
    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12
        
        Text {
            text: root.question
            color: Theme.textPrimary
            font.pixelSize: 16
            font.weight: Font.Bold
            font.family: Theme.fontFamily
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
        
        Repeater {
            model: root.options
            
            Rectangle {
                id: optionRect
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                radius: 12
                color: Theme.surfaceHigh
                border.color: Theme.divider
                border.width: 1
                
                property bool selected: false
                
                // Vote percentage bar (Phase 10: Smooth Transition)
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * (root.votes[index] / 100)
                    radius: 12
                    color: Theme.accent
                    opacity: 0.15
                    
                    Behavior on width {
                        NumberAnimation { duration: 800; easing.type: Easing.OutQuart }
                    }
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12
                    
                    Text {
                        Layout.fillWidth: true
                        text: modelData
                        color: Theme.textPrimary
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        font.family: Theme.fontFamily
                    }
                    
                    Text {
                        text: root.votes[index] + "%"
                        color: Theme.textPrimary
                        font.pixelSize: 13
                        font.weight: Font.Bold
                        font.family: Theme.fontFamily
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPressed: optionRect.scale = 0.96
                    onReleased: optionRect.scale = 1.0
                    onClicked: {
                        optionRect.selected = true
                        if (typeof HapticManager !== "undefined") HapticManager.triggerImpactLight()
                    }
                }
                Behavior on scale { NumberAnimation { duration: 250; easing.type: Theme.elasticEasing } }
            }
        }
        
        Text {
            text: root.totalVotes + qsTr(" votes")
            color: Theme.textTertiary
            font.pixelSize: 11
            font.family: Theme.fontFamily
        }
    }
}
