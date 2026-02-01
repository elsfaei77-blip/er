import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "components"
import "views"
import "."

Window {
    id: mainWindow
    width: Constants.screenWidth
    height: Constants.screenHeight
    visible: true
    title: "Threads Clone"
    color: Constants.background

    // --- Data Models ---
    ListModel {
        id: postsModel
        ListElement {
            userName: "zuck"
            time: "2m"
            txt: "Building the future of social, one line of code at a time."
            replies: 120
            likes: 5400
            avatar: ""
        }
        ListElement {
            userName: "mosseri"
            time: "15m"
            txt: "Rolling out dark mode for everyone today! Let us know what you think."
            replies: 89
            likes: 3200
            avatar: ""
        }
        ListElement {
            userName: "mkbhd"
            time: "1h"
            txt: "So, I've been testing this new app for a week... and it's surprisingly clean."
            replies: 450
            likes: 12000
            avatar: ""
        }
    }

    // --- Main Layout ---
    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Content Area 
        // We use StackView primarily, but for the 5 bottom tabs, we want to keep state alive.
        // So we wrap the tabs in a SwipeView (interactive:false) or StackLayout.
        // StackLayout is better for "instant" tab switching.
        
        StackLayout {
            id: mainTabs
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: bottomBar.currentIndex
            
            // Tab 0: Home
            HomeView { 
                model: postsModel 
            }
            
            // Tab 1: Search
            SearchView {}
            
            // Tab 2: Create Post
            CreatePostView {
                onPostCreated: (content) => {
                    // Logic to add post
                    postsModel.insert(0, {
                        "userName": "me_myself_i",
                        "time": "Just now",
                        "txt": content,
                        "replies": 0,
                        "likes": 0,
                        "avatar": ""
                    })
                    // Go back to home
                    bottomBar.currentIndex = 0
                }
            }
            
            // Tab 3: Activity
            ActivityView {}
            
            // Tab 4: Profile
            ProfileView {
                // Pass current user data
                userName: "me_myself_i"
                bio: "Digital explorer. \nBuilding things in QML."
            }
        }

        // Navigation Bar
        BottomNavBar {
            id: bottomBar
            Layout.fillWidth: true
            // z: 100 // Ensure it's above if we decide to overlay
        }
    }
}
