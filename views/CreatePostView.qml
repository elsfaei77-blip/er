import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "../components"
import "../"

Item {
    id: root
    
    // Define signal to pass back data
    signal postCreated(string content)

    Rectangle {
        anchors.fill: parent
        color: Constants.background
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Constants.standardMargin
            spacing: 20
            
            Text {
                text: "New Thread"
                font.pixelSize: Constants.fontHeader
                font.bold: true
                color: Constants.textPrimary
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                RoundImage {
                    size: 40
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    
                    Text {
                        text: "me_myself_i"
                        font.bold: true
                        color: Constants.textPrimary
                    }
                    
                    TextArea {
                        id: inputField
                        Layout.fillWidth: true
                        placeholderText: "Start a thread..."
                        color: Constants.textPrimary
                        placeholderTextColor: Constants.textSecondary
                        font.pixelSize: Constants.fontBody
                        background: null // Remove default white box
                        wrapMode: Text.Wrap
                    }
                }
            }
            
            // Attachment Icons
            RowLayout {
                spacing: 20
                Text { text: "📎"; font.pixelSize: 20; color: Constants.textSecondary }
                Text { text: "📷"; font.pixelSize: 20; color: Constants.textSecondary }
                Text { text: "🎤"; font.pixelSize: 20; color: Constants.textSecondary }
                Item { Layout.fillWidth: true }
            }
            
            Item { Layout.fillHeight: true } // Spacer pushes button to bottom? No, keep it close.
            
            StyledButton {
                textContent: "Post"
                Layout.alignment: Qt.AlignRight
                isPrimary: inputField.text.length > 0
                enabled: inputField.text.length > 0
                opacity: enabled ? 1.0 : 0.5
                
                clickAction: function() {
                    root.postCreated(inputField.text)
                    inputField.text = "" // Clear
                }
            }
            
            Item { Layout.fillHeight: true } 
        }
    }
}
