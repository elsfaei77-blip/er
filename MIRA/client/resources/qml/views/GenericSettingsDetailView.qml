import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    color: Theme.background
    
    property string title: ""
    property var settingsModel: []

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
                Text { text: root.title; color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 18; font.family: Theme.fontFamily }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }
        
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: contentCol.implicitHeight + Theme.space32
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            
            ColumnLayout {
                id: contentCol
                width: parent.width
                spacing: 0
                
                Repeater {
                    model: root.settingsModel
                    delegate: ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        
                        Text {
                            visible: modelData.sectionTitle !== undefined
                            Layout.fillWidth: true
                            Layout.leftMargin: Theme.space20
                            Layout.rightMargin: Theme.space20
                            Layout.topMargin: Theme.space24
                            Layout.bottomMargin: Theme.space8
                            text: modelData.sectionTitle || ""
                            color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 16; font.family: Theme.fontFamily
                        }
                        
                        SettingItem {
                            label: modelData.label
                            icon: modelData.icon || ""
                            hasSwitch: modelData.hasSwitch || false
                            switchActive: modelData.switchActive || false
                            value: modelData.value || ""
                        }
                    }
                }
            }
        }
    }
}
