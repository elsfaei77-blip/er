import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import MiraApp

Rectangle {
    id: root
    height: Theme.navHeight
    color: "transparent"
    
    Rectangle {
        id: dockBackground
        anchors.fill: parent
        anchors.margins: 8
        radius: Theme.radiusLarge
        color: Theme.surface
        border.color: Theme.divider
        border.width: 1
        
        // Premium Shadow
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color: Theme.shadowColor
            radius: Theme.shadowSoft
            verticalOffset: 2
        }
    }
    
    // Luxurious Hairline Divider Removed for Floating Dock
    
    property int currentIndex: 0
    signal tabChanged(int index)

    RowLayout {
        id: navLayout
        anchors.fill: dockBackground
        anchors.leftMargin: 12; anchors.rightMargin: 12
        spacing: 0
        
        // Phase 4: Sliding Active Indicator
        Rectangle {
            id: slidingIndicator
            width: 4; height: 4; radius: 2
            color: Theme.accent
            y: parent.height - 12
            z: 10
            
            // Logic to position indicator below the active tab
            property real targetX: {
                if (root.currentIndex === 0) return navLayout.children[0].x + navLayout.children[0].width/2 - 2
                if (root.currentIndex === 1) return navLayout.children[1].x + navLayout.children[1].width/2 - 2
                if (root.currentIndex === 3) return navLayout.children[3].x + navLayout.children[3].width/2 - 2
                if (root.currentIndex === 4) return navLayout.children[4].x + navLayout.children[4].width/2 - 2
                return -100 // Hide for center button
            }
            
            x: targetX
            visible: x > 0
            
            Behavior on x { 
                NumberAnimation { 
                    duration: Theme.animNormal
                    easing.type: Theme.luxuryEasing
                } 
            }
        }
        
        NavButton { 
            name: "home"; 
            active: root.currentIndex === 0; 
            onClicked: { root.currentIndex = 0; root.tabChanged(0); } 
        }
        
        NavButton { 
            name: "search" // This icon name should probably be "explore" if you have it
            active: root.currentIndex === 1; 
            onClicked: { root.currentIndex = 1; root.tabChanged(1); } 
        }
        
        // --- The Centerpiece: Obsidian Plus Button ---
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            Rectangle {
                id: createBtn
                anchors.centerIn: parent
                width: 52; height: 40
                radius: 12
                
                // Multi-stop gradient for obsidian depth
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#1A1A1A" }
                    GradientStop { position: 0.5; color: "#000000" }
                    GradientStop { position: 1.0; color: "#000000" }
                }
                
                // MAGNETIC HUB: Localized glow on hover/pull
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    opacity: createMouseArea.containsMouse ? 0.3 : 0.1
                    visible: root.currentIndex !== 2
                    RadialGradient {
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Theme.aiAccent }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }
                    Behavior on opacity { NumberAnimation { duration: 300 } }
                }

                border.color: Theme.divider
                border.width: 1
                
                MiraIcon {
                    anchors.centerIn: parent
                    name: "create_plus"
                    size: 24
                    active: true
                    color: Theme.textPrimary
                    opacity: 1.0
                }
                
                MouseArea {
                    id: createMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: { root.currentIndex = 2; root.tabChanged(2); }
                    onPressed: {
                        createBtn.scale = 0.9
                        if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                    }
                    onReleased: createBtn.scale = 1.0
                    onCanceled: createBtn.scale = 1.0
                }
                
                // MAGNETIC ROTATION
                transform: Rotation {
                    origin.x: 26; origin.y: 20
                    angle: createMouseArea.containsMouse ? 5 : 0
                    Behavior on angle { SpringAnimation { spring: 3; damping: 0.2 } }
                }
                
                // Phase 4: Subtle Idle Pulse
                SequentialAnimation on scale {
                    running: root.currentIndex !== 2
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 1.02; duration: 2000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 1.02; to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                }
                
                Behavior on scale { 
                    NumberAnimation { 
                        duration: 300
                        easing.type: Theme.springEasing
                        easing.amplitude: Theme.springOvershoot 
                    } 
                }
            }
        }
        
        NavButton { 
            name: "heart"; 
            active: root.currentIndex === 3; 
            onClicked: { root.currentIndex = 3; root.tabChanged(3); } 
        }

        NavButton { 
            name: "profile"; 
            active: root.currentIndex === 4; 
            onClicked: { root.currentIndex = 4; root.tabChanged(4); } 
        }
    }

    component NavButton: Item {
        id: btnRoot
        property string name: ""
        property bool active: false
        signal clicked()
        
        Layout.fillWidth: true
        Layout.fillHeight: true
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 2
            
            MiraIcon {
                Layout.alignment: Qt.AlignHCenter
                name: btnRoot.name
                size: 26
                active: btnRoot.active
                color: btnRoot.active ? Theme.accent : Theme.gray
                opacity: btnRoot.active ? 1.0 : 0.6
                
                layer.enabled: false
            }
            
            // Active Indicator (Removed in favor of global sliding indicator)
/*             Rectangle {
                visible: btnRoot.active
                Layout.alignment: Qt.AlignHCenter
                width: 4; height: 4; radius: 2
                color: Theme.accent
                opacity: 1.0
            } */
        }
        
        MouseArea {
            id: btnMouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: btnRoot.clicked()
            onPressed: {
                if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
            }
        }
        
        // GLOBAL MAGNETISM
        transform: Rotation {
            origin.x: btnRoot.width/2; origin.y: btnRoot.height/2
            angle: btnMouseArea.containsMouse ? (btnRoot.name === "home" ? -3 : 3) : 0
            Behavior on angle { SpringAnimation { spring: 4; damping: 0.2 } }
        }

        scale: btnMouseArea.pressed ? 0.85 : 1.0
        Behavior on scale { 
            NumberAnimation { 
                duration: 300
                easing.type: Theme.springEasing
                easing.amplitude: Theme.springOvershoot 
            } 
        }
    }
}
