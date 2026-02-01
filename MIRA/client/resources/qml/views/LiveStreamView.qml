import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: "black" // Video base
    
    property string streamerName: qsTr("Sadeem Live")
    property int viewerCount: 1240
    property bool isLive: true
    
    // Video Placeholder with simulated content
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#000000" }
            GradientStop { position: 0.5; color: "#1a1a2e" }
            GradientStop { position: 1.0; color: "#000000" }
        }
        
        // Emulate video movement
        Rectangle {
            width: 200; height: 200
            radius: 100
            color: Theme.accent
            opacity: 0.1
            x: parent.width * 0.5
            y: parent.height * 0.3
            
            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { to: 1.2; duration: 3000 }
                NumberAnimation { to: 1.0; duration: 3000 }
            }
        }
    }

    // Top Overlay Gradient
    Rectangle {
        width: parent.width
        height: 120
        anchors.top: parent.top
        gradient: Gradient {
            GradientStop { position: 0.0; color: "black" }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }
    
    // Bottom Overlay Gradient
    Rectangle {
        width: parent.width
        height: 200
        anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "black" }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            Layout.margins: 16
            
            RowLayout {
                anchors.fill: parent
                spacing: 12
                
                // Streamer Info
                Rectangle {
                    Layout.preferredWidth: 40; Layout.preferredHeight: 40; radius: 20
                    color: Theme.surfaceElevated
                    CircleImage { anchors.fill: parent; anchors.margins: 2; source: "https://api.dicebear.com/7.x/avataaars/svg?seed=sadeem" }
                }
                
                ColumnLayout {
                    spacing: 2
                    Text { text: root.streamerName; color: "white"; font.weight: Font.Bold; font.pixelSize: 14 }
                    
                    RowLayout {
                        Rectangle { width: 8; height: 8; radius: 4; color: Theme.likeRed }
                        Text { text: formatViewerCount(root.viewerCount); color: "white"; font.pixelSize: 12 }
                    }
                }
                
                Item { Layout.fillWidth: true }
                
                // Close Btn
                Rectangle {
                    width: 36; height: 36; radius: 18
                    color: Qt.rgba(255,255,255,0.2)
                    MiraIcon { anchors.centerIn: parent; name: "close"; size: 16; color: "white" }
                    MouseArea { anchors.fill: parent; onClicked: mainStack.pop() }
                }
            }
        }
        
        Item { Layout.fillHeight: true } // Spacer
        
        // Chat Area
        ListView {
            Layout.fillWidth: true
            Layout.preferredHeight: 250
            Layout.leftMargin: 16
            Layout.rightMargin: 80 // Space for hearts
            clip: true
            displayMarginBeginning: 0
            displayMarginEnd: 0
            verticalLayoutDirection: ListView.BottomToTop
            spacing: 8
            
            model: ListModel {
                ListElement { user: "Sarah"; text: "This looks amazing! 🚀"; color: "#FF007F" }
                ListElement { user: "Ahmed"; text: "How did you do that effect?"; color: "#00FFFF" }
                ListElement { user: "MIRA_AI"; text: "Welcome to the future of streaming."; color: "#8A2BE2" }
            }
            
            delegate: Rectangle {
                width: parent.width
                height: msgRow.implicitHeight + 12
                color: Qt.rgba(0,0,0,0.4)
                radius: 12
                
                RowLayout {
                    id: msgRow
                    anchors.centerIn: parent
                    width: parent.width - 20
                    spacing: 8
                    
                    Text { text: model.user; color: model.color; font.weight: Font.Bold; font.pixelSize: 13 }
                    Text { text: model.text; color: "white"; font.pixelSize: 13; Layout.fillWidth: true }
                }
            }
        }
        
        // Input Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "transparent"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                anchors.rightMargin: 16
                spacing: 12
                
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 44
                    radius: 22
                    color: Qt.rgba(255,255,255,0.15)
                    border.color: Qt.rgba(255,255,255,0.3)
                    border.width: 1
                    
                    TextField {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        verticalAlignment: TextInput.AlignVCenter
                        placeholderText: qsTr("Say something...")
                        placeholderTextColor: Qt.rgba(255,255,255,0.6)
                        color: "white"
                        background: null
                    }
                }
                
                // Gift Button
                Rectangle {
                    width: 44; height: 44; radius: 22
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.aiGradientStart }
                        GradientStop { position: 1.0; color: Theme.aiGradientEnd }
                    }
                    Text { anchors.centerIn: parent; text: "🎁"; font.pixelSize: 20 }
                     MouseArea {
                         anchors.fill: parent
                         onClicked: {
                              stardust.explode()
                              if (typeof nativeToast !== "undefined") nativeToast.show("Sent a Gift!", "success")
                         }
                     }
                }
                
                // Heart Button
                Rectangle {
                    width: 44; height: 44; radius: 22
                    color: Qt.rgba(255,0,127,0.2)
                    border.color: Theme.likeRed
                    MiraIcon { anchors.centerIn: parent; name: "heart"; size: 20; color: Theme.likeRed; active: true }
                     MouseArea {
                         anchors.fill: parent
                         onClicked: {
                             // Fly heart animation would go here
                              stardust.explode()
                         }
                     }
                }
            }
        }
    }
    
    StardustEffect {
        id: stardust
        anchors.centerIn: parent
        z: 100
    }
    
    function formatViewerCount(count) {
        if (count >= 1000) return (count / 1000).toFixed(1) + "k";
        return count;
    }
}
