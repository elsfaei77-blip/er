import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import MiraApp
import "../components"

Rectangle {
    id: root
    color: Theme.background
    property var profileViewModel
    
    // Bindings to ViewModel
    property string currentUserName: profileViewModel ? profileViewModel.fullName : ""
    property string currentUserHandle: profileViewModel ? profileViewModel.username : ""
    property string currentUserBio: profileViewModel ? profileViewModel.bio : ""
    property string currentUserAvatarColor: profileViewModel ? profileViewModel.avatarColor : ""
    

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20
                Text { 
                    text: Loc.getString("cancel")
                    color: Theme.textSecondary
                    font.family: Theme.fontFamily
                    MouseArea { anchors.fill: parent; onClicked: mainStack.pop() } 
                }
                Item { Layout.fillWidth: true }
                Text { 
                    text: Loc.getString("editProfile")
                    color: Theme.textPrimary
                    font.weight: Theme.weightBold
                    font.pixelSize: 17
                    font.family: Theme.fontFamily 
                }
                Item { Layout.fillWidth: true }
                Text { 
                    text: Loc.getString("done")
                    color: Theme.accent
                    font.weight: Theme.weightBold
                    font.family: Theme.fontFamily
                    MouseArea { anchors.fill: parent; onClicked: {
                        profileViewModel.updateProfile(bioIn.text, root.currentUserAvatarColor);
                        mainStack.pop();
                    } } 
                }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }
        
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            ColumnLayout {
                width: parent.width
                spacing: Theme.space32
                Layout.topMargin: Theme.space24
                Layout.leftMargin: Theme.space24
                Layout.rightMargin: Theme.space24
                
                // Avatar Edit Section
                Item {
                    Layout.alignment: Qt.AlignHCenter
                    width: 100; height: 100
                    
                    FileDialog {
                        id: avatarPicker
                        title: qsTr("Select Profile Picture")
                        nameFilters: ["Image files (*.jpg *.png *.jpeg)"]
                        onAccepted: {
                            var path = avatarPicker.selectedFile.toString();
                            // Remove file:/// prefix if present
                            if (Qt.platform.os === "windows") {
                                path = path.replace(/^(file:\/{3})|(file:)/, "");
                            } else {
                                path = path.replace(/^file:\/\//, "");
                            }
                            
                            mainStack.push(cropperComponent, {imagePath: "file:///" + path});
                        }
                    }
                    
                    Component {
                        id: cropperComponent
                        ImageCropperView {
                            onCropped: (path) => {
                                mainStack.pop(); // Close cropper
                                // Update ViewModel
                                profileViewModel.uploadAndSetAvatar(path);
                            }
                            onCancelled: {
                                mainStack.pop();
                            }
                        }
                    }

                    Rectangle {
                        id: previewAvatar
                        anchors.fill: parent; radius: 50
                        color: root.currentUserAvatarColor.indexOf("/") !== -1 ? "transparent" : root.currentUserAvatarColor
                        clip: true
                        
                        CircleImage {
                            anchors.fill: parent; anchors.margins: 4
                            source: (root.currentUserAvatarColor.indexOf("/") !== -1) ? root.currentUserAvatarColor : "https://api.dicebear.com/7.x/avataaars/svg?seed=" + profileViewModel.username
                            fillMode: Image.PreserveAspectCrop
                        }
                        
                        Rectangle {
                            anchors.fill: parent; radius: 50; border.color: Theme.divider; border.width: 1; color: "transparent"
                        }
                        
                        // Overlay Hint
                        Rectangle {
                            anchors.fill: parent; radius: 50; color: Qt.rgba(0,0,0,0.3)
                            Text { anchors.centerIn: parent; text: qsTr("Edit"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 12 }
                        }
                        
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: avatarPicker.open()
                        }
                    }
                }

                // Input Fields with Obsidian Style
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Theme.space20
                    
                    ColumnLayout {
                        spacing: 8
                        Text { text: Loc.getString("name"); color: Theme.textSecondary; font.pixelSize: 13; font.weight: Theme.weightMedium }
                        TextField {
                            id: nameIn
                            Layout.fillWidth: true; height: 48
                            text: root.currentUserName
                            color: Theme.textPrimary; font.pixelSize: 15; verticalAlignment: Text.AlignVCenter
                            padding: 12
                            background: Rectangle { 
                                color: Theme.surface
                                border.color: Theme.divider; border.width: 1; radius: 10 
                            }
                        }
                    }
                    
                    ColumnLayout {
                        spacing: 8
                        Text { text: Loc.getString("username"); color: Theme.textSecondary; font.pixelSize: 13; font.weight: Theme.weightMedium }
                        TextField {
                            id: handleIn
                            Layout.fillWidth: true; height: 48
                            text: root.currentUserHandle
                            color: Theme.textPrimary; font.pixelSize: 15; verticalAlignment: Text.AlignVCenter
                            padding: 12
                            background: Rectangle { 
                                color: Theme.isDarkMode ? "#0A0A0A" : "#F8F8F8"
                                border.color: Theme.divider; border.width: 1; radius: 10 
                            }
                        }
                    }
                    
                    ColumnLayout {
                        spacing: 8
                        Text { text: Loc.getString("bio"); color: Theme.textSecondary; font.pixelSize: 13; font.weight: Theme.weightMedium }
                        TextArea {
                            id: bioIn
                            Layout.fillWidth: true; Layout.minimumHeight: 100
                            text: root.currentUserBio
                            color: Theme.textPrimary; font.pixelSize: 15; wrapMode: Text.WordWrap
                            padding: 12
                            background: Rectangle { 
                                color: Theme.isDarkMode ? "#0A0A0A" : "#F8F8F8"
                                border.color: Theme.divider; border.width: 1; radius: 10 
                            }
                        }
                    }
                }
                
                Item { Layout.preferredHeight: Theme.space32 }
            }
        }
    }
}
