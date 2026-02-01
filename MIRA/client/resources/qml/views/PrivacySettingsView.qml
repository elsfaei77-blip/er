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
                Text { text: Loc.getString("privacy"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 18; font.family: Theme.fontFamily }
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
                
                SettingItem { label: Loc.getString("privateProfile"); hasSwitch: true; switchActive: false; icon: "🔒" }
                SettingItem { label: Loc.getString("mentions"); icon: "@"; value: Loc.getString("everyone"); onClicked: mainStack.push(detailView, {title: Loc.getString("mentions"), settingsModel: [{"label": Loc.getString("everyone")}, {"label": Loc.getString("profilesFollow")}, {"label": qsTr("No one")}]}) }
                SettingItem { label: Loc.getString("muted"); icon: "🔇"; onClicked: mainStack.push(blockedProfilesView) }
                SettingItem { label: Loc.getString("hiddenWords"); icon: "👁️‍🗨️"; onClicked: mainStack.push(hiddenWordsView) }
                SettingItem { label: Loc.getString("profilesFollow"); icon: "👥"; onClicked: mainStack.push(followersView) }
                
                Item { Layout.preferredHeight: Theme.space24 }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.space20; Layout.rightMargin: Theme.space20
                    spacing: Theme.space8
                    
                    Text {
                        text: Loc.getString("otherPrivacy")
                        color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 16; font.family: Theme.fontFamily
                    }
                    
                    Text {
                        Layout.fillWidth: true
                        text: Loc.getString("privacyLongDesc")
                        color: Theme.textSecondary; font.pixelSize: 13; wrapMode: Text.WordWrap; font.family: Theme.fontFamily; lineHeight: 1.3
                    }
                }
                
                Item { Layout.preferredHeight: Theme.space16 }
                
                SettingItem { label: Loc.getString("blockedProfiles"); icon: "🚫"; onClicked: mainStack.push(blockedProfilesView) }
                SettingItem { label: Loc.getString("hideLikes"); icon: "❤️" }
            }
        }
    }
}
