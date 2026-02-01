import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "../"

Item {
    id: root
    width: parent.width
    height: 70 // Taller for better touch target

    property int currentIndex: 0
    signal indexChanged(int newIndex)

    // Background Blur (Glassmorphism)
    // Note: To do real blur efficiently behind content requires 'ShaderEffectSource' of the content behind it.
    // For simplicity in this overlay type component, we'll use a semi-transparent black with a border.
    
    Rectangle {
        id: bg
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.85) // High opacity black
        // border.color: Constants.divider
        // border.width: 1
        // border.side: Border.Top (not valid in bare Rectangle, using separate line)
    }

    Rectangle {
        width: parent.width
        height: 1
        color: Constants.divider
        anchors.top: parent.top
        opacity: 0.5
    }

    RowLayout {
        anchors.fill: parent
        anchors.bottomMargin: 5 // Lift slighty
        spacing: 0

        NavItem { 
            index: 0
            iconName: "🏠" 
            label: "Home"
        }
        NavItem { 
            index: 1
            iconName: "🔍" 
            label: "Search"
        }
        NavItem { 
            index: 2
            iconName: "➕" 
            label: "Post"
            isHighlight: true // Special styling
        }
        NavItem { 
            index: 3
            iconName: "❤️" 
            label: "Activity"
        }
        NavItem { 
            index: 4
            iconName: "👤" 
            label: "Profile"
        }
    }

    component NavItem : Item {
        property int index: 0
        property string iconName: "?"
        property string label: ""
        property bool isHighlight: false
        
        property bool isSelected: root.currentIndex === index
        
        Layout.fillWidth: true
        Layout.fillHeight: true

        Item {
            anchors.centerIn: parent
            width: 30
            height: 30
            
            // Icon
            Text {
                anchors.centerIn: parent
                text: iconName
                font.pixelSize: isHighlight ? 26 : 24
                color: isHighlight ? Constants.textPrimary : (isSelected ? Constants.textPrimary : Constants.iconUnselected)
                scale: parent.parent.down ? 0.9 : 1.0
                Behavior on scale { NumberAnimation { duration: 100 } }
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.currentIndex = index
                root.indexChanged(index)
            }
        }
    }
}
