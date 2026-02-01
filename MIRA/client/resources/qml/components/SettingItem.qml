import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Rectangle {
    id: itemRoot
    property string icon: ""
    property string label: ""
    property string value: ""
    property bool hasSwitch: false
    property bool switchActive: false
    
    signal clicked()

    width: parent.width; height: 56
    color: "transparent"
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20
        spacing: Theme.space16
        
        Text { 
            text: itemRoot.icon; 
            font.pixelSize: 18;
            color: Theme.textSecondary
            visible: itemRoot.icon !== ""
        }
        
        Text { 
            text: itemRoot.label
            color: Theme.textPrimary
            font.pixelSize: 16
            font.weight: Theme.weightRegular
            font.family: Theme.fontFamily 
            Layout.fillWidth: true 
        }

        Text {
            visible: itemRoot.value !== ""
            text: itemRoot.value
            color: Theme.textSecondary
            font.pixelSize: 14; font.family: Theme.fontFamily
        }
        
        // Executive Platinum Switch
        Rectangle {
            id: switchContainer
            visible: itemRoot.hasSwitch
            width: 42; height: 24; radius: 12
            color: itemRoot.switchActive ? Theme.accent : Theme.surface
            border.color: itemRoot.switchActive ? "transparent" : Theme.divider
            border.width: 1
            
            Rectangle {
                id: handle
                x: itemRoot.switchActive ? 20 : 2
                anchors.verticalCenter: parent.verticalCenter
                width: 20; height: 20; radius: 10
                color: "white"
                
                layer.enabled: true
                
                Behavior on x { NumberAnimation { duration: 300; easing.type: Theme.springEasing } }
            }
            
            Behavior on color { ColorAnimation { duration: 200 } }
            MouseArea { anchors.fill: parent; onClicked: itemRoot.clicked() }
        }
        
        Text { 
            text: "›"
            color: Theme.textTertiary
            font.pixelSize: 22
            visible: !itemRoot.hasSwitch
        }
    }
    
    // Hairline divider
    Rectangle { 
        anchors.bottom: parent.bottom; 
        anchors.left: parent.left; anchors.leftMargin: Theme.space20; anchors.right: parent.right; anchors.rightMargin: Theme.space20
        height: 1; color: Theme.divider
    }
    
    MouseArea { 
        anchors.fill: parent
        enabled: !itemRoot.hasSwitch
        onPressed: { itemRoot.color = Theme.hoverOverlay; itemRoot.scale = 0.98 }
        onReleased: { itemRoot.color = "transparent"; itemRoot.scale = 1.0 }
        onCanceled: { itemRoot.color = "transparent"; itemRoot.scale = 1.0 }
        onClicked: itemRoot.clicked()
    }
    Behavior on scale { NumberAnimation { duration: 200; easing.type: Theme.springEasing } }
}
