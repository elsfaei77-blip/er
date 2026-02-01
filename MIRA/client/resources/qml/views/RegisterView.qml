import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import MiraApp
import "../components"

Item {
    id: root
    signal backClicked()
    signal registerClicked(string username, string password)

    Rectangle {
        anchors.fill: parent
        color: "transparent" // Nebula background
        
        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width * 0.85
            spacing: 20
            
            Text {
                text: "Join SADEEM"
                font.pixelSize: 32
                font.bold: true
                color: Theme.textPrimary
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20
                font.family: Theme.fontFamily
            }
            
            TextField {
                id: userField
                Layout.fillWidth: true
                placeholderText: "Username"
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                background: Rectangle {
                    color: Theme.surface
                    radius: 8
                    border.color: Theme.divider
                }
                padding: 15
            }
            
            TextField {
                id: passField
                Layout.fillWidth: true
                placeholderText: "Password"
                echoMode: TextInput.Password
                color: Theme.textPrimary
                font.family: Theme.fontFamily
                background: Rectangle {
                    color: Theme.surface
                    radius: 8
                    border.color: Theme.divider
                }
                padding: 15
            }
            
            MiraButton {
                Layout.fillWidth: true
                heightFixed: 50
                radius: 10
                fontSize: 16
                text: qsTr("Sign Up")
                type: "primary"
                onClicked: root.registerClicked(userField.text, passField.text)
            }
            
            MiraButton {
                Layout.fillWidth: true
                heightFixed: 50
                radius: 10
                fontSize: 16
                text: qsTr("Back to Login")
                type: "secondary"
                onClicked: root.backClicked()
            }
        }
    }
}
