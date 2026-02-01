import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import MiraApp
import "components"
import "views"
import "assets" // For NebulaBackground
import "."

Window {
    id: mainWindow
    width: Theme.screenWidth
    height: Theme.screenHeight
    visible: true
    title: "SADEEM" // Renamed from MIRA
    
    // Background
    NebulaBackground { anchors.fill: parent; z: -100 }
    // color: Theme.background // Replaced by NebulaBackground

    property bool isLoggedIn: false
    property bool isFaceAuthPassed: false
    property bool isSplashFinished: false
    property var tabHistory: []
    property int lastTab: 0

    function goBack() {
        if (mainStack.depth > 1) {
            mainStack.pop()
            if (typeof HapticManager !== "undefined") HapticManager.triggerImpactLight()
            if (typeof nativeToast !== "undefined") nativeToast.show("Back", "info")
            return true
        } else if (tabHistory.length > 0) {
            var prevTab = tabHistory.pop()
            lastTab = prevTab
            bottomBar.currentIndex = prevTab
            if (typeof HapticManager !== "undefined") HapticManager.triggerImpactLight()
            return true
        }
        return false
    }



    ThreadModel {
        id: globalStoryModel
        Component.onCompleted: refreshStories()
    }

    // Story Refresh Timer
    Timer {
        interval: 30000 // Refresh stories every 30 seconds
        running: isLoggedIn
        repeat: true
        onTriggered: globalStoryModel.refreshStories()
    }

    function openProfile(uid) {
        if (!uid) return;
        mainStack.push(userProfileView, { "userData": { "id": uid } });
    }

    function openStory(uid) {
        if (!uid) return;
        var storyData = globalStoryModel.getStoriesForUser(uid);
        if (storyData && storyData.stories.length > 0) {
            mainStack.push(storyViewComp, {
                "stories": storyData.stories,
                "username": storyData.username,
                "userAvatar": storyData.avatar,
                "userId": uid
            });
        }
    }

    Component.onCompleted: {
        if (authService.tryAutoLogin()) {
             // Logic handled in onLoginSuccess
             console.log("Auto-login triggered")
        }
    }

    Connections {
        target: authService
        
        function onLoginSuccess() {
            console.log("QML: Login Success Received")
            isLoggedIn = true
            isFaceAuthPassed = true 
            if (typeof nativeToast !== "undefined") nativeToast.show("Welcome back!", "success")
        }
        function onLogoutSuccess() {
            isLoggedIn = false
            isFaceAuthPassed = false
            authStack.pop(null)
            mainStack.pop(null)
        }
    }

    // --- Main Container ---
    Item {
        anchors.fill: parent
        
        // 1. Auth Flow
        Item {
            id: authContainer
            anchors.fill: parent
            visible: !isLoggedIn
            
            StackView {
                id: authStack
                anchors.fill: parent
                initialItem: loginView
                
                Component {
                    id: loginView
                    LoginView {
                        onLoginClicked: (u, p) => authService.login(u, p)
                        onRegisterClicked: () => authStack.push(registerView)
                    }
                }
                
                Component {
                    id: registerView
                    RegisterView {
                        onRegisterClicked: (u, p) => authService.registerUser(u, p)
                        onBackClicked: () => authStack.pop()
                    }
                }
            }
        }
        
        // 2. Face Auth


        // 3. App Flow
        ColumnLayout {
            id: appContainer
            anchors.fill: parent
            visible: isLoggedIn && isFaceAuthPassed
            spacing: 0

            StackView {
                id: mainStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                initialItem: mainTabs

                pushEnter: Transition {
                    PropertyAnimation { property: "x"; from: mainStack.width; to: 0; duration: Theme.animLuxury; easing.type: Theme.luxuryEasing }
                    PropertyAnimation { property: "opacity"; from: 0; to: 1; duration: Theme.animLuxury }
                }
                pushExit: Transition {
                    PropertyAnimation { property: "x"; from: 0; to: -mainStack.width * 0.3; duration: Theme.animLuxury; easing.type: Theme.luxuryEasing }
                    PropertyAnimation { property: "opacity"; from: 1; to: 0.5; duration: Theme.animLuxury }
                }
                popEnter: Transition {
                    PropertyAnimation { property: "x"; from: -mainStack.width * 0.3; to: 0; duration: Theme.animLuxury; easing.type: Theme.luxuryEasing }
                    PropertyAnimation { property: "opacity"; from: 0.5; to: 1; duration: Theme.animLuxury }
                }
                popExit: Transition {
                    PropertyAnimation { property: "x"; from: 0; to: mainStack.width; duration: Theme.animLuxury; easing.type: Theme.luxuryEasing }
                    PropertyAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.animLuxury }
                }
                
                Component {
                    id: messagesView
                    MessagesView {}
                }
                
                Component {
                    id: postDetailView
                    PostDetailView {}
                }

                Component {
                    id: searchViewComp
                    SearchView {}
                }

                Component {
                    id: userProfileView
                    UserProfileView {}
                }

                Component {
                    id: chatView
                    ChatView {}
                }

                Component {
                    id: miraAIView
                    MiraAIView {}
                }

                StackLayout {
                    id: mainTabs
                    
                    // Tab 0: Home
                    HomeView { 
                        id: homeView
                        onMessagesClicked: mainStack.push(messagesView)
                    }
                    
                    // Tab 1: Explore (Replacing Search)
                    ExploreView {
                        id: exploreViewTab
                    }
                    
                    // Tab 2: Create Post
                    CreatePostView {
                        onClosed: bottomBar.currentIndex = 0
                    }
                    
                    // Tab 3: Activity
                    EnhancedNotificationsView {
                        id: activityViewTab
                    }
                    
                    // Tab 4: Profile
                    ProfileView {
                        id: profileViewTab
                        onSettingsRequested: () => mainStack.push(settingsViewComp)
                        onEditProfileRequested: (model) => mainStack.push(editProfileViewComp, { "profileViewModel": model })
                    }
                    
                    currentIndex: bottomBar.currentIndex
                }
            }

            // Navigation Bar
            BottomNav {
                id: bottomBar
                Layout.fillWidth: true
                onTabChanged: (index) => {
                    if (lastTab !== index) {
                        tabHistory.push(lastTab)
                        lastTab = index
                        if (tabHistory.length > 20) tabHistory.shift()
                    }
                    if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                }
            }
            
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "v2.0 Native Active"
                color: Theme.textTertiary; font.pixelSize: 8; opacity: 0.3
            }
        }
        
        // Lazy loaded views
        Component { id: settingsViewComp; SettingsView {} }
        Component { id: editProfileViewComp; EditProfileView {} }
        Component { id: storyViewComp; StoryView {
            onClosed: mainStack.pop()
            onProfileClicked: (uid) => {
                mainStack.pop();
                openProfile(uid);
            }
        } }
        
        // Phase 1 Features
        Component { id: savedView; SavedView {} }
        Component { id: exploreView; ExploreView {} }
        Component { id: groupChatView; GroupChatView {} }
        Component { id: liveStreamView; LiveStreamView {} }
        
        // Phase 2 Features
        Component { id: videoEditorView; VideoEditorView {} }
        Component { id: activityView; EnhancedNotificationsView {} }
        Component { id: analyticsDashboard; AnalyticsDashboard {} }
        Component { id: closeFriendsView; CloseFriendsView {} }
        
        // Phase 3 Features
        Component { id: hashtagChallengesView; HashtagChallengesView {} }
        Component { id: duetStitchView; DuetStitchView {} }
        Component { id: soundLibraryView; SoundLibraryView {} }
        Component { id: twoFactorAuthView; TwoFactorAuthView {} }
        Component { id: accountPrivacyView; AccountPrivacyView {} }
        
        NativeToast {
            id: nativeToast
            z: 9999999
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    // 4. Luxury Splash Screen
    LuxurySplashScreen {
        id: splashOverlay
        visible: !isSplashFinished
        onFinished: isSplashFinished = true
    }

    // Navigation Handler
    Item {
        id: globalNavHandler
        anchors.fill: parent
        focus: true
        Component.onCompleted: {
            forceActiveFocus()
        }
        
        Keys.onReleased: (event) => {
            if (event.key === Qt.Key_Back || event.key === Qt.Key_Escape) {
                if (goBack()) {
                    event.accepted = true
                }
            }
        }
        
        /* 
        MouseArea {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 60
            z: 99999
            enabled: mainStack.depth > 1 || tabHistory.length > 0
            
            property real startX: 0
            onPressed: (mouse) => startX = mouse.x
            onReleased: (mouse) => {
                if (mouse.x - startX > 80) {
                    goBack()
                }
            }
        } 
        */
    }
}
