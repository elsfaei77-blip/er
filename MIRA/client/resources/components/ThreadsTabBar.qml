// ThreadsTabBar.qml - Exact Threads bottom navigation
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: root
    
    property int currentIndex: 0
    signal tabClicked(int index)
    
    height: 50
    color: ThreadsConstants.background
    
    // Top border
    Rectangle {
        width: parent.width
        height: 1
        color: ThreadsConstants.divider
        anchors.top: parent.top
    }
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // Home Tab
        TabButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            active: root.currentIndex === 0
            icon: active ? ThreadsIcons.homeActive : ThreadsIcons.home
            onClicked: root.tabClicked(0)
        }
        
        // Search Tab
        TabButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            active: root.currentIndex === 1
            icon: ThreadsIcons.search
            onClicked: root.tabClicked(1)
        }
        
        // New Post Tab (Center, special styling)
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            Rectangle {
                anchors.centerIn: parent
                width: 32
                height: 32
                radius: ThreadsConstants.radiusSmall
                color: root.currentIndex === 2 ? ThreadsConstants.textPrimary : "transparent"
                border.width: 1
                border.color: ThreadsConstants.textPrimary
                
                // Plus icon
                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()
                        ctx.strokeStyle = root.currentIndex === 2 ? 
                            ThreadsConstants.background : ThreadsConstants.textPrimary
                        ctx.lineWidth = 2
                        ctx.lineCap = "round"
                        
                        // Horizontal line
                        ctx.beginPath()
                        ctx.moveTo(8, 16)
                        ctx.lineTo(24, 16)
                        ctx.stroke()
                        
                        // Vertical line
                        ctx.beginPath()
                        ctx.moveTo(16, 8)
                        ctx.lineTo(16, 24)
                        ctx.stroke()
                    }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: root.tabClicked(2)
            }
        }
        
        // Activity Tab
        TabButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            active: root.currentIndex === 3
            icon: ThreadsIcons.heart
            activeIcon: ThreadsIcons.heartFilled
            onClicked: root.tabClicked(3)
        }
        
        // Profile Tab
        TabButton {
            Layout.fillWidth: true
            Layout.fillHeight: true
            active: root.currentIndex === 4
            icon: ThreadsIcons.user
            onClicked: root.tabClicked(4)
        }
    }
    
    // Individual Tab Button Component
    component TabButton: Item {
        id: tabButton
        property bool active: false
        property string icon: ""
        property string activeIcon: icon
        signal clicked()
        
        // Icon Container
        Item {
            anchors.centerIn: parent
            width: 24
            height: 24
            
            // Simple icon representation using shapes
            Rectangle {
                anchors.centerIn: parent
                width: 24
                height: 24
                color: "transparent"
                
                // Simplified icon rendering
                Text {
                    anchors.centerIn: parent
                    text: getIconChar()
                    font.pixelSize: 24
                    color: tabButton.active ? ThreadsConstants.textPrimary : ThreadsConstants.textSecondary
                    
                    function getIconChar() {
                        if (tabButton.icon === ThreadsIcons.homeActive || tabButton.icon === ThreadsIcons.home) return "🏠"
                        if (tabButton.icon === ThreadsIcons.search) return "🔍"
                        if (tabButton.icon === ThreadsIcons.heart || tabButton.icon === ThreadsIcons.heartFilled) 
                            return tabButton.active ? "❤️" : "🤍"
                        if (tabButton.icon === ThreadsIcons.user) return "👤"
                        return ""
                    }
                }
            }
            
            // Active indicator (small dot below icon)
            Rectangle {
                visible: tabButton.active
                width: 4
                height: 4
                radius: 2
                color: ThreadsConstants.textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                anchors.topMargin: 4
            }
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: tabButton.clicked()
            
            // Press effect
            Rectangle {
                anchors.fill: parent
                color: parent.pressed ? ThreadsConstants.pressedOverlay : "transparent"
                radius: ThreadsConstants.radiusSmall
            }
        }
    }
}
