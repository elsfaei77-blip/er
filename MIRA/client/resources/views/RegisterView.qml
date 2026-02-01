import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../"

Item {
    id: root
    signal backClicked()
    signal registerClicked(string username, string password)

    Rectangle {
        anchors.fill: parent
        color: Constants.background
        
        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width * 0.85
            spacing: 20
            
            Text {
                text: "Join MIRA"
                font.pixelSize: 32
                font.bold: true
                color: Constants.textPrimary
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 20
            }
            
            TextField {
                id: userField
                Layout.fillWidth: true
                placeholderText: "Username"
                color: Constants.textPrimary
                background: Rectangle {
                    color: Constants.surface
                    radius: 8
                    border.color: Constants.divider
                }
                padding: 15
            }
            
            TextField {
                id: passField
                Layout.fillWidth: true
                placeholderText: "Password"
                echoMode: TextInput.Password
                color: Constants.textPrimary
                background: Rectangle {
                    color: Constants.surface
                    radius: 8
                    border.color: Constants.divider
                }
                padding: 15
            }
            
            StyledButton {
                Layout.fillWidth: true
                textContent: "Sign Up"
                isPrimary: true
                visible: !NetworkManager.isLoading
                
                clickAction: () => {
                   root.registerClicked(userField.text, passField.text)
                }
            }
            
            StyledButton {
                Layout.fillWidth: true
                textContent: "Back to Login"
                isPrimary: false
                clickAction: () => root.backClicked()
            }
        }
    }
}
