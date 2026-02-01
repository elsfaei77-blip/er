import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import MiraApp
import "../components"

Rectangle {
    id: root
    color: "transparent" // Let Nebula background show through
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space20
                anchors.rightMargin: Theme.space20
                
                // Back Button
                Item {
                    Layout.preferredWidth: 48
                    Layout.fillHeight: true
                    MiraIcon {
                        anchors.centerIn: parent
                        name: "back"
                        size: 24
                        color: Theme.textPrimary
                        enabled: false
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mainStack.pop()
                    }
                }
                
                Text {
                    Layout.fillWidth: true
                    text: qsTr("Explore")
                    color: Theme.textPrimary
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    font.family: Theme.fontFamily
                    horizontalAlignment: Text.AlignHCenter
                }
                
                // Search Shortcut (Return to Search)
                Item {
                    Layout.preferredWidth: 48
                    Layout.fillHeight: true
                    MiraIcon {
                        anchors.centerIn: parent
                        name: "search"
                        size: 24
                        color: Theme.textPrimary
                        enabled: false
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("Opening search from Explore header");
                            mainStack.push(searchViewComp);
                        }
                    }
                }
            }
        }
        
        // Category tabs
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
                    model: [qsTr("For You"), qsTr("Trending"), qsTr("News"), qsTr("Sports"), qsTr("Entertainment"), qsTr("Technology")]
                    
                    Rectangle {
                        Layout.preferredHeight: 34
                        Layout.preferredWidth: categoryText.implicitWidth + 28
                        radius: 17
                        color: index === 0 ? Theme.accent : Theme.surface
                        border.color: index === 0 ? "transparent" : Theme.divider
                        border.width: 1
                        
                        Text {
                            id: categoryText
                            anchors.centerIn: parent
                            text: modelData
                            color: index === 0 ? Theme.background : Theme.textPrimary
                            font.pixelSize: 13; font.weight: Font.DemiBold; font.family: Theme.fontFamily
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: parent.scale = 0.95
                            onReleased: parent.scale = 1.0
                        }
                        Behavior on scale { NumberAnimation { duration: 200; easing.type: Theme.springEasing } }
                    }
                }
            }
        }
        
        // Trending topics
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: Theme.surface
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8
                
                Text {
                    text: qsTr("Trending Now")
                    color: Theme.textPrimary
                    font.pixelSize: 16
                    font.weight: Font.Bold
                    font.family: Theme.fontFamily
                }
                
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    contentWidth: trendingRow.implicitWidth
                    clip: true
                    
                    RowLayout {
                        id: trendingRow
                        spacing: 12
                        
                        Repeater {
                            model: ["#MIRA", "#AI", "#Luxury", "#Qt6", "#Social"]
                            
                            Rectangle {
                                Layout.preferredWidth: 124
                                Layout.preferredHeight: 64
                                radius: 14
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: Theme.aiGradientStart }
                                    GradientStop { position: 1.0; color: Theme.aiGradientEnd }
                                }
                                
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 2
                                    
                                    Text {
                                        text: modelData
                                        color: "white"
                                        font.pixelSize: 15; font.weight: Font.Bold; font.family: Theme.fontFamily
                                        Layout.alignment: Qt.AlignHCenter
                                    }
                                    
                                    Text {
                                        text: "Trending"
                                        color: Qt.rgba(1, 1, 1, 0.7)
                                        font.pixelSize: 10; font.family: Theme.fontFamily; Layout.alignment: Qt.AlignHCenter
                                    }
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onPressed: parent.scale = 0.95
                                    onReleased: parent.scale = 1.0
                                }
                                Behavior on scale { NumberAnimation { duration: 200; easing.type: Theme.springEasing } }
                            }
                        }
                    }
                }
            }
        }
        
        // Content grid
        GridView {
            id: exploreGrid
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: width / 3
            cellHeight: cellWidth
            clip: true
            
            model: 30
            
            delegate: Rectangle {
                id: gridItem
                width: exploreGrid.cellWidth - 2
                height: exploreGrid.cellHeight - 2
                color: Theme.surface
                border.color: Theme.divider; border.width: 1
                
                // Staggered Grid Entry
                opacity: 0; scale: 0.9
                transform: Translate { id: gridTranslate; y: 20 }
                SequentialAnimation {
                    id: gridEntryAnim
                    PauseAnimation { duration: (index % 12) * 50 }
                    ParallelAnimation {
                        NumberAnimation { target: gridItem; property: "opacity"; to: 1; duration: Theme.animNormal }
                        NumberAnimation { target: gridItem; property: "scale"; to: 1; duration: Theme.animNormal; easing.type: Theme.springEasing }
                        NumberAnimation { target: gridTranslate; property: "y"; to: 0; duration: Theme.animNormal; easing.type: Theme.springEasing }
                    }
                }
                Component.onCompleted: gridEntryAnim.start()

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "📷"; font.pixelSize: 24; Layout.alignment: Qt.AlignHCenter }
                    Text {
                        text: (Math.floor(Math.random() * 100) + 1) + "K"
                        color: Theme.textSecondary; font.pixelSize: 11; font.family: Theme.fontFamily; Layout.alignment: Qt.AlignHCenter
                    }
                }
                
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onPressed: gridItem.scale = 0.95
                    onReleased: gridItem.scale = 1.0
                }
            }
        }
    }
}
