import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    color: "transparent" // Let Nebula background show through
    
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
                
                Text { text: Loc.getString("settings"); color: Theme.textPrimary; font.pixelSize: 18; font.weight: Theme.weightBold; font.family: Theme.fontFamily }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }
        
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: settingsCol.implicitHeight + Theme.space32
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            
            ColumnLayout {
                id: settingsCol
                width: parent.width
                spacing: 0
                
                // Theme Toggle
                SettingItem { 
                    icon: "🌗"
                    label: Loc.getString("darkMode")
                    hasSwitch: true
                    switchActive: Theme.isDarkMode
                    onClicked: Theme.toggleTheme()
                }

                SettingItem { 
                    icon: "💎"
                    label: qsTr("Platinum Badge")
                    hasSwitch: true
                    switchActive: Theme.isPlatinumUser
                    onClicked: Theme.isPlatinumUser = !Theme.isPlatinumUser
                }

                SettingItem { 
                    icon: "✨"
                    label: qsTr("Luxury Interactions")
                    hasSwitch: true
                    switchActive: Theme.isLuxuryEnabled
                    onClicked: Theme.isLuxuryEnabled = !Theme.isLuxuryEnabled
                }
                
                Item { Layout.preferredHeight: Theme.space16 }
                
                SettingItem { icon: "👤"; label: Loc.getString("followInvite"); onClicked: mainStack.push(followInviteView) }
                SettingItem { icon: "🔔"; label: Loc.getString("notifications"); onClicked: mainStack.push(notificationView) }
                SettingItem { icon: "🔒"; label: Loc.getString("privacy"); onClicked: mainStack.push(privacyView) }
                SettingItem { icon: "🌐"; label: Loc.getString("language"); onClicked: mainStack.push(languageView) }
                SettingItem { icon: "👤"; label: Loc.getString("account"); onClicked: mainStack.push(accountSettingsView) }
                SettingItem { icon: "❓"; label: Loc.getString("help"); onClicked: mainStack.push(helpView) }
                SettingItem { icon: "ℹ️"; label: Loc.getString("about"); onClicked: mainStack.push(aboutView) }
                
                Item { Layout.preferredHeight: Theme.space16 }
                Text { 
                    Layout.leftMargin: Theme.space20
                    Layout.bottomMargin: 8
                    text: qsTr("Advanced Features")
                    color: Theme.accent
                    font.pixelSize: 13
                    font.weight: Theme.weightBold; font.letterSpacing: 0.5
                }
                Rectangle { Layout.fillWidth: true; height: 1; color: Theme.divider; opacity: 0.5 }
                
                SettingItem { icon: "💾"; label: qsTr("Saved Collections"); onClicked: mainStack.push(savedViewComp) }
                SettingItem { icon: "🔍"; label: qsTr("Explore & Trending"); onClicked: mainStack.push(exploreViewComp) }
                SettingItem { icon: "🎬"; label: qsTr("Reels"); onClicked: mainStack.push(reelsViewComp) }
                SettingItem { icon: "📊"; label: qsTr("Analytics"); onClicked: mainStack.push(analyticsDashboardComp) }
                SettingItem { icon: "⭐"; label: qsTr("Close Friends"); onClicked: mainStack.push(closeFriendsViewComp) }
                SettingItem { icon: "🔥"; label: qsTr("Hashtag Challenges"); onClicked: mainStack.push(hashtagChallengesViewComp) }
                SettingItem { icon: "🎵"; label: qsTr("Sound Library"); onClicked: mainStack.push(soundLibraryViewComp) }
                SettingItem { icon: "🔐"; label: qsTr("Two-Factor Auth"); onClicked: mainStack.push(twoFactorAuthViewComp) }
                SettingItem { icon: "🛡️"; label: qsTr("Account Privacy"); onClicked: mainStack.push(accountPrivacyViewComp) }
                
                Item { Layout.preferredHeight: Theme.space24 }
                
                // Logout Button (Luxury Style)
                Rectangle {
                    width: parent.width - Theme.space40; height: 52; radius: 26
                    Layout.topMargin: Theme.space20
                    Layout.alignment: Qt.AlignHCenter
                    color: Theme.surface
                    border.color: Theme.likeRed; border.width: 1
                    
                    Text {
                        anchors.centerIn: parent
                        text: Loc.getString("logout")
                        color: Theme.likeRed
                        font.pixelSize: 16; font.weight: Theme.weightBold; font.family: Theme.fontFamily
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onPressed: parent.scale = 0.95
                        onReleased: parent.scale = 1.0
                        onClicked: authService.logout()
                    }
                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Theme.springEasing } }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: Theme.space32
                    spacing: 4
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "from SADEEM"
                        color: Theme.textTertiary; font.pixelSize: 13; font.weight: Theme.weightMedium; font.letterSpacing: 2
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "SADEEM v1.0.0"
                        color: Theme.textTertiary; font.pixelSize: 11; opacity: 0.6
                    }
                }
            }
        }
    }
    
    Component { id: followInviteView; FollowAndInviteView {} }
    Component { id: notificationView; NotificationSettingsView {} }
    Component { id: privacyView; PrivacySettingsView {} }
    Component { id: languageView; LanguageSettingsView {} }
    Component { id: accountSettingsView; AccountSettingsView {} }
    Component { id: helpView; HelpSettingsView {} }
    Component { id: aboutView; AboutSettingsView {} }
    
    // Advanced Features
    Component { id: savedViewComp; SavedView {} }
    Component { id: exploreViewComp; ExploreView {} }
    Component { id: analyticsDashboardComp; AnalyticsDashboard {} }
    Component { id: closeFriendsViewComp; CloseFriendsView {} }
    Component { id: hashtagChallengesViewComp; HashtagChallengesView {} }
    Component { id: soundLibraryViewComp; SoundLibraryView {} }
    Component { id: twoFactorAuthViewComp; TwoFactorAuthView {} }
    Component { id: accountPrivacyViewComp; AccountPrivacyView {} }
}
