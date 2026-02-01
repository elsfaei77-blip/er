import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: Theme.background
    
    property string selectedSound: ""
    
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
                    text: "Sounds"
                    color: Theme.textPrimary
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                }
                
                MiraIcon {
                    name: "search"
                    size: 22
                    color: Theme.textPrimary
                }
            }
        }
        
        // Search bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.margins: 16
            radius: 30
            color: Theme.surface
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                
                MiraIcon {
                    name: "search"
                    size: 20
                    color: Theme.textSecondary
                }
                
                TextField {
                    Layout.fillWidth: true
                    placeholderText: "Search sounds..."
                    background: Item {}
                    font.pixelSize: 15
                    color: Theme.textPrimary
                }
            }
        }
        
        // Categories
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            contentWidth: categoriesRow.implicitWidth
            clip: true
            
            RowLayout {
                id: categoriesRow
                height: parent.height
                spacing: 12
                
                Repeater {
                    model: ["Trending", "Popular", "New", "Favorites", "Saved"]
                    
                    Rectangle {
                        Layout.preferredHeight: 36
                        Layout.preferredWidth: categoryText.implicitWidth + 24
                        radius: 18
                        color: index === 0 ? Theme.accent : "transparent"
                        border.color: Theme.divider
                        border.width: index === 0 ? 0 : 1
                        
                        Text {
                            id: categoryText
                            anchors.centerIn: parent
                            text: modelData
                            color: index === 0 ? Theme.background : Theme.textPrimary
                            font.pixelSize: 14
                            font.weight: Font.Medium
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }
            }
        }
        
        // Sounds list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 0
            
            model: ListModel {
                ListElement { 
                    title: "Summer Vibes"
                    artist: "DJ Cool"
                    duration: "0:30"
                    uses: "2.5M"
                    trending: true
                }
                ListElement { 
                    title: "Epic Beat"
                    artist: "Producer X"
                    duration: "0:45"
                    uses: "1.8M"
                    trending: false
                }
                ListElement { 
                    title: "Chill Lofi"
                    artist: "Lofi Master"
                    duration: "1:00"
                    uses: "3.2M"
                    trending: true
                }
            }
            
            delegate: Rectangle {
                width: ListView.view.width
                height: 80
                color: "transparent"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12
                    
                    // Album art / waveform
                    Rectangle {
                        Layout.preferredWidth: 48
                        Layout.preferredHeight: 48
                        radius: 8
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Theme.accent }
                            GradientStop { position: 1.0; color: Theme.likeRed }
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: "🎵"
                            font.pixelSize: 24
                        }
                    }
                    
                    // Info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4
                        
                        RowLayout {
                            spacing: 8
                            
                            Text {
                                text: model.title
                                color: Theme.textPrimary
                                font.pixelSize: 15
                                font.weight: Font.Bold
                            }
                            
                            Rectangle {
                                Layout.preferredWidth: 60
                                Layout.preferredHeight: 18
                                radius: 9
                                color: Theme.likeRed
                                visible: model.trending
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "🔥 Hot"
                                    color: Theme.textPrimary
                                    font.pixelSize: 9
                                    font.weight: Font.Bold
                                }
                            }
                        }
                        
                        Text {
                            text: model.artist + " • " + model.duration
                            color: Theme.textSecondary
                            font.pixelSize: 13
                        }
                        
                        Text {
                            text: model.uses + " videos"
                            color: Theme.textTertiary
                            font.pixelSize: 11
                        }
                    }
                    
                    // Play button
                    Rectangle {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        radius: 20
                        color: Theme.accent
                        
                        Text {
                            anchors.centerIn: parent
                            text: "▶"
                            color: Theme.background
                            font.pixelSize: 16
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                    
                    // Use button
                    Rectangle {
                        Layout.preferredWidth: 70
                        Layout.preferredHeight: 32
                        radius: 16
                        color: "transparent"
                        border.color: Theme.accent
                        border.width: 1
                        
                        Text {
                            anchors.centerIn: parent
                            text: "Use"
                            color: Theme.accent
                            font.pixelSize: 13
                            font.weight: Font.Bold
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.selectedSound = model.title
                                mainStack.pop()
                            }
                        }
                    }
                }
                
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: 76
                    anchors.right: parent.right
                    height: 1
                    color: Theme.divider
                }
            }
        }
    }
}
