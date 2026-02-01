import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Dialog {
    id: root
    width: parent ? parent.width : 360
    height: 300
    x: 0
    y: parent ? parent.height - height : 0 // Bottom sheet style
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    property string placeholder: "Reply to thread..."
    property string initialText: ""
    
    signal textAccepted(string text)
    
    enter: Transition { NumberAnimation { property: "y"; from: root.parent.height; to: root.parent.height - root.height; duration: 200; easing.type: Easing.OutCubic } }
    exit: Transition { NumberAnimation { property: "y"; to: root.parent.height; duration: 200; easing.type: Easing.InCubic } }
    
    background: Rectangle {
        color: Theme.surfaceElevated
        radius: 16
        // mask corners to only top
    }
    
    header: Item {
        width: parent.width; height: 50
        Text { anchors.centerIn: parent; text: "Reply"; font.weight: Font.Bold; color: Theme.textPrimary }
        Text { 
            anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter
            text: "Post"; font.weight: Font.Bold; color: Theme.blue
            MouseArea { anchors.fill: parent; onClicked: { root.textAccepted(inputArea.text); root.close(); inputArea.text = "" } }
        }
        Text { 
            anchors.left: parent.left; anchors.leftMargin: 16; anchors.verticalCenter: parent.verticalCenter
            text: "Cancel"; color: Theme.textPrimary
            MouseArea { anchors.fill: parent; onClicked: root.close() }
        }
    }
    
    contentItem: ColumnLayout {
        TextArea {
            id: inputArea
            Layout.fillWidth: true; Layout.fillHeight: true
            placeholderText: root.placeholder
            color: Theme.textPrimary
            font.pixelSize: 16
            wrapMode: TextArea.WordWrap
            background: null
        }
    }
    
    onOpened: inputArea.forceActiveFocus()
}
