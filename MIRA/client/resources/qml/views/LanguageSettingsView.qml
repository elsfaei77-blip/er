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
                Text { text: Loc.getString("language"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 18; font.family: Theme.fontFamily }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }
        
        ListView {
            id: languageList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            model: ListModel {
                ListElement { name: "العربية"; nativeName: "Arabic"; code: "ar" }
                ListElement { name: "English"; nativeName: "English"; code: "en" }
                ListElement { name: "English (UK)"; nativeName: "English (UK)"; code: "en-gb" }
                ListElement { name: "Español"; nativeName: "Spanish"; code: "es" }
                ListElement { name: "Français"; nativeName: "French"; code: "fr" }
                ListElement { name: "Deutsch"; nativeName: "German"; code: "de" }
                ListElement { name: "Italiano"; nativeName: "Italian"; code: "it" }
                ListElement { name: "Português"; nativeName: "Portuguese"; code: "pt" }
                ListElement { name: "Русский"; nativeName: "Russian"; code: "ru" }
                ListElement { name: "日本語"; nativeName: "Japanese"; code: "ja" }
                ListElement { name: "한국어"; nativeName: "Korean"; code: "ko" }
                ListElement { name: "中文 (简体)"; nativeName: "Chinese (Simplified)"; code: "zh-cn" }
                ListElement { name: "中文 (繁體)"; nativeName: "Chinese (Traditional)"; code: "zh-tw" }
                ListElement { name: "Türkçe"; nativeName: "Turkish"; code: "tr" }
                ListElement { name: "हिन्दी"; nativeName: "Hindi"; code: "hi" }
                ListElement { name: "Bahasa Indonesia"; nativeName: "Indonesian"; code: "id" }
                ListElement { name: "Tiếng Việt"; nativeName: "Vietnamese"; code: "vi" }
                ListElement { name: "Polski"; nativeName: "Polish"; code: "pl" }
                ListElement { name: "Nederlands"; nativeName: "Dutch"; code: "nl" }
            }
            
            delegate: Rectangle {
                width: languageList.width
                height: 60
                color: "transparent"
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20
                    spacing: Theme.space12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        Text { text: model.name; color: Theme.textPrimary; font.pixelSize: 16; font.weight: Theme.weightRegular; font.family: Theme.fontFamily }
                        Text { text: model.nativeName; color: Theme.textSecondary; font.pixelSize: 13; font.family: Theme.fontFamily }
                    }
                    
                    // Selector Dot
                    Rectangle {
                        width: 22; height: 22; radius: 11
                        color: "transparent"; border.color: Loc.currentLanguage === model.code ? Theme.accent : Theme.divider; border.width: 1.5
                        Rectangle {
                            anchors.centerIn: parent
                            width: 12; height: 12; radius: 6
                            color: Theme.accent
                            visible: Loc.currentLanguage === model.code
                        }
                    }
                }
                
                Rectangle {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.leftMargin: Theme.space20; anchors.right: parent.right; anchors.rightMargin: Theme.space20
                    height: 1; color: Theme.divider
                }
                
                MouseArea {
                    anchors.fill: parent
                    onPressed: parent.color = Theme.hoverOverlay
                    onReleased: parent.color = "transparent"
                    onCanceled: parent.color = "transparent"
                    onClicked: Loc.currentLanguage = model.code
                }
            }
        }
    }
}
