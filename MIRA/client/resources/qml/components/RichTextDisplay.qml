import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Item {
    id: root
    width: parent.width
    implicitHeight: contentColumn.implicitHeight
    
    property alias text: textDisplay.text
    property bool enableFormatting: true
    
    signal mentionClicked(string username)
    signal hashtagClicked(string tag)
    signal linkClicked(string url)
    
    ColumnLayout {
        id: contentColumn
        width: parent.width
        spacing: 0
        
        Text {
            id: textDisplay
            Layout.fillWidth: true
            color: Theme.textPrimary
            font.pixelSize: 15
            font.family: Theme.fontFamily
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            
            onLinkActivated: (link) => {
                if (link.startsWith("mention://")) {
                    root.mentionClicked(link.substring(10))
                } else if (link.startsWith("hashtag://")) {
                    root.hashtagClicked(link.substring(10))
                } else {
                    root.linkClicked(link)
                }
            }
            
            Component.onCompleted: {
                if (root.enableFormatting) {
                    formatText()
                }
            }
        }
    }
    
    function formatText() {
        let formatted = textDisplay.text
        
        // Convert @mentions to links
        formatted = formatted.replace(/@(\w+)/g, '<a href="mention://$1" style="color: ' + Theme.blue + '; text-decoration: none;">@$1</a>')
        
        // Convert #hashtags to links  
        formatted = formatted.replace(/#(\w+)/g, '<a href="hashtag://$1" style="color: ' + Theme.blue + '; text-decoration: none;">#$1</a>')
        
        // Convert URLs to links
        formatted = formatted.replace(/(https?:\/\/[^\s]+)/g, '<a href="$1" style="color: ' + Theme.blue + '; text-decoration: underline;">$1</a>')
        
        // Convert **bold** to <b>
        formatted = formatted.replace(/\*\*([^*]+)\*\*/g, '<b>$1</b>')
        
        // Convert *italic* to <i>
        formatted = formatted.replace(/\*([^*]+)\*/g, '<i>$1</i>')
        
        textDisplay.text = formatted
    }
    
    function setPlainText(plainText) {
        textDisplay.text = plainText
        if (root.enableFormatting) {
            formatText()
        }
    }
}
