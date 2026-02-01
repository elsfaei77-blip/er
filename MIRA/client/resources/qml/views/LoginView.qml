import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    color: "transparent" // Let Nebula background show through
    
    signal loginSuccess()
    signal loginClicked(string username, string password)
    signal registerClicked()
    
    // State: 0 = Login, 1 = Signup
    property int authMode: 0
    // Signup Step: 0 = Details, 1 = Verification
    property int signupStep: 0
    
    // Gradient removed in favor of global NebulaBackground
    
    // Decorative SADEEM Pattern (Subtle)
    Item {
        anchors.fill: parent
        opacity: 0.1 // Increased opacity for nebula effect
        // Repeater could be updated to use stars or just kept subtle
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: Math.min(parent.width - 60, 400)
        spacing: 32
        
        // --- LOGO SECTION ---
        Item {
            Layout.alignment: Qt.AlignHCenter
            width: 120; height: 120
            
            MiraIcon {
                anchors.centerIn: parent
                name: "mira" // Keeping icon but maybe user wants new icon later
                size: 80
                color: Theme.textPrimary
                
                // Pulse Animation
                SequentialAnimation on scale {
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.05; duration: 2000; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutQuad }
                }
            }
        }
        
        // --- TITLE ---
        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.authMode === 0 ? "Welcome Back" : (root.signupStep === 0 ? "Join SADEEM" : "Verify Email")
            color: Theme.textPrimary
            font.pixelSize: 28
            font.weight: Theme.weightBold
            font.family: Theme.fontFamily
        }

        // --- FORM FIELDS ---
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 16
            
            // Username Field (Signup Only)
            TextField {
                id: usernameField
                visible: root.authMode === 1 && root.signupStep === 0
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: "Username"
                color: Theme.textPrimary
                font.pixelSize: 16
                leftPadding: 16
                background: Rectangle {
                    color: Theme.surface
                    radius: 12
                    border.color: usernameField.activeFocus ? Theme.border : Theme.divider
                    border.width: usernameField.activeFocus ? 2 : 1
                }
            }

            // Email Field (Login: Username/Email, Signup: Email)
            TextField {
                id: emailField
                // Visible in Login OR Signup Step 0
                visible: root.authMode === 0 || root.signupStep === 0
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: root.authMode === 0 ? "Username, phone or email" : "Email address"
                color: Theme.textPrimary
                font.pixelSize: 16
                leftPadding: 16
                background: Rectangle {
                    color: Theme.surface
                    radius: 12
                    border.color: emailField.activeFocus ? Theme.border : Theme.divider
                    border.width: emailField.activeFocus ? 2 : 1
                }
            }
            
            // Password Field
            TextField {
                id: passField
                visible: root.authMode === 0 || root.signupStep === 0
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: "Password"
                echoMode: TextInput.Password
                color: Theme.textPrimary
                font.pixelSize: 16
                leftPadding: 16
                background: Rectangle {
                    color: Theme.surface
                    radius: 12
                    border.color: passField.activeFocus ? Theme.border : Theme.divider
                    border.width: passField.activeFocus ? 2 : 1
                }
            }
            
            // Verification Code Field (Signup Step 1)
            TextField {
                id: codeField
                visible: root.authMode === 1 && root.signupStep === 1
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: "Enter 6-digit code"
                color: Theme.textPrimary
                font.pixelSize: 16
                leftPadding: 16
                background: Rectangle {
                    color: Theme.surface
                    radius: 12
                    border.color: codeField.activeFocus ? Theme.border : Theme.divider
                    border.width: codeField.activeFocus ? 2 : 1
                }
            }
            
            Text {
                visible: root.authMode === 1 && root.signupStep === 1
                text: "We sent a code to " + emailField.text + ". It expires in 3 minutes."
                color: Theme.textSecondary
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
        
        // --- ACTION BUTTON ---
        MiraButton {
            Layout.fillWidth: true
            heightFixed: 52
            radius: 16
            fontSize: 16
            text: {
                if (root.authMode === 0) return qsTr("Log in")
                if (root.signupStep === 0) return qsTr("Get Code")
                return qsTr("Verify & Sign Up")
            }
            type: "primary"
            onClicked: {
                if (root.authMode === 0) {
                    root.loginClicked(emailField.text, passField.text)
                } else {
                    if (root.signupStep === 0) {
                        // Validate inputs
                        if (emailField.text === "" || passField.text === "" || usernameField.text === "") {
                            console.warn("Please look at the fields") // basic check
                            return
                        }
                        // Send Code
                        authService.sendVerificationCode(emailField.text)
                    } else {
                        // Complete Signup
                        authService.registerUser(usernameField.text, emailField.text, passField.text, codeField.text)
                    }
                }
            }
        }
        
        Connections {
             target: authService
             function onCodeSentSuccess() {
                 root.signupStep = 1 // Move to verification
             }
             function onCodeSentFailed(error) {
                 console.error("Code send failed: " + error)
                 // Show error toaster/dialog here
             }
             function onSignupSuccess() {
                 root.loginSuccess()
             }
             function onLoginSuccess() {
                 root.loginSuccess()
             }
         }
        // --- SEPARATOR ---
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 16
            opacity: 0.7
            
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.divider }
            Text {
                text: "Or" // "Or continue with" might be too long
                color: Theme.textSecondary
                font.pixelSize: 12
            }
            Rectangle { Layout.fillWidth: true; height: 1; color: Theme.divider }
        }

        // --- SOCIAL LOGIN ---
        MiraButton {
            Layout.fillWidth: true
            heightFixed: 52
            radius: 16
            fontSize: 16
            text: "Continue with Google"
            type: "secondary" // Utilizing secondary style
            
            // Hack to show icon if MiraButton doesn't support it directly:
            // relying on text for now.
            
            onClicked: {
                 // Simulate Google OAuth Response
                 // In production, this would open a WebView or use a native SDK
                 var randomId = "10" + Math.floor(Math.random() * 900000000);
                 var email = "user" + randomId.substring(0,5) + "@gmail.com";
                 var name = "Google User " + randomId.substring(0, 3);
                 var avatar = "https://api.dicebear.com/7.x/notionists/svg?seed=" + randomId;
                 
                 console.log("Simulating Google Login for: " + name);
                 authService.loginWithGoogle(email, randomId, name, avatar);
            }
        }

        Connections {
            target: authService
            function onLoginSuccess() {
                root.loginSuccess() // Navigate to home
            }
        }
        
        // --- SWITCH MODE ---
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 4
            
            Text {
                text: root.authMode === 0 ? "Don't have an account?" : "Already have an account?"
                color: Theme.textSecondary
                font.pixelSize: 14
                font.family: Theme.fontFamily
            }
            
            Text {
                text: root.authMode === 0 ? "Sign up" : "Log in"
                color: Theme.textPrimary
                font.weight: Theme.weightBold
                font.pixelSize: 14
                font.family: Theme.fontFamily
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.authMode === 0) {
                            root.authMode = 1
                        } else {
                            root.authMode = 0
                        }
                    }
                }
            }
        }
        
        Item { Layout.fillHeight: true } // Spacer
        
        // --- FOOTER ---
        ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "from SADEEM"
                color: Theme.textTertiary
                font.pixelSize: 12
                font.letterSpacing: 1
            }
        }
    }
}
