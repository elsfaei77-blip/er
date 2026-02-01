import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"
    
    // Glass Background
    Rectangle {
        anchors.fill: parent
        color: Theme.background
        opacity: 0.85
    }
    
    // Confetti Effect for Success (Hidden by default)
    StardustEffect {
        id: successConfetti
        anchors.centerIn: parent
        z: 100
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            color: "transparent"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                
                MiraIcon {
                    name: "back"
                    size: 24
                    color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mainStack.pop()
                    }
                }
                
                Text {
                    Layout.fillWidth: true
                    text: qsTr("Two-Factor Security")
                    color: Theme.textPrimary
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                }
                
                Item { width: 24; height: 24 }
            }
        }
        
        // Content
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: contentColumn.implicitHeight + 40
            clip: true
            
            ColumnLayout {
                id: contentColumn
                width: parent.width
                spacing: 24
                
                // Animated Shield Banner
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    Layout.margins: 16
                    radius: 24
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(Theme.successGreen.r, Theme.successGreen.g, Theme.successGreen.b, 0.1) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                    border.color: Qt.rgba(Theme.successGreen.r, Theme.successGreen.g, Theme.successGreen.b, 0.3)
                    border.width: 1
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 20
                        
                        // Shield Icon with Pulse
                        Rectangle {
                            width: 60; height: 60; radius: 30
                            color: Theme.surfaceElevated
                            border.color: Theme.successGreen
                            border.width: 2
                            
                            MiraIcon {
                                anchors.centerIn: parent
                                name: "shield_check" // Assuming mapped or fallback
                                size: 32
                                color: Theme.successGreen
                            }
                            
                            SequentialAnimation on scale {
                                loops: Animation.Infinite
                                NumberAnimation { to: 1.1; duration: 1500; easing.type: Easing.InOutSine }
                                NumberAnimation { to: 1.0; duration: 1500; easing.type: Easing.InOutSine }
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Text {
                                text: qsTr("Maximum Security")
                                color: Theme.successGreen
                                font.pixelSize: 18
                                font.weight: Font.Bold
                            }
                            
                            Text {
                                text: qsTr("Protect your account with advanced biometrics and 2FA keys.")
                                color: Theme.textSecondary
                                font.pixelSize: 14
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
                
                // Methods
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.margins: 16
                    spacing: 16
                    
                    Text {
                        text: qsTr("Active Methods")
                        color: Theme.textPrimary
                        font.pixelSize: 16
                        font.weight: Font.Bold
                    }
                    
                    // Glass Toggles
                    Repeater {
                        model: [
                            { title: "Biometric ID", desc: "FaceID / TouchID", icon: "face_id", active: true, color: Theme.blue },
                            { title: "Authenticator App", desc: "Google / Authy", icon: "lock", active: true, color: Theme.purple },
                            { title: "SMS Verification", desc: "+966 55 *** **89", icon: "smartphone", active: false, color: Theme.accent }
                        ]
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 90
                            radius: 20
                            color: Theme.glassBackground
                            border.color: Theme.glassBorder
                            border.width: 1
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16
                                
                                Rectangle {
                                    Layout.preferredWidth: 50
                                    Layout.preferredHeight: 50
                                    radius: 25
                                    color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.15)
                                    // icon
                                    Text { anchors.centerIn: parent; text: "🔒"; font.pixelSize: 20 }
                                }
                                
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4
                                    Text { text: modelData.title; color: Theme.textPrimary; font.weight: Font.Bold; font.pixelSize: 15 }
                                    Text { text: modelData.desc; color: Theme.textSecondary; font.pixelSize: 13 }
                                }
                                
                                // Neon Switch
                                Rectangle {
                                    width: 50; height: 28; radius: 14
                                    color: modelData.active ? modelData.color : Theme.surfaceElevated
                                    border.color: modelData.active ? modelData.color : Theme.divider
                                    border.width: 1
                                    
                                    Rectangle {
                                        width: 24; height: 24; radius: 12
                                        color: "white"
                                        x: modelData.active ? parent.width - width - 2 : 2
                                        anchors.verticalCenter: parent.verticalCenter
                                        Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
                                    }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if (!modelData.active) {
                                                successConfetti.explode()
                                                if (typeof nativeToast !== "undefined") nativeToast.show("Security Method Enabled", "success")
                                            }
                                            // Toggle logic would bind to model in real implementation
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Backup Codes Button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    Layout.margins: 16
                    radius: 20
                    color: "transparent"
                    border.color: Theme.accent
                    border.width: 1
                    
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Generate Backup Codes")
                        color: Theme.accent
                        font.weight: Font.Bold
                        font.pixelSize: 15
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onPressed: parent.opacity = 0.7
                        onReleased: parent.opacity = 1.0
                    }
                }
            }
        }
    }
}
