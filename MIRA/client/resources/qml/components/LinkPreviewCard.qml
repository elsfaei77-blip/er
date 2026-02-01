import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Rectangle {
    id: root
    width: parent.width
    implicitHeight: contentColumn.implicitHeight + 24
    color: Theme.surface
    radius: 12
    border.color: Theme.divider
    border.width: 1
    
    property string url: ""
    property string title: ""
    property string description: ""
    property string imageUrl: ""
    property string domain: ""
    
    signal clicked()
    
    RowLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12
        
        // Preview image
        Rectangle {
            Layout.preferredWidth: 80
            Layout.preferredHeight: 80
            radius: 8
            color: Theme.background
            clip: true
            visible: root.imageUrl !== ""
            
            Image {
                anchors.fill: parent
                source: root.imageUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }
        }
        
        // Text content
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4
            
            // Domain badge
            Rectangle {
                Layout.preferredWidth: domainText.implicitWidth + 12
                Layout.preferredHeight: 20
                radius: 10
                color: Theme.hoverOverlay
                visible: root.domain !== ""
                
                Text {
                    id: domainText
                    anchors.centerIn: parent
                    text: root.domain
                    color: Theme.textSecondary
                    font.pixelSize: 10
                    font.weight: Font.Medium
                }
            }
            
            // Title
            Text {
                Layout.fillWidth: true
                text: root.title
                color: Theme.textPrimary
                font.pixelSize: 14
                font.weight: Font.Bold
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                visible: text !== ""
            }
            
            // Description
            Text {
                Layout.fillWidth: true
                text: root.description
                color: Theme.textSecondary
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                visible: text !== ""
            }
        }
        
        // External link icon
        MiraIcon {
            name: "link"
            size: 16
            color: Theme.textTertiary
            Layout.alignment: Qt.AlignTop
        }
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
