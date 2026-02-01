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
                Text { text: Loc.getString("notifications"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 18; font.family: Theme.fontFamily }
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
                
                SettingItem { label: Loc.getString("pauseAll"); hasSwitch: true; switchActive: false; icon: "🔕" }
                
                Item { Layout.preferredHeight: Theme.space16 }
                
                SettingItem { label: Loc.getString("threadsReplies"); icon: "💬"; onClicked: mainStack.push(detailView, {title: Loc.getString("threadsReplies"), settingsModel: [{"sectionTitle": qsTr("Likes"), "label": qsTr("From everyone")}, {"label": qsTr("From people you follow")}, {"sectionTitle": qsTr("Replies"), "label": qsTr("From everyone")}, {"label": qsTr("From people you follow")}]}) }
                SettingItem { label: Loc.getString("followFollowers"); icon: "👥"; onClicked: mainStack.push(detailView, {title: Loc.getString("followFollowers"), settingsModel: [{"label": qsTr("New followers"), "hasSwitch": true}, {"label": qsTr("Accepted follow requests"), "hasSwitch": true}]}) }
                SettingItem { label: Loc.getString("directMessages"); icon: "✉️"; onClicked: mainStack.push(detailView, {title: Loc.getString("directMessages"), settingsModel: [{"label": qsTr("Message requests"), "hasSwitch": true}, {"label": qsTr("Messages"), "hasSwitch": true}]}) }
                SettingItem { label: Loc.getString("instagram"); icon: "📸" }
                SettingItem { label: Loc.getString("fromThreads"); icon: "🧵" }
                
                Item { Layout.preferredHeight: Theme.space24 }
                
                Text {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.space20; Layout.rightMargin: Theme.space20
                    Layout.bottomMargin: Theme.space8
                    text: Loc.getString("emailNotifications")
                    color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 16; font.family: Theme.fontFamily
                }
                
                SettingItem { label: Loc.getString("feedbackEmails"); icon: "📧" }
                SettingItem { label: Loc.getString("reminderEmails"); icon: "🔔" }
            }
        }
    }
}
