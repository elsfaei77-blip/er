import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent" // Let Nebula background show through
    
    SearchViewModel {
        id: searchViewModel
    }
    
    property alias searchList: searchList
    property alias refreshTimer: refreshTimer
    property bool isLoading: false
    
    Timer {
        id: refreshTimer
        interval: 1500; repeat: false
        onTriggered: {
            searchViewModel.search(searchInput.text)
            root.isLoading = false
        }
        onRunningChanged: if (running) root.isLoading = true
    }

    // Search Logic
    function performSearch(text) {
        // In a real app, this would query an API
        console.log("Searching for:", text);
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header title
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            Text {
                anchors.left: parent.left
                anchors.leftMargin: Theme.space20
                anchors.verticalCenter: parent.verticalCenter
                text: Loc.getString("search")
                color: Theme.textPrimary
                font.pixelSize: 26; font.weight: Theme.weightBold; font.family: Theme.fontFamily
            }
        }
        
        // Search Bar (Obsidian Style)
        Rectangle {
            id: searchBar
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            Layout.leftMargin: Theme.space20
            Layout.rightMargin: Theme.space20
            Layout.topMargin: Theme.space8
            Layout.bottomMargin: Theme.space8
            color: Theme.surfaceElevated
            radius: 12
            border.color: Theme.divider; border.width: 1
            
            RowLayout {
                anchors.fill: parent
                spacing: 0
                
                // Search Trigger Icon
                Item {
                    id: searchBtn
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 44
                    
                    MiraIcon { 
                        anchors.centerIn: parent
                        name: "search"; size: 22; color: Theme.textTertiary; active: true 
                        enabled: false // Let parent handle mouse
                    }
                    
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.textTertiary
                        opacity: searchMouse.pressed ? 0.1 : 0.0
                        radius: 12
                    }
                    
                    MouseArea {
                        id: searchMouse
                        anchors.fill: parent
                        onClicked: {
                            if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                            console.log("Search button clicked!");
                            searchViewModel.search(searchInput.text);
                        }
                    }
                }
                
                TextField {
                    id: searchInput
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: Theme.textPrimary
                    font.pixelSize: 16
                    font.family: Theme.fontFamily
                    verticalAlignment: Text.AlignVCenter
                    placeholderText: Loc.getString("searchPlaceholder")
                    placeholderTextColor: Theme.textTertiary
                    leftPadding: 0
                    background: null
                    selectionColor: Theme.accent
                    
                    onAccepted: searchViewModel.search(text)
                    onTextChanged: {
                         if (text.length > 0) {
                             searchViewModel.search(text)
                         }
                    }
                }
                
                // Close/Clear Icon
                Item {
                    visible: searchInput.text.length > 0
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 44
                    
                    MiraIcon {
                        anchors.centerIn: parent
                        name: "close"
                        size: 16
                        color: Theme.textTertiary
                        enabled: false
                    }
                    
                    Rectangle {
                        anchors.fill: parent
                        color: Theme.textTertiary
                        opacity: closeMouse.pressed ? 0.1 : 0.0
                        radius: 12
                    }
                    
                    MouseArea { 
                        id: closeMouse
                        anchors.fill: parent
                        onClicked: { 
                            if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                            searchInput.text = ""; 
                            searchViewModel.search("");
                        } 
                    }
                }
            }
        }
        
        // --- NEW: Discovery Tabs ---
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.space20
            Layout.rightMargin: Theme.space20
            Layout.bottomMargin: Theme.space16
            spacing: 12
            
            property int currentTab: 0

            Repeater {
                model: [
                    { label: qsTr("For You"), icon: "✨" },
                    { label: qsTr("Trending"), icon: "📈" },
                    { label: qsTr("Challenges"), icon: "🔥", view: hashtagChallengesView },
                    { label: qsTr("Sounds"), icon: "🎵", view: soundLibraryView },
                    { label: qsTr("Videos"), icon: "🎥" },
                    { label: qsTr("Shop"), icon: "🛍️" }
                ]
                
                delegate: Rectangle {
                    Layout.preferredWidth: tabText.implicitWidth + 32
                    Layout.preferredHeight: 32
                    radius: 16
                    color: parent.currentTab === index ? Theme.gray : Theme.surfaceElevated
                    border.color: Theme.divider
                    border.width: 1
                    
                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 4
                        Text { text: modelData.icon; font.pixelSize: 12 }
                        Text {
                            id: tabText
                            text: modelData.label
                            color: Theme.textPrimary
                            font.pixelSize: 12
                            font.weight: Font.Bold
                        }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            parent.parent.currentTab = index
                            if (modelData.view) {
                                mainStack.push(modelData.view)
                            } else if (index === 1) {
                                mainStack.push(exploreView)
                            }
                        }
                    }
                }
            }
        }
        
        // Content Area 
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // Small Elegant Spinner Refresh
            PullToRefresh {
                id: ptr
                anchors.top: parent.top
                mode: "spinner"
                visible: searchList.contentY < 0 || refreshTimer.running
                pullPercentage: Math.min(-searchList.contentY / 100, 1.0)
                refreshing: refreshTimer.running
                z: 100
            }

            StackLayout {
                id: searchStack
                anchors.fill: parent
                currentIndex: searchInput.text.length > 0 ? 1 : 0
            
            // View 0: Discovery Cards (AI Powered)
            Flickable {
                contentWidth: parent.width
                contentHeight: discoveryLayout.implicitHeight + 40
                clip: true
                
                AIService {
                    id: aiSearchService
                }

                ColumnLayout {
                    id: discoveryLayout
                    anchors.top: parent.top; anchors.topMargin: 10
                    anchors.left: parent.left; anchors.right: parent.right
                    anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20
                    spacing: 20
                    
                    Text {
                        text: qsTr("Recommended for You")
                        color: Theme.textPrimary
                        font.pixelSize: 18; font.weight: Theme.weightBold; font.family: Theme.fontFamily
                    }
                    
                    Repeater {
                        model: aiSearchService.getDiscoveryCards()
                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 100
                            radius: 16
                            color: Theme.surface
                            clip: true
                            
                            Rectangle {
                                anchors.right: parent.right; anchors.top: parent.top; anchors.bottom: parent.bottom
                                width: 80
                                gradient: Gradient {
                                    orientation: Gradient.Horizontal
                                    GradientStop { position: 0.0; color: "transparent" }
                                    GradientStop { position: 1.0; color: modelData.color }
                                }
                                opacity: 0.2
                            }
                            
                            ColumnLayout {
                                anchors.fill: parent; anchors.margins: 16
                                spacing: 4
                                RowLayout {
                                    Text {
                                        text: modelData.tag.toUpperCase()
                                        color: modelData.color; font.pixelSize: 10; font.weight: Theme.weightBold
                                    }
                                }
                                Text {
                                    text: modelData.title
                                    color: Theme.textPrimary; font.pixelSize: 15; font.weight: Theme.weightBold
                                }
                                Text {
                                    text: modelData.description
                                    color: Theme.textSecondary; font.pixelSize: 13; Layout.fillWidth: true; wrapMode: Text.WordWrap; maximumLineCount: 2
                                }
                            }
                        }
                    }
                }
            }
            
            // View 1: Search Results
            ListView {
                id: searchList
                clip: true
                boundsBehavior: Flickable.DragOverBounds
                model: searchViewModel
                
                onContentYChanged: {
                    if (contentY < -120 && !refreshTimer.running) {
                        refreshTimer.start()
                    }
                }
                
                visible: !root.isLoading

                header: ColumnLayout {
                    width: searchList.width
                    visible: root.isLoading
                    spacing: 0
                    Repeater {
                        model: 5
                        SkeletonCard { width: searchList.width }
                    }
                }
                
                delegate: Rectangle {
                    width: searchList.width; height: 84; color: "transparent"
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20; spacing: 12
                        Rectangle {
                            width: 48; height: 48; radius: 24; color: Theme.gray
                            clip: true
                            Image {
                                anchors.fill: parent
                                source: (model.avatarColor && model.avatarColor.indexOf("/") !== -1) ? model.avatarColor : "https://api.dicebear.com/7.x/avataaars/svg?seed=" + model.username
                                fillMode: Image.PreserveAspectFit
                            }
                            Rectangle { anchors.fill: parent; radius: 24; border.color: Theme.divider; border.width: 1; color: "transparent" }
                        }
                        ColumnLayout {
                            Layout.fillWidth: true; spacing: 2
                            RowLayout {
                                spacing: 4
                                Text { text: model.username; color: Theme.textPrimary; font.weight: Theme.weightBold; font.family: Theme.fontFamily; font.pixelSize: 15 }
                            }
                            Text { text: model.fullName; color: Theme.textSecondary; font.pixelSize: 14; font.family: Theme.fontFamily; opacity: 0.8 }
                        }
                        Rectangle {
                            width: 90; height: 34; radius: 10
                            color: "transparent"; border.color: Theme.divider; border.width: 1
                            Text { anchors.centerIn: parent; text: qsTr("Follow"); color: Theme.textPrimary; font.weight: Theme.weightBold; font.family: Theme.fontFamily; font.pixelSize: 14 }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                                    searchViewModel.follow(index)
                                    if (typeof nativeToast !== "undefined") nativeToast.show(qsTr("Following %1").arg(model.username), "success")
                                }
                            }
                        }
                    }
                    Rectangle {
                        anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.leftMargin: 80; anchors.right: parent.right; anchors.rightMargin: Theme.space20
                        height: 1; color: Theme.divider
                    }
                }
                }
            }
        }
    }
}
