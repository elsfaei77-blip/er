import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import "../components"
import "../"

Item {
    id: root
    
    // Define signal to pass back data
    signal postCreated(string content, string url, string type)

    property string uploadedMediaUrl: ""
    property string uploadedMediaType: "none"

    FileDialog {
        id: filePicker
        title: "Select Media"
        nameFilters: ["Image files (*.jpg *.png)", "Video files (*.mp4)"]
        onAccepted: {
            var path = filePicker.selectedFile.toString()
            // selectedFile is for Qt.labs.platform, currentFile/fileUrl for others. 
            // In Qt 6.2+ standard FileDialog: currentFile
            if (path == "") path = filePicker.currentFile.toString()
            
            NetworkManager.uploadMedia(path)
        }
    }

    Connections {
        target: NetworkManager
        function onUploadSuccess(url, type) {
            uploadedMediaUrl = url
            uploadedMediaType = type
        }
    }

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
                    
                    // Media Preview
                    Image {
                        source: uploadedMediaUrl
                        visible: uploadedMediaUrl !== "" && uploadedMediaType === "image"
                        Layout.fillWidth: true
                        Layout.maximumHeight: 200
                        fillMode: Image.PreserveAspectFit
                    }
                    Text {
                        text: "[Video Attached]"
                        color: Constants.accentBlue
                        visible: uploadedMediaUrl !== "" && uploadedMediaType === "video"
                    }
                }
            }
            
            // Attachment Icons
            RowLayout {
                spacing: 20
                // Paperclip
                Icon { 
                    pathData: "M16.5 6v11.5c0 2.21-1.79 4-4 4s-4-1.79-4-4V5a2.5 2.5 0 015 0v10.5c0 .55-.45 1-1 1s-1-.45-1-1V6H10v9.5c0 1.38 1.12 2.5 2.5 2.5s2.5-1.12 2.5-2.5V5a4 4 0 00-8 0v12.5c0 3.04 2.46 5.5 5.5 5.5s5.5-2.46 5.5-5.5V6h-1.5z"
                    color: Constants.textSecondary
                    MouseArea { anchors.fill: parent; onClicked: filePicker.open() }
                }
                
                // Camera
                Icon { 
                    pathData: "M17 10.5V7c0-.55-.45-1-1-1H4c-.55 0-1 .45-1 1v10c0 .55.45 1 1 1h12c.55 0 1-.45 1-1v-3.5l4 4v-11l-4 4z"
                    color: Constants.textSecondary
                     MouseArea { anchors.fill: parent; onClicked: filePicker.open() }
                }

                Item { Layout.fillWidth: true }
            }
            
            Item { Layout.fillHeight: true } // Spacer pushes button to bottom?
            
            StyledButton {
                textContent: "Post"
                Layout.alignment: Qt.AlignRight
                isPrimary: inputField.text.length > 0 || uploadedMediaUrl !== ""
                enabled: isPrimary
                opacity: enabled ? 1.0 : 0.5
                
                clickAction: function() {
                    root.postCreated(inputField.text, uploadedMediaUrl, uploadedMediaType)
                    inputField.text = "" 
                    uploadedMediaUrl = ""
                    uploadedMediaType = "none"
                }
            }
            
            Item { Layout.fillHeight: true } 
        }
    }
}
