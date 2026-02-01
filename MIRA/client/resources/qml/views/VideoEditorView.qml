import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent" // Let NebulaBackground show through
    
    // Glass Background
    Rectangle {
        anchors.fill: parent
        color: Theme.background
        opacity: 0.8
    }

    property string videoSource: ""
    property real trimStart: 0.15
    property real trimEnd: 0.85
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "transparent"
            
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
                
                Item { Layout.fillWidth: true }
                
                // Neon Pill Button
                Rectangle {
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 32
                    radius: 16
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.aiGradientStart }
                        GradientStop { position: 1.0; color: Theme.aiGradientEnd }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Next")
                        color: "white"
                        font.pixelSize: 14
                        font.weight: Font.Bold
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                             if (typeof nativeToast !== "undefined") nativeToast.show("Processing Video...", "info")
                        }
                    }
                }
            }
        }
        
        // Video Preview Area (Placeholder for actual video surface)
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "black"
            radius: 20
            Layout.margins: 16
            clip: true
            
            Text {
                anchors.centerIn: parent
                text: "🎬 Live Preview"
                color: Theme.textSecondary
                font.pixelSize: 18
            }
            
            // Overlays
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.8; color: "transparent" }
                    GradientStop { position: 1.0; color: "black" }
                }
            }
            
            // Play Button Overlay
            Rectangle {
                anchors.centerIn: parent
                width: 64; height: 64
                radius: 32
                color: Qt.rgba(0,0,0,0.5)
                border.color: "white"
                border.width: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "▶"
                    color: "white"
                    font.pixelSize: 24
                }
            }
        }
        
        // Editor Panel
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 320
            color: Theme.glassBackground
            radius: 24
            
            // Top Border Glow
            Rectangle {
                anchors.top: parent.top
                width: parent.width
                height: 1
                color: Theme.glassBorder
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20
                
                // Tools List
                ScrollView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    contentWidth: toolsRow.implicitWidth
                    clip: true
                    
                    RowLayout {
                        id: toolsRow
                        height: parent.height
                        spacing: 24
                        
                        Repeater {
                            model: [
                                { icon: "scissors", label: "Trim" },
                                { icon: "music", label: "Audio" },
                                { icon: "type", label: "Text" },
                                { icon: "filters", label: "Filters" },
                                { icon: "stickers", label: "Stickers" },
                                { icon: "speed", label: "Speed" }
                            ]
                            
                            ColumnLayout {
                                spacing: 8
                                
                                Rectangle {
                                    Layout.preferredWidth: 48
                                    Layout.preferredHeight: 48
                                    radius: 24
                                    color: index === 0 ? Theme.surfaceElevated : "transparent"
                                    border.color: index === 0 ? Theme.accent : Theme.divider
                                    border.width: 1
                                    
                                    MiraIcon {
                                        anchors.centerIn: parent
                                        name: modelData.icon // mapping to available icons or fallback
                                        size: 20
                                        color: index === 0 ? Theme.accent : Theme.textSecondary
                                        active: index === 0
                                    }
                                }
                                
                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: modelData.label
                                    color: index === 0 ? Theme.textPrimary : Theme.textTertiary
                                    font.pixelSize: 11
                                    font.weight: Font.Medium
                                }
                            }
                        }
                    }
                }
                
                // Timeline
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "00:00"; color: Theme.textTertiary; font.pixelSize: 11 }
                        Item { Layout.fillWidth: true }
                        Text { text: "00:15"; color: Theme.textTertiary; font.pixelSize: 11 }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        color: Theme.surface
                        radius: 8
                        clip: true
                        
                        // Filmstrip Pattern
                        Row {
                            anchors.fill: parent
                            Repeater {
                                model: 10
                                Rectangle {
                                    width: parent.width / 10
                                    height: parent.height
                                    color: (index % 2 === 0) ? Qt.rgba(255,255,255,0.05) : Qt.rgba(255,255,255,0.02)
                                    border.color: "black"
                                    border.width: 1
                                    
                                    // Simulated wave
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: parent.width
                                        height: Math.random() * 40 + 10
                                        color: Qt.rgba(Theme.accent.r, Theme.accent.g, Theme.accent.b, 0.2)
                                    }
                                }
                            }
                        }
                        
                        // Active Area Overlay (Dim inactive parts)
                        Rectangle {
                            anchors.left: parent.left
                            width: parent.width * root.trimStart
                            height: parent.height
                            color: "black"
                            opacity: 0.6
                        }
                        Rectangle {
                            anchors.right: parent.right
                            width: parent.width * (1.0 - root.trimEnd)
                            height: parent.height
                            color: "black"
                            opacity: 0.6
                        }
                        
                        // Trimmer Frame
                        Item {
                            anchors.fill: parent
                            
                            // Left Handle
                            Rectangle {
                                x: parent.width * root.trimStart - 10
                                width: 20; height: parent.height
                                color: Theme.accent
                                radius: 4
                                z: 10
                                MiraIcon { anchors.centerIn: parent; name: "chevron_left"; size: 12; color: "black" }
                            }
                            
                            // Right Handle
                            Rectangle {
                                x: parent.width * root.trimEnd - 10
                                width: 20; height: parent.height
                                color: Theme.accent
                                radius: 4
                                z: 10
                                MiraIcon { anchors.centerIn: parent; name: "chevron_right"; size: 12; color: "black" }
                            }
                            
                            // Top/Bottom Borders
                            Rectangle {
                                x: parent.width * root.trimStart
                                width: parent.width * (root.trimEnd - root.trimStart)
                                height: 2; color: Theme.accent
                                anchors.top: parent.top
                            }
                            Rectangle {
                                x: parent.width * root.trimStart
                                width: parent.width * (root.trimEnd - root.trimStart)
                                height: 2; color: Theme.accent
                                anchors.bottom: parent.bottom
                            }
                        }
                    }
                    
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Selected: 00:10"
                        color: Theme.accent
                        font.pixelSize: 12
                        font.weight: Font.Bold
                    }
                }
            }
        }
    }
}
