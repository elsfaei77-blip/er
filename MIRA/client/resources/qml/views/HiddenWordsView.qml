import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    color: Theme.background
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space8
                Item {
                    width: 48; height: 48
                    MiraIcon { anchors.centerIn: parent; name: "back"; size: 22; color: Theme.textPrimary; active: true }
                    MouseArea { anchors.fill: parent; onClicked: mainStack.pop() }
                }
                Text { text: Loc.getString("hiddenWords"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 18; font.family: Theme.fontFamily }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }
        
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: contentLayout.implicitHeight + Theme.space32
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            
            ColumnLayout {
                id: contentLayout
                width: parent.width
                spacing: 0
                
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.space20; Layout.rightMargin: Theme.space20
                    Layout.topMargin: Theme.space16; Layout.bottomMargin: Theme.space16
                    spacing: Theme.space8
                    
                    Text {
                        text: Loc.getString("offensiveHeader")
                        color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 16; font.family: Theme.fontFamily
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        text: Loc.getString("offensiveDesc")
                        color: Theme.textSecondary; font.pixelSize: 13; wrapMode: Text.WordWrap; font.family: Theme.fontFamily; lineHeight: 1.3
                    }
                }
                
                SettingItem { label: Loc.getString("hideOffensiveComments"); hasSwitch: true; switchActive: true; icon: "🚫" }
                SettingItem { label: Loc.getString("advancedFiltering"); hasSwitch: true; switchActive: false; icon: "🛡️" }
                
                Item { Layout.preferredHeight: Theme.space24 }
                
                Text {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.space20; Layout.rightMargin: Theme.space20
                    Layout.bottomMargin: Theme.space8
                    text: Loc.getString("customWordsHeader")
                    color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 16; font.family: Theme.fontFamily
                }
                
                SettingItem { label: Loc.getString("manageCustom"); icon: "✏️" }
                SettingItem { label: Loc.getString("hideReplies"); hasSwitch: true; switchActive: true; icon: "🤐" }
            }
        }
    }
}
