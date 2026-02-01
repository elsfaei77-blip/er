import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: Theme.background
    
    property bool isPrivateAccount: false
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            color: Theme.surface
            
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
                    text: qsTr("Account Privacy")
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
            contentHeight: contentColumn.implicitHeight
            clip: true
            
            ColumnLayout {
                id: contentColumn
                width: parent.width
                spacing: 24
                
                // Private account toggle
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    Layout.margins: 16
                    radius: 16
                    color: Theme.surface
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Rectangle {
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 48
                            radius: 24
                            color: root.isPrivateAccount ? Theme.purple : Theme.hoverOverlay
                            
                            Text {
                                anchors.centerIn: parent
                                text: root.isPrivateAccount ? "🔒" : "🌐"
                                font.pixelSize: 24
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4
                            
                            Text {
                                text: qsTr("Private Account")
                                color: Theme.textPrimary
                                font.pixelSize: 16
                                font.weight: Font.Bold
                            }
                            
                            Text {
                                text: root.isPrivateAccount ? 
                                      qsTr("Only approved followers can see your posts") :
                                      qsTr("Anyone can see your posts")
                                color: Theme.textSecondary
                                font.pixelSize: 13
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                        
                        Switch {
                            checked: root.isPrivateAccount
                            onToggled: root.isPrivateAccount = checked
                        }
                    }
                }
                
                // Privacy controls
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.margins: 16
                    spacing: 12
                    
                    Text {
                        text: qsTr("Who Can...")
                        color: Theme.textPrimary
                        font.pixelSize: 16
                        font.weight: Font.Bold
                    }
                    
                    Repeater {
                        model: [
                            { title: qsTr("Comment on your posts"), options: [qsTr("Everyone"), qsTr("People you follow"), qsTr("Off")] },
                            { title: qsTr("Mention you"), options: [qsTr("Everyone"), qsTr("People you follow"), qsTr("No one")] },
                            { title: qsTr("Message you"), options: [qsTr("Everyone"), qsTr("People you follow"), qsTr("No one")] },
                            { title: qsTr("See your stories"), options: [qsTr("Everyone"), qsTr("Close friends"), qsTr("Custom")] }
                        ]
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 70
                            radius: 12
                            color: Theme.surface
                            
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 12
                                
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4
                                    
                                    Text {
                                        text: modelData.title
                                        color: Theme.textPrimary
                                        font.pixelSize: 15
                                        font.weight: Font.Bold
                                    }
                                    
                                    Text {
                                        text: modelData.options[0]
                                        color: Theme.textSecondary
                                        font.pixelSize: 13
                                    }
                                }
                                
                                Text {
                                    text: "›"
                                    color: Theme.textTertiary
                                    font.pixelSize: 20
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
                
                // Blocked accounts
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 70
                    Layout.margins: 16
                    radius: 12
                    color: Theme.surface
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12
                        
                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            radius: 20
                            color: Theme.likeRed
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🚫"
                                font.pixelSize: 20
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            
                            Text {
                                text: qsTr("Blocked Accounts")
                                color: Theme.textPrimary
                                font.pixelSize: 15
                                font.weight: Font.Bold
                            }
                            
                            Text {
                                text: qsTr("Manage blocked users")
                                color: Theme.textSecondary
                                font.pixelSize: 13
                            }
                        }
                        
                        Text {
                            text: "›"
                            color: Theme.textTertiary
                            font.pixelSize: 20
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mainStack.push(blockedProfilesView)
                    }
                }
            }
        }
    }
}
