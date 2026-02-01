import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qml/components"
import "qml/views"
import "qml/assets"
import "qml"

Window {
    id: mainWindow
    width: Constants.screenWidth
    height: Constants.screenHeight
    visible: true
    title: "Sadeem"
    // color: Constants.background // Removed in favor of NebulaBackground

    NebulaBackground {
        anchors.fill: parent
        z: -100 // Ensure it is behind everything
    }

    property bool isLoggedIn: false
    property bool isFaceAuthPassed: false // New Step

    Connections {
        target: NetworkManager
        
        function onFeedReceived(posts) {
            postsModel.clear()
            for (var i = 0; i < posts.length; i++) {
                postsModel.append(posts[i])
            }
        }
        
        function onPostCreated() {
            bottomBar.currentIndex = 0
            // mainTabs.currentIndex is bound to bottomBar.currentIndex, so no need to set it
            // doing so breaks the binding!
        }
        
        function onLoginSuccess(user, avatar) {
            isLoggedIn = true
            // If already face auth passed, good. If not, maybe do it now?
            // For this flow: Login -> Face Auth -> App
            if (!isFaceAuthPassed) isFaceAuthPassed = false // Reset to force check
        }
        function onLoginFailed(msg) {
            console.log(msg)
            // Could show a dialog here
        }
        function onRegisterSuccess() {
            console.log("Registered!")
            authStack.pop() // Go back to login view
        }
        
        function onLogoutSuccess() {
            isLoggedIn = false
            isFaceAuthPassed = false
            authStack.pop(null) // Pop all items from authStack to ensure we are at initialItem (loginView)
            appStack.pop(null) // Pop all items from appStack to ensure we are at initialItem (mainTabs)
        }
    }

    ListModel { id: postsModel }

    Component.onCompleted: {
        NetworkManager.fetchFeed()
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
                        onLoginClicked: (u, p) => NetworkManager.login(u, p)
                        onRegisterClicked: () => authStack.push(registerView)
                    }
                }
                
                Component {
                    id: registerView
                    RegisterView {
                        onRegisterClicked: (u, p) => NetworkManager.registerUser(u, p)
                        onBackClicked: () => authStack.pop()
                    }
                }
            }
        }
        
        // 2. Face Auth (Intermediate Step)
        FaceAuthView {
            anchors.fill: parent
            visible: isLoggedIn && !isFaceAuthPassed
            onAuthSuccess: isFaceAuthPassed = true
        }

        // 3. App Flow
        ColumnLayout {
            id: appContainer
            anchors.fill: parent
            visible: isLoggedIn && isFaceAuthPassed
            spacing: 0

            StackView {
                id: appStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                initialItem: mainTabs
                
                Component {
                    id: messagesViewComp
                    MessagesView {}
                }
                
                Component {
                    id: threadDetailViewComp
                    ThreadDetailView {}
                }

                StackLayout {
                    id: mainTabs
                    
                    // Tab 0: Home
                    ThreadsHomeView { 
                        onMessagesClicked: appStack.push(messagesViewComp)
                        // Note: ThreadCard handles its own navigation usually, 
                        // but if main.qml needs to intercept:
                    }
                    
                    // Tab 1: Search
                    SearchView {}
                    
                    // Tab 2: Create Post
                    CreateThreadView {}
                    
                    // Tab 3: Activity (Heart)
                    ActivityView {}
                    
                    // Tab 4: Profile
                    ProfileView {
                        // User info is managed by UserStore/ProfileViewModel usually
                    }
                    
                    // Logic to sync with BottomBar
                    currentIndex: bottomBar.currentIndex
                }
            }

            // Navigation Bar
            BottomNavBar {
                id: bottomBar
                Layout.fillWidth: true
            }
        }
    }
}
