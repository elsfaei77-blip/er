import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    color: "transparent"
    clip: true
    
    signal settingsRequested()
    signal editProfileRequested(var model)
    property bool isLoading: false

    // ViewModel Integration
    ProfileViewModel {
        id: profileViewModel
        // Removed auto-update loop. Updates should be explicit via EditProfileView.
        onProfileChanged: {
             console.log("ProfileView: Profile changed. Avatar:", profileViewModel.avatarColor)
        }
    }
    
    ThreadModel { id: myThreadsModel }
    
    // Refresh Logic
    property alias refreshTimer: refreshTimer
    Timer {
        id: refreshTimer
        interval: 1500; repeat: false
        onTriggered: {
            if (authService.currentUser.id) {
                profileViewModel.loadProfile(authService.currentUser.id)
                myThreadsModel.refresh(authService.currentUser.id)
                myThreadsModel.refreshStories()
                root.isLoading = false
            }
        }
        onRunningChanged: if (running) root.isLoading = true
    }

    // Bindings
    property string currentUserName: profileViewModel.username
    property string currentUserHandle: "@" + profileViewModel.username
    property string currentUserBio: profileViewModel.bio
    property string currentUserAvatarColor: profileViewModel.avatarColor
    property int activeTab: 0
    
    function loadData() {
        if (authService.currentUser.id) {
            profileViewModel.loadProfile(authService.currentUser.id)
            myThreadsModel.refresh(authService.currentUser.id)
            myThreadsModel.refreshStories()
        }
    }

    Component.onCompleted: loadData()
    Connections { target: authService; function onLoginSuccess() { loadData() } }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // --- 1. Fixed Header ---
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            z: 10
            
            RowLayout {
                anchors.right: parent.right; anchors.rightMargin: Theme.space20
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.space16

                MiraIcon {
                    name: "globe"; size: 22; color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: accountInfoPopup.open()
                    }
                }

                MiraIcon {
                    name: "list"; size: 24; color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: root.settingsRequested()
                    }
                }
            }
        }
        
        // --- 2. Scrollable Content ---
        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: contentCol.implicitHeight + 100
            boundsBehavior: Flickable.DragOverBounds
            clip: true
            
            onContentYChanged: {
                if (contentY < -120 && !refreshTimer.running) refreshTimer.start()
            }
            
            PullToRefresh {
                anchors.top: parent.top
                mode: "spinner"
                visible: parent.contentY < 0 || refreshTimer.running
                pullPercentage: Math.min(-parent.contentY / 100, 1.0)
                refreshing: refreshTimer.running
                z: 100
            }

            ColumnLayout {
                id: contentCol
                width: parent.width
                spacing: 0

                // --- Profile Info Header ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.space20
                    Layout.rightMargin: Theme.space20
                    spacing: Theme.space16
                    
                    // Top Row: Info Left, Avatar Right
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Theme.space16
                        
                            // PARALLAX INFO: Moves slightly slower than scroll
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                transform: Translate { y: flickable ? Math.max(0, flickable.contentY * 0.15) : 0 }
                                
                                Text {
                                    text: profileViewModel.fullName
                                    color: Theme.textPrimary
                                    font.pixelSize: 24
                                    font.weight: Theme.weightBold
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }
                            
                            RowLayout {
                                spacing: 4
                                Text {
                                    text: currentUserHandle
                                    color: Theme.textPrimary
                                    font.pixelSize: 15
                                }
                                Rectangle {
                                    width: 70; height: 18; radius: 9
                                    color: Theme.surfaceElevated
                                }
                                MiraIcon {
                                    visible: Theme.isPlatinumUser
                                    name: "verified"
                                    size: 14; color: "#E5E4E2"
                                    active: true
                                }
                            }
                        }
                        
                        // PARALLAX AVATAR: Moves slightly faster than scroll for depth
                        MiraAvatar {
                            userId: profileViewModel.userId
                            username: profileViewModel.username
                            avatarSource: profileViewModel.avatarColor
                            size: 84
                            clickable: true
                            transform: Translate { y: flickable ? Math.max(0, flickable.contentY * 0.25) : 0 }
                        }
                    }
                    
                    // Bio
                    Text {
                        Layout.fillWidth: true
                        text: currentUserBio
                        color: Theme.textPrimary
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                        lineHeight: 1.3
                    }
                    
                    // Stats Row
                    Row {
                        id: statsRow
                        spacing: 8
                        
                        opacity: 0
                        transform: Translate { id: statsTranslate; y: 10 }
                        SequentialAnimation {
                            id: profileStatsAnim
                            PauseAnimation { duration: 300 }
                            ParallelAnimation {
                                NumberAnimation { target: statsRow; property: "opacity"; to: 1; duration: Theme.animNormal }
                                NumberAnimation { target: statsTranslate; property: "y"; to: 0; duration: Theme.animNormal; easing.type: Theme.luxuryEasing }
                            }
                        }
                        Component.onCompleted: profileStatsAnim.start()

                        Text {
                            text: profileViewModel.postsCount + " posts"
                            color: Theme.textSecondary; font.pixelSize: 15; font.family: Theme.fontFamily
                        }
                        Text {
                            text: "•"
                            color: Theme.textSecondary; font.pixelSize: 15
                        }
                        Text {
                            text: profileViewModel.followersCount + " followers"
                            color: Theme.textSecondary; font.pixelSize: 15; font.family: Theme.fontFamily
                        }
                        Text {
                            text: "•"
                            color: Theme.textSecondary; font.pixelSize: 15
                        }
                        Text {
                            text: profileViewModel.followingCount + " following"
                            color: Theme.textSecondary; font.pixelSize: 15; font.family: Theme.fontFamily
                        }
                    }
                    
                    // Action Buttons
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: 8
                        spacing: Theme.space8
                        
                        MiraButton {
                            Layout.fillWidth: true
                            text: qsTr("Edit profile")
                            type: "secondary"
                            onClicked: root.editProfileRequested(profileViewModel)
                        }
                        
                        MiraButton {
                            Layout.fillWidth: true
                            text: qsTr("Share")
                            type: "secondary"
                            onClicked: shareSheet.open()
                        }

                        MiraButton {
                            Layout.preferredWidth: 44
                            icon: "stats" // Ensure this icon exists or fallback
                            type: "secondary"
                            onClicked: {
                                if (typeof mainStack !== "undefined") {
                                    mainStack.push(Qt.resolvedUrl("AnalyticsDashboard.qml"))
                                }
                            }
                        }
                    }
                } // End Profile Info
                
                // --- Tab Bar ---
                Item {
                    id: tabBarContainer
                    Layout.fillWidth: true
                    Layout.topMargin: Theme.space20
                    Layout.preferredHeight: 48
                    
                    Rectangle {
                        id: profileTabIndicator
                        width: parent.width / 3
                        height: 1.5
                        color: Theme.textPrimary
                        anchors.bottom: parent.bottom
                        x: root.activeTab * (parent.width / 3)
                        z: 10
                        Behavior on x { NumberAnimation { duration: Theme.animNormal; easing.type: Theme.luxuryEasing } }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom; width: parent.width; height: 1
                        color: Theme.divider
                    }
                    
                    RowLayout {
                        id: tabItemsLayout
                        anchors.fill: parent
                        spacing: 0
                        Repeater {
                            model: [qsTr("Threads"), qsTr("Likes"), qsTr("Reposts")]
                            Item {
                                Layout.fillWidth: true; Layout.fillHeight: true
                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: index === root.activeTab ? Theme.textPrimary : Theme.textSecondary
                                    font.weight: index === root.activeTab ? Font.DemiBold : Font.Normal
                                    font.pixelSize: 15; font.family: Theme.fontFamily
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        root.activeTab = index
                                        var filter = ""
                                        if (index === 0) filter = "user"
                                        else if (index === 1) filter = "likes"
                                        else if (index === 2) filter = "reposts"
                                        
                                        myThreadsModel.refresh(authService.currentUser.id, filter)
                                        if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                                    }
                                }
                            }
                        }
                    }
                }
                
                // --- Feed Content ---
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    visible: root.isLoading
                    Repeater {
                        model: 3
                        SkeletonCard { width: contentCol.width }
                    }
                }

                Repeater {
                    model: myThreadsModel
                    visible: !root.isLoading
                    PostCard {
                        width: contentCol.width
                        username: model.author; content: model.content; timestamp: model.time
                        avatarColor: model.avatarColor; isVerified: model.isVerified
                        likes: model.likesCount; replies: model.replyCount; isLiked: model.isLiked
                        reactionType: model.reactionType; reactionSummary: model.reactionSummary
                        postIndex: index
                        imageUrl: model.imageUrl || ""
                        videoUrl: model.videoUrl || ""
                        showThreadLine: index < myThreadsModel.rowCount() - 1
                        viewModel: myThreadsModel
                        userId: model.userId
                        onClicked: mainStack.push(postDetailView, { threadData: { 
                            "id": model.id,
                            "author": model.author, "content": model.content, 
                            "time": model.time, "avatarColor": model.avatarColor,
                            "isVerified": model.isVerified, "likesCount": model.likesCount,
                            "replyCount": model.replyCount, "isLiked": model.isLiked,
                            "reactionType": model.reactionType,
                            "reactionSummary": model.reactionSummary,
                            "userId": model.userId
                        }, threadIndex: index, viewModel: myThreadsModel })
                    }
                }
                
                // Empty State
                Item {
                    Layout.fillWidth: true; Layout.preferredHeight: 200
                    visible: myThreadsModel.rowCount() === 0
                    Text {
                        anchors.centerIn: parent
                        text: "No threads yet"
                        color: Theme.textSecondary
                        font.pixelSize: 14
                    }
                }
            }
        }
    }
    
    // Popup & Sheets (Preserved)
    // Account Info Popup
    Popup {
        id: accountInfoPopup
        anchors.centerIn: parent
        width: Math.min(parent.width - 40, 360)
        height: 280
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        background: Rectangle {
            color: Theme.surfaceElevated
            radius: 16
            border.color: Theme.divider
            border.width: 1
        }
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            
            Text {
                text: "About this account"
                color: Theme.textPrimary
                font.pixelSize: 20
                font.weight: Theme.weightBold
                Layout.alignment: Qt.AlignHCenter
            }
            
            Rectangle {
                Layout.fillWidth: true; height: 1; color: Theme.divider
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16
                
                RowLayout {
                    spacing: 12
                    Text { text: "📅"; font.pixelSize: 16 }
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Date joined"; color: Theme.textSecondary; font.pixelSize: 13 }
                        Text { text: profileViewModel.createdAt || qsTr("N/A"); color: Theme.textPrimary; font.weight: Font.DemiBold; font.pixelSize: 15 }
                    }
                }
                
                RowLayout {
                    spacing: 12
                    Text { text: "🌍"; font.pixelSize: 16 }
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Account based in"; color: Theme.textSecondary; font.pixelSize: 13 }
                        Text { text: profileViewModel.country || qsTr("N/A"); color: Theme.textPrimary; font.weight: Font.DemiBold; font.pixelSize: 15 }
                    }
                }
                
                RowLayout {
                    spacing: 12
                    Text { text: "📱"; font.pixelSize: 16 }
                    ColumnLayout {
                        spacing: 2
                        Text { text: "Device used"; color: Theme.textSecondary; font.pixelSize: 13 }
                        Text { text: profileViewModel.deviceType || "Android"; color: Theme.textPrimary; font.weight: Font.DemiBold; font.pixelSize: 15 }
                    }
                }
            }
            
            Item { Layout.fillHeight: true }
            
            MiraButton {
                text: qsTr("Close")
                Layout.fillWidth: true
                type: "secondary"
                onClicked: accountInfoPopup.close()
            }
        }
    }

    ActionSheet {
        id: shareSheet
        model: [ {"label": "Copy link", "icon": "🔗"}, {"label": "Share via...", "icon": "📤"} ]
    }
    
    // Settings / Logout Action Sheet
    ActionSheet {
        id: settingsSheet
        model: [
            {"label": "Settings", "icon": "⚙️"},
            {"label": "Privacy", "icon": "🔒"},
            {"label": "Log out", "icon": "🚪", "isDestructive": true}
        ]
        onItemClicked: (idx, label) => {
             if (label === "Log out") {
                 authService.logout()
                 mainStack.pop(null) // Reset stack
                 mainStack.push(loginView) // Go to login
             } else if (label === "Settings") {
                 mainStack.push("qrc:/views/SettingsView.qml")
             }
        }
    }
    
    // Connections for Signals from UI
    Connections {
        target: root
        function onSettingsRequested() {
            settingsSheet.open()
        }
    }
}
