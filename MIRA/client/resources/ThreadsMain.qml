// New main.qml for Threads clone
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"
import "views"

ApplicationWindow {
    id: window
    visible: true
    width: 390  // iPhone size for consistency
    height: 844
    title: "Threads"
    
    // Remove default window chrome for mobile-like experience
    flags: Qt.Window
    color: ThreadsConstants.background
    
    // Main container
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Content area (StackView for navigation)
        StackView {
            id: mainStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            initialItem: tabContainer
            
            // Main tab container
            Component {
                id: tabContainer
                
                Item {
                    // Tab content
                    StackLayout {
                        id: tabLayout
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: tabBar.top
                        currentIndex: tabBar.currentIndex
                        
                        // Home Tab
                        ThreadsHomeView {
                            id: homeView
                        }
                        
                        // Search Tab
                        Item {
                            Text {
                                anchors.centerIn: parent
                                text: "🔍 Search\n(Coming Soon)"
                                font.pixelSize: 24
                                color: ThreadsConstants.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                        
                        // New Post Tab
                        Item {
                            Text {
                                anchors.centerIn: parent
                                text: "✍️ New Post\n(Coming Soon)"
                                font.pixelSize: 24
                                color: ThreadsConstants.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                        
                        // Activity Tab
                        Item {
                            Text {
                                anchors.centerIn: parent
                                text: "❤️ Activity\n(Coming Soon)"
                                font.pixelSize: 24
                                color: ThreadsConstants.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                        
                        // Profile Tab
                        Item {
                            Text {
                                anchors.centerIn: parent
                                text: "👤 Profile\n(Coming Soon)"
                                font.pixelSize: 24
                                color: ThreadsConstants.textSecondary
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }
                    
                    // Bottom Tab Bar
                    ThreadsTabBar {
                        id: tabBar
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        currentIndex: 0
                        
                        onTabClicked: function(index) {
                            currentIndex = index
                        }
                    }
                }
            }
        }
    }
    
    // Status bar styling (for mobile)
    Component.onCompleted: {
        console.log("Threads app started")
    }
}
