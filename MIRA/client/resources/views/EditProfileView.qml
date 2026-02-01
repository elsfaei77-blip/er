import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1 // For FileDialog
import "../assets"
import "../components"

Item {
    id: root
    property string currentBio: ""
    property string currentAvatar: ""
    
    signal closeReq()
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: Constants.standardMargin
        spacing: 20
        
        // Header
        RowLayout {
            Layout.fillWidth: true
            
            Text {
                text: "Cancel"
                color: Constants.textPrimary
                font.pixelSize: Constants.fontBody
                MouseArea { anchors.fill: parent; onClicked: root.closeReq() }
            }
            
            Item { Layout.fillWidth: true }
            
            Text {
                text: "Edit Profile"
                color: Constants.textPrimary
                font.bold: true
                font.pixelSize: Constants.fontTitle
            }
            
            Item { Layout.fillWidth: true }
            
            Text {
                text: "Done"
                color: Constants.neonBlue
                font.bold: true
                font.pixelSize: Constants.fontBody
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        NetworkManager.updateProfile(bioInput.text, root.currentAvatar)
                        root.closeReq()
                    }
                }
            }
        }
        
        // Content
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            color: Constants.surface
            radius: 12
            border.color: Constants.divider
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16
                
                // Name & Avatar
                RowLayout {
                    Layout.fillWidth: true
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        Text { text: "Name"; font.bold: true; color: Constants.textPrimary }
                        Text { text: "username"; color: Constants.textPrimary } // Username is locked usually
                        
                        Rectangle { height: 1; Layout.fillWidth: true; color: Constants.divider; Layout.topMargin: 10 }
                        
                        Text { text: "Bio"; font.bold: true; color: Constants.textPrimary; Layout.topMargin: 10 }
                        TextField {
                            id: bioInput
                            text: root.currentBio
                            placeholderText: "+ Write bio"
                            color: Constants.textPrimary
                            background: Item {} // Transparent
                            Layout.fillWidth: true
                            font.pixelSize: Constants.fontBody
                        }
                    }
                    
                    // Avatar Area
                    ColumnLayout {
                        spacing: 5
                        RoundImage {
                            id: avatarPreview
                            size: 60
                            source: root.currentAvatar
                        }
                        Text {
                            text: "Edit picture"
                            color: Constants.neonBlue
                            font.bold: true
                            font.pixelSize: Constants.fontSmall
                            
                            MouseArea {
                                anchors.fill: parent
                                onClicked: fileDialog.open()
                            }
                        }
                    }
                }
                
                Rectangle { height: 1; Layout.fillWidth: true; color: Constants.divider }
                
                Text { text: "Link"; font.bold: true; color: Constants.textPrimary }
                Text { text: "+ Add link"; color: Constants.textSecondary }
                
                Rectangle { height: 1; Layout.fillWidth: true; color: Constants.divider }
                
                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "Private profile"; font.bold: true; color: Constants.textPrimary }
                    Item { Layout.fillWidth: true }
                    Switch { checked: false }
                }
            }
        }
        
        Item { Layout.fillHeight: true } // spacer
    }
    
    FileDialog {
        id: fileDialog
        title: "Select Profile Picture"
        nameFilters: ["Image files (*.png *.jpg *.jpeg)"]
        onAccepted: {
             NetworkManager.uploadMedia(fileDialog.file)
        }
    }
    
    // Connect to upload success to update preview
    Connections {
        target: NetworkManager
        function onUploadSuccess(url, type) {
            root.currentAvatar = url
        }
    }
}
