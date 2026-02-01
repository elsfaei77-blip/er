import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: Theme.background
    
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
                    text: "Challenges"
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
        
        // Featured challenge banner
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.purple }
                GradientStop { position: 1.0; color: Theme.blue }
            }
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 12
                
                Text {
                    text: "🔥 Featured Challenge"
                    color: "white"
                    font.pixelSize: 14
                    font.weight: Font.Bold
                }
                
                Text {
                    text: "#MIRAChallenge"
                    color: "white"
                    font.pixelSize: 32
                    font.weight: Font.Bold
                }
                
                Text {
                    text: "Show us your best MIRA moments!"
                    color: Qt.rgba(255, 255, 255, 0.9)
                    font.pixelSize: 15
                }
                
                RowLayout {
                    spacing: 16
                    
                    Text {
                        text: "👥 2.5M participants"
                        color: "white"
                        font.pixelSize: 13
                    }
                    
                    Text {
                        text: "📹 5.8M videos"
                        color: "white"
                        font.pixelSize: 13
                    }
                }
                
                Rectangle {
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 44
                    radius: 22
                    color: "white"
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Join Challenge"
                        color: Theme.purple
                        font.pixelSize: 15
                        font.weight: Font.Bold
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
        
        // Challenges list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            spacing: 12
            
            model: ListModel {
                ListElement { 
                    hashtag: "#DanceChallenge"
                    participants: "1.2M"
                    videos: "3.5M"
                    trending: true
                }
                ListElement { 
                    hashtag: "#CookingChallenge"
                    participants: "850K"
                    videos: "2.1M"
                    trending: false
                }
                ListElement { 
                    hashtag: "#FitnessChallenge"
                    participants: "920K"
                    videos: "2.8M"
                    trending: true
                }
            }
            
            delegate: Rectangle {
                width: ListView.view.width - 32
                height: 120
                x: 16
                radius: 16
                color: Theme.surface
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    
                    // Preview grid
                    GridLayout {
                        Layout.preferredWidth: 88
                        Layout.preferredHeight: 88
                        columns: 2
                        rows: 2
                        columnSpacing: 2
                        rowSpacing: 2
                        
                        Repeater {
                            model: 4
                            Rectangle {
                                Layout.preferredWidth: 43
                                Layout.preferredHeight: 43
                                radius: 6
                                color: [Theme.blue, Theme.purple, Theme.aiAccent, Theme.likeRed][index]
                            }
                        }
                    }
                    
                    // Info
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        
                        RowLayout {
                            spacing: 8
                            
                            Text {
                                text: model.hashtag
                                color: Theme.textPrimary
                                font.pixelSize: 18
                                font.weight: Font.Bold
                            }
                            
                            Rectangle {
                                Layout.preferredWidth: trendingText.implicitWidth + 12
                                Layout.preferredHeight: 20
                                radius: 10
                                color: Theme.likeRed
                                visible: model.trending
                                
                                Text {
                                    id: trendingText
                                    anchors.centerIn: parent
                                    text: "🔥 Trending"
                                    color: "white"
                                    font.pixelSize: 10
                                    font.weight: Font.Bold
                                }
                            }
                        }
                        
                        Text {
                            text: model.participants + " participants • " + model.videos + " videos"
                            color: Theme.textSecondary
                            font.pixelSize: 13
                        }
                        
                        Rectangle {
                            Layout.preferredWidth: 100
                            Layout.preferredHeight: 32
                            radius: 16
                            color: Theme.blue
                            
                            Text {
                                anchors.centerIn: parent
                                text: "Join Now"
                                color: "white"
                                font.pixelSize: 13
                                font.weight: Font.Bold
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                            }
                        }
                    }
                }
            }
        }
    }
}
