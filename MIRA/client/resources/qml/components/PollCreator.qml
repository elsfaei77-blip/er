import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Rectangle {
    id: root
    width: parent ? parent.width : 300
    height: contentLayout.implicitHeight + 24
    color: Theme.surfaceElevated
    radius: 12
    border.color: Theme.divider
    border.width: 1
    
    property alias option1: opt1.text
    property alias option2: opt2.text
    
    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12
        
        Text {
            text: qsTr("Poll")
            color: Theme.textPrimary
            font.weight: Font.Bold
        }
        
        TextField {
            id: opt1
            Layout.fillWidth: true
            placeholderText: qsTr("Option 1")
            color: Theme.textPrimary
            background: Rectangle { color: Theme.background; radius: 8; border.width: 0 }
        }
        
        TextField {
            id: opt2
            Layout.fillWidth: true
            placeholderText: qsTr("Option 2")
            color: Theme.textPrimary
            background: Rectangle { color: Theme.background; radius: 8; border.width: 0 }
        }
        
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Theme.divider
        }
        
        Text {
            text: qsTr("Poll duration: 24 hours")
            color: Theme.textSecondary
            font.pixelSize: 12
        }
    }
    
    // Remove button
    Rectangle {
        anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 8
        width: 20; height: 20; radius: 10; color: Theme.divider
        Text { anchors.centerIn: parent; text: "✕"; color: Theme.textSecondary; font.pixelSize: 10 }
        MouseArea { anchors.fill: parent; onClicked: root.visible = false } 
    }
}
