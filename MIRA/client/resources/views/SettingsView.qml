import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../assets" 

Page {
    id: root
    background: Rectangle { color: Constants.background }
    
    header: Rectangle {
        height: 60
        color: Constants.background
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: Constants.standardMargin
            
            IconButton {
                iconPath: Icons.arrowBack
                iconColor: Constants.textPrimary
                onClicked: internalStack.pop()
            }
            
            Text {
                text: "Settings"
                font.bold: true
                font.pixelSize: Constants.fontHeader
                color: Constants.textPrimary
                Layout.alignment: Qt.AlignCenter
            }
            
            Item { Layout.fillWidth: true }
        }
        
        Rectangle {
            width: parent.width; height: 1
            color: Constants.divider; anchors.bottom: parent.bottom
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Constants.standardMargin
        spacing: 20
        
        // Account Section
        Text {
            text: "Account"
            color: Constants.textSecondary
            font.bold: true
        }
        
        StyledButton {
            text: "Edit Profile"
            Layout.fillWidth: true
            onClicked: internalStack.push("EditProfileView.qml")
        }
        
        StyledButton {
            text: "Change Password"
            Layout.fillWidth: true
            color: "transparent"
            textColor: Constants.textPrimary
            border.color: Constants.divider
        }
        
        // App Section
        Text {
            text: "App Info"
            color: Constants.textSecondary
            font.bold: true
            Layout.topMargin: 20
        }
        
        Text {
            text: "MIRA v1.0 (Threads Clone)"
            color: Constants.textPrimary
        }
        
        Item { Layout.fillHeight: true } // Spacer
        
        // Logout
        StyledButton {
            text: "Log Out"
            Layout.fillWidth: true
            color: Constants.accent
            textColor: "#FFFFFF"
            onClicked: {
                NetworkManager.logout()
            }
        }
    }
}
