import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../"

Item {
    id: root
    signal loginClicked(string username, string password)
    signal registerClicked()

    Rectangle {
        anchors.fill: parent
        color: Constants.background
        
        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width * 0.85
            spacing: 20
            
            // Brand / Logo
            Text {
                text: "MIRA"
                font.pixelSize: 40
                font.bold: true
                font.family: "Segoe UI"
                color: Constants.textPrimary
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 40
            }
            
            // Fields
            TextField {
                id: userField
                Layout.fillWidth: true
                placeholderText: "Username, email or mobile"
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
            
            // Login Button
            StyledButton {
                Layout.fillWidth: true
                textContent: "Validating..."
                visible: NetworkManager.isLoading
                enabled: false
            }
            
            StyledButton {
                Layout.fillWidth: true
                textContent: "Log In"
                visible: !NetworkManager.isLoading
                isPrimary: userField.text.length > 0 && passField.text.length > 0
                enabled: isPrimary
                
                clickAction: () => {
                    root.loginClicked(userField.text, passField.text)
                }
            }
            
            Text {
                text: "Forgot password?"
                color: Constants.textSecondary
                font.pixelSize: Constants.fontSmall
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
            }
        }
        
        // Footer: Register
        StyledButton {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width * 0.8
            textContent: "Create new account"
            isPrimary: false
            
            clickAction: () => root.registerClicked()
        }
    }
}
