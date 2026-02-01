import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Popup {
    id: root
    width: parent.width
    height: contentCol.implicitHeight + 40
    y: parent.height - height
    
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    background: Rectangle {
        color: Theme.surface // Glassy
        radius: 24
        border.color: Theme.divider
        border.width: 1
        // Draw only top corners
        Rectangle { anchors.top: parent.bottom; width: parent.width; height: 100; color: Theme.surface; anchors.topMargin: -24 }
    }
    
    enter: Transition {
        NumberAnimation { property: "y"; from: parent.height; to: parent.height - root.height; duration: 400; easing.type: Easing.OutExpo }
    }
    exit: Transition {
        NumberAnimation { property: "y"; to: parent.height; duration: 300; easing.type: Easing.InExpo }
    }

    onOpened: if (typeof HapticManager !== "undefined") HapticManager.triggerImpactMedium()

    // Rubber-band drag to close
    MouseArea {
        id: dragArea
        anchors.fill: parent
        property real startY: 0
        property bool dragging: false
        
        onPressed: (mouse) => { startY = mouse.y; dragging = true }
        onPositionChanged: (mouse) => {
            if (dragging) {
                var delta = mouse.y - startY
                if (delta > 0) {
                    root.y = (parent.height - root.height) + delta
                } else {
                    // Rubber band effect for up-drag
                    root.y = (parent.height - root.height) + (delta * 0.2)
                }
            }
        }
        onReleased: (mouse) => {
            dragging = false
            if (mouse.y - startY > 100) {
                root.close()
            } else {
                returnAnimation.start()
            }
        }
        
        NumberAnimation { id: returnAnimation; target: root; property: "y"; to: parent.height - root.height; duration: 300; easing.type: Easing.OutBack }
    }
    
    property alias model: repeater.model
    signal itemClicked(int index, string label)

    ColumnLayout {
        id: contentCol
        anchors.fill: parent
        anchors.topMargin: 8
        spacing: 0
        
        // Handle bar
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 40; height: 4; radius: 2; color: Theme.divider
        }
        
        Item { Layout.preferredHeight: 16 }
        
        Repeater {
            id: repeater
            delegate: Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                color: "transparent"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24; anchors.rightMargin: 24
                    spacing: 16
                    
                    Text { 
                        text: modelData.icon || ""
                        font.pixelSize: 20
                        visible: text !== ""
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        text: modelData.label
                        color: modelData.isDestructive ? Theme.likeRed : Theme.textPrimary
                        font.pixelSize: 17; font.weight: Theme.weightMedium; font.family: Theme.fontFamily
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.color = Qt.rgba(255, 255, 255, 0.05)
                    onReleased: parent.color = "transparent"
                    onCanceled: parent.color = "transparent"
                    onClicked: {
                        root.itemClicked(index, modelData.label)
                        root.close()
                    }
                }
                
                Rectangle {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
                    anchors.leftMargin: 24; anchors.rightMargin: 24
                    height: 0.5; color: Theme.divider
                    visible: index < repeater.count - 1
                }
            }
        }
    }
}
