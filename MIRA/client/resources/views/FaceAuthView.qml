import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../assets"
import "../" // For Constants

Item {
    id: root
    signal authSuccess()
    
    Rectangle {
        anchors.fill: parent
        color: Constants.background
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 30
            
            // Neon Logo
            Logo {
                Layout.alignment: Qt.AlignHCenter
                scale: 1.5
            }
            
            Text {
                text: "MIRA"
                color: Constants.neonBlue
                font.pixelSize: 32
                font.letterSpacing: 4
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                
                // Glow effect simulation
                layer.enabled: true
            }
            
            Text {
                text: "FACE AUTHENTICATION"
                color: Constants.neonBlue
                font.pixelSize: 12
                font.letterSpacing: 2
                Layout.alignment: Qt.AlignHCenter
                opacity: 0.8
            }
            
            // Scanner Visual
            Item {
                Layout.alignment: Qt.AlignHCenter
                width: 200
                height: 200
                
                // Wireframe Face (Simplified)
                Rectangle {
                    anchors.centerIn: parent
                    width: 120
                    height: 160
                    radius: 60
                    color: "transparent"
                    border.color: Constants.neonBlue
                    border.width: 1
                    opacity: 0.3
                    
                    // Grid lines
                    Rectangle { anchors.centerIn: parent; width: parent.width; height: 1; color: Constants.neonBlue; opacity: 0.2 }
                    Rectangle { anchors.centerIn: parent; width: 1; height: parent.height; color: Constants.neonBlue; opacity: 0.2 }
                }
                
                // Scanning Line
                Rectangle {
                    id: scanLine
                    width: parent.width
                    height: 2
                    color: Constants.neonBlue
                    y: 0
                    
                    // Glow
                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width
                        height: 10
                        color: Constants.neonBlue
                        opacity: 0.5
                    }
                    
                    SequentialAnimation {
                        running: true
                        loops: Animation.Infinite
                        NumberAnimation { target: scanLine; property: "y"; from: 0; to: 200; duration: 1500; easing.type: Easing.InOutQuad }
                        NumberAnimation { target: scanLine; property: "y"; from: 200; to: 0; duration: 1500; easing.type: Easing.InOutQuad }
                    }
                }
            }
            
            Text {
                id: statusText
                text: "SCANNING..."
                color: Constants.textPrimary
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
                
                SequentialAnimation {
                    running: true
                    loops: Animation.Infinite
                    OpacityAnimator { to: 0.2; duration: 800 }
                    OpacityAnimator { to: 1.0; duration: 800 }
                }
            }
        }
    }
    
    // Simulate Auth Success after 3 seconds
    Timer {
        interval: 3000
        running: true
        onTriggered: {
            statusText.text = "ACCESS GRANTED"
            statusText.color = Constants.neonGreen
            root.authSuccess()
        }
    }
}
