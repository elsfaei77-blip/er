import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Popup {
    id: root
    
    signal stickerSelected(string source)
    
    width: parent ? parent.width : 400
    height: parent ? parent.height * 0.7 : 500
    anchors.centerIn: parent
    
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    
    background: Rectangle {
        color: Theme.surface
        radius: 20
        border.color: Theme.glassBorder
        border.width: 1
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        
        // Search
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            radius: 20
            color: Theme.surfaceElevated
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8
                MiraIcon { name: "search"; size: 16; color: Theme.textSecondary }
                TextInput {
                    Layout.fillWidth: true
                    text: ""
                    color: Theme.textPrimary
                    font.pixelSize: 14
                    // Placeholder logic omitted for brevity
                }
            }
        }
        
        // Sticker Grid
        GridView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            cellWidth: width / 3
            cellHeight: width / 3
            
            model: [
                "🔥", "❤️", "😂", "😍", "🎉", 
                "👍", "👎", "👀", "✨", "💯",
                "🍕", "🍔", "🍺", "☕", "🚀",
                "🌍", "🌙", "⭐", "🎵", "🎸",
                "🐶", "🐱", "🐰", "🦊", "🦁"
            ]
            
            delegate: Item {
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight
                
                Text {
                    anchors.centerIn: parent
                    text: modelData
                    font.pixelSize: 48
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            root.stickerSelected(modelData)
                            root.close()
                        }
                    }
                }
            }
        }
    }
}
