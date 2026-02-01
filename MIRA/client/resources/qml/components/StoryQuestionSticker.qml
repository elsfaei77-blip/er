import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Rectangle {
    id: root
    width: parent.width
    implicitHeight: contentColumn.implicitHeight + 32
    radius: 16
    color: Qt.rgba(0, 0, 0, 0.3)
    border.color: Qt.rgba(255, 255, 255, 0.2)
    border.width: 1
    
    property string question: "Ask me anything!"
    property var responses: []
    
    ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12
        
        RowLayout {
            spacing: 8
            
            Text {
                text: "❓"
                font.pixelSize: 20
            }
            
            Text {
                Layout.fillWidth: true
                text: root.question
                color: "white"
                font.pixelSize: 15
                font.weight: Font.Bold
                wrapMode: Text.WordWrap
            }
        }
        
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            radius: 22
            color: Qt.rgba(255, 255, 255, 0.15)
            
            TextField {
                anchors.fill: parent
                anchors.margins: 12
                placeholderText: qsTr("Type your answer...")
                placeholderTextColor: Qt.rgba(255, 255, 255, 0.5)
                color: "white"
                background: Item {}
                font.pixelSize: 14
            }
        }
        
        Text {
            text: root.responses.length + qsTr(" responses")
            color: Qt.rgba(255, 255, 255, 0.7)
            font.pixelSize: 12
            visible: root.responses.length > 0
        }
    }
}
