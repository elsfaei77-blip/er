import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects
import "../assets"
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
        color: Constants.surface // Glassy Dark
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
        anchors.bottomMargin: 5 
        spacing: 0

        NavItem { 
            index: 0
            iconPath: Icons.homeFilled
            label: "Home"
        }
        NavItem { 
            index: 1
            iconPath: Icons.search
            label: "Search"
        }
        NavItem { 
            index: 2
            iconPath: Icons.create
            label: "Post"
            isHighlight: true 
        }
        NavItem { 
            index: 3
            iconPath: Icons.comment // Using comment bubble for Messages/Activity
            label: "Messages"
        }
        NavItem { 
            index: 4
            iconPath: Icons.user
            label: "Profile"
        }
    }

    component NavItem : Item {
        property int index: 0
        property string iconPath: ""
        property string label: ""
        property bool isHighlight: false
        
        property bool isSelected: root.currentIndex === index
        
        Layout.fillWidth: true
        Layout.fillHeight: true

        Item {
            anchors.centerIn: parent
            width: 30
            height: 30
            
            // Vector Icon
            Icon {
                anchors.centerIn: parent
                pathData: iconPath
                color: isHighlight ? Constants.background : (isSelected ? Constants.neonBlue : Constants.textSecondary)
                
                // Special background for Highlight button (Post)
                Rectangle {
                    anchors.centerIn: parent
                    width: 44
                    height: 44
                    radius: 12
                    color: Constants.neonBlue
                    z: -1
                    visible: isHighlight
                    
                    // Simple Glow
                    Rectangle {
                         anchors.fill: parent; radius: 12; color: Constants.neonBlue; opacity: 0.5; scale: 1.1
                    }
                }
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
