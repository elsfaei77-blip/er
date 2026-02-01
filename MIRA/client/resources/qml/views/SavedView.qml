import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"
    
    // Glass Background
    Rectangle {
        anchors.fill: parent
        color: Theme.background
        opacity: 0.8
    }
    
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
                    text: qsTr("Saved Collections")
                    color: Theme.textPrimary
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                }
                
                MiraIcon {
                    name: "create_plus"
                    size: 24
                    color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        onClicked: collectionDialog.open()
                    }
                }
            }
        }
        
        // Collections Tabs
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            contentWidth: collectionsRow.implicitWidth
            clip: true
            
            RowLayout {
                id: collectionsRow
                height: parent.height
                spacing: 12
                Layout.leftMargin: 16
                
                Repeater {
                    model: [qsTr("All Posts"), qsTr("Design Inspo"), qsTr("Code Snippets"), qsTr("Articles")]
                    
                    Rectangle {
                        Layout.preferredHeight: 36
                        Layout.preferredWidth: collectionText.implicitWidth + 32
                        radius: 18
                        color: index === 0 ? Theme.accent : Theme.surfaceElevated
                        border.color: index === 0 ? Theme.accent : Theme.divider
                        border.width: 1
                        
                        Text {
                            id: collectionText
                            anchors.centerIn: parent
                            text: modelData
                            color: index === 0 ? Theme.background : Theme.textPrimary
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
        
        // Masonry Grid (Simulated with Staggered GridView)
        GridView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: width / 2
            cellHeight: 220 // Constant height for now, true masonry needs C++ model or flow
            clip: true
            leftMargin: 10
            rightMargin: 10
            topMargin: 10
            
            model: ListModel {
                ListElement { type: "image"; content: "Cosmic Vibes"; heightFactor: 1.0; color: "#2A3042" }
                ListElement { type: "text"; content: "Quote of the day: Everything is stardust."; heightFactor: 0.8; color: "#1F2433"; }
                ListElement { type: "image"; content: "UI Inspiration"; heightFactor: 1.2; color: "#2A3042" }
                ListElement { type: "link"; content: "https://sadeem.space"; heightFactor: 0.9; color: "#1F2433" }
                ListElement { type: "image"; content: "Architecture"; heightFactor: 1.1; color: "#2A3042" }
                ListElement { type: "text"; content: "Remember to buy milk"; heightFactor: 0.6; color: "#1F2433" }
            }
            
            delegate: Rectangle {
                width: GridView.view.cellWidth - 12
                height: GridView.view.cellHeight - 12
                color: Theme.glassBackground
                radius: 16
                border.color: Theme.glassBorder
                border.width: 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 0
                    spacing: 0
                    
                    // Image Placeholder
                    Rectangle {
                        visible: model.type === "image"
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: Theme.surfaceElevated
                        radius: 16
                        
                        // Round bottom corners less
                        Rectangle { anchors.bottom: parent.bottom; height: 16; width: parent.width; color: Theme.surfaceElevated; visible: false } 
                        
                        MiraIcon {
                            anchors.centerIn: parent
                            name: "image"
                            size: 32
                            color: Theme.textSecondary
                        }
                    }
                    
                    // Text Content
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: model.type === "image" ? 50 : parent.height
                        Layout.margins: 12
                        
                        Text {
                            anchors.centerIn: parent
                            text: model.content
                            color: Theme.textPrimary
                            font.pixelSize: 14
                            elide: Text.ElideRight
                            width: parent.width
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                        }
                    }
                }
                
                // Bookmark Icon Overlay
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 10
                    width: 24; height: 24
                    radius: 12
                    color: Qt.rgba(0,0,0,0.5)
                    MiraIcon { anchors.centerIn: parent; name: "bookmark"; size: 12; color: "white"; active: true }
                }
            }
        }
    }
    
    // Collection creation dialog
    Dialog {
        id: collectionDialog
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.9, 400)
        modal: true
        
        background: Rectangle {
            color: Theme.surface
            radius: 20
            border.color: Theme.glassBorder
            border.width: 1
        }
        
        title: qsTr("New Collection")
        header: Text {
            text: qsTr("New Collection")
            color: Theme.textPrimary
            font.pixelSize: 18
            font.weight: Font.Bold
            padding: 20
            horizontalAlignment: Text.AlignHCenter
        }
        
        ColumnLayout {
            anchors.fill: parent
            spacing: 16
            
            TextField {
                Layout.fillWidth: true
                placeholderText: qsTr("Collection name")
                font.pixelSize: 15
                color: Theme.textPrimary
                background: Rectangle { color: Theme.background; radius: 8; border.width: 0 }
            }
            
            TextArea {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                placeholderText: qsTr("Description (optional)")
                font.pixelSize: 14
                color: Theme.textPrimary
                background: Rectangle { color: Theme.background; radius: 8; border.width: 0 }
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Cancel")
                    background: Rectangle { color: "transparent"; border.color: Theme.divider; border.width: 1; radius: 20 }
                    contentItem: Text { text: parent.text; color: Theme.textPrimary; horizontalAlignment: Text.AlignHCenter }
                    onClicked: collectionDialog.close()
                }
                
                Button {
                    Layout.fillWidth: true
                    text: qsTr("Create")
                    background: Rectangle { color: Theme.accent; radius: 20 }
                    contentItem: Text { text: parent.text; color: Theme.background; horizontalAlignment: Text.AlignHCenter; font.weight: Font.Bold }
                    onClicked: {
                        collectionDialog.close()
                    }
                }
            }
        }
    }
}
