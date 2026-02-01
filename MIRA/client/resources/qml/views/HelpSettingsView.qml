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
                Text { text: Loc.getString("help"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 18; font.family: Theme.fontFamily }
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
                
                SettingItem { label: Loc.getString("helpCenter"); icon: "ℹ️" }
                SettingItem { label: Loc.getString("reportProblem"); icon: "⚠️" }
                SettingItem { label: Loc.getString("supportRequests"); icon: "📩" }
                SettingItem { label: Loc.getString("privacySecurityHelp"); icon: "🔒" }
            }
        }
    }
}
