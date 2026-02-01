import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import MiraApp
import "../components"

Rectangle {
    id: root
    color: "transparent" // Let Nebula background show through
    
    signal closed()
    signal posted(string content)
    
    property bool hasImage: false
    property bool hasVideo: false
    property string selectedMediaUrl: ""
    property bool isPosting: false
    property int charLimit: 500
    property bool threadingMode: false
    
    // Feature flags
    property bool showPoll: false
    property string taggedLocation: ""
    property var taggedUsers: []
    property string scheduledTime: ""

    ThreadModel {
        id: threadModel
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20
                
                Text {
                    text: Loc.getString("cancel")
                    color: Theme.textSecondary
                    font.pixelSize: 16; font.family: Theme.fontFamily; font.weight: Theme.weightMedium
                    MouseArea { 
                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                        onClicked: root.closed()
                    }
                }
                
                Item { Layout.fillWidth: true }
                
                Text {
                    text: Loc.getString("newThread")
                    color: Theme.textPrimary
                    font.pixelSize: 17; font.weight: Theme.weightBold; font.family: Theme.fontFamily
                }
                
                Item { Layout.fillWidth: true }
                
                // Executive Post Button
                Rectangle {
                    id: postBtn
                    width: 72; height: 34; radius: 10
                    color: threadText.text.length > 0 ? Theme.accent : "transparent"
                    border.color: threadText.text.length > 0 ? "transparent" : Theme.divider
                    border.width: 1
                    
                    Text {
                        anchors.centerIn: parent
                        visible: !isPosting
                        text: scheduledTime !== "" ? qsTr("Schedule") : Loc.getString("post")
                        color: threadText.text.length > 0 ? Theme.background : Theme.textTertiary
                        font.weight: Theme.weightBold; font.pixelSize: 14; font.family: Theme.fontFamily
                    }
                    
                    BusyIndicator {
                        anchors.centerIn: parent
                        visible: isPosting
                        width: 18; height: 18
                    }

                    MouseArea {
                        anchors.fill: parent
                        enabled: threadText.text.length > 0 && !isPosting
                        onClicked: {
                            isPosting = true
                            // Send the actual media path to the model
                            threadModel.createPost(threadText.text, root.selectedMediaUrl)
                            
                            if (scheduledTime !== "" && typeof nativeToast !== "undefined") {
                                nativeToast.show("Post scheduled for " + scheduledTime, "success")
                            }

                            postTimer.start() 
                        }
                    }
                }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider }
        }
        
        // Composer Area
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: mainComposerRow.implicitHeight + 100
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            
            ColumnLayout {
                id: mainComposerRow
                width: parent.width
                spacing: 0
                
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    Layout.leftMargin: Theme.space20; Layout.rightMargin: Theme.space20
                    Layout.topMargin: Theme.space20
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.alignment: Qt.AlignTop
                        spacing: 8
                        Rectangle {
                            width: 44; height: 44; radius: 22
                            color: authService.currentUser.avatar || Theme.gray
                            clip: true
                            Image {
                                anchors.fill: parent; anchors.margins: 2
                                source: authService.currentUser.avatar || ""
                            }
                        }
                        Rectangle {
                            Layout.alignment: Qt.AlignHCenter
                            width: 2; Layout.fillHeight: true
                            color: Theme.divider; opacity: 0.5
                        }
                    }
                    
                    ColumnLayout {
                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                        spacing: 6
                        
                        Text {
                            text: authService.currentUser.username || "User"
                            color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 15; font.family: Theme.fontFamily
                        }
                        
                        TextArea {
                            id: threadText
                            Layout.fillWidth: true
                            placeholderText: Loc.getString("whatsNew")
                            placeholderTextColor: Theme.textTertiary
                            color: Theme.textPrimary
                            font.pixelSize: 15; font.family: Theme.fontFamily
                            wrapMode: Text.WordWrap; background: null; padding: 0
                        }
                        
                        // Metadata Chips (Location, Users, Schedule)
                        Flow {
                            Layout.fillWidth: true
                            spacing: 8
                            
                            // Location Chip
                            Rectangle {
                                visible: root.taggedLocation !== ""
                                width: locRow.implicitWidth + 16; height: 26; radius: 13
                                color: Theme.surfaceElevated
                                RowLayout {
                                    id: locRow; anchors.centerIn: parent; spacing: 4
                                    MiraIcon { name: "globe"; size: 12; color: Theme.accent }
                                    Text { text: root.taggedLocation; color: Theme.accent; font.pixelSize: 12; font.weight: Font.Bold }
                                    Text { text: "✕"; color: Theme.textSecondary; font.pixelSize: 10 
                                            MouseArea { anchors.fill: parent; onClicked: root.taggedLocation = "" } }
                                }
                            }
                            
                            // Scheduled Time Chip
                            Rectangle {
                                visible: root.scheduledTime !== ""
                                width: schedRow.implicitWidth + 16; height: 26; radius: 13
                                color: Theme.surfaceElevated
                                RowLayout {
                                    id: schedRow; anchors.centerIn: parent; spacing: 4
                                    MiraIcon { name: "event"; size: 12; color: Theme.purple } // 'event' or close fit
                                    Text { text: root.scheduledTime; color: Theme.purple; font.pixelSize: 12; font.weight: Font.Bold }
                                    Text { text: "✕"; color: Theme.textSecondary; font.pixelSize: 10 
                                            MouseArea { anchors.fill: parent; onClicked: root.scheduledTime = "" } }
                                }
                            }
                        }

                        // Poll Creator
                        PollCreator {
                            visible: root.showPoll
                            Layout.fillWidth: true
                            Layout.topMargin: 8
                        }
                        
                        Rectangle {
                            id: mediaArea
                            visible: hasImage || hasVideo
                            Layout.fillWidth: true
                            Layout.preferredHeight: visible ? 240 : 0
                            Layout.topMargin: 8
                            radius: 12; clip: true; color: Theme.surface
                            border.color: Theme.divider; border.width: 1
                            
                            Image {
                                anchors.fill: parent
                                visible: hasImage
                                source: hasImage ? root.selectedMediaUrl : ""
                                fillMode: Image.PreserveAspectCrop
                            }

                            // Video Placeholder
                            Rectangle {
                                anchors.fill: parent
                                visible: hasVideo
                                color: Theme.surface
                                ColumnLayout {
                                    anchors.centerIn: parent
                                    spacing: 8
                                    Text { text: "📹"; font.pixelSize: 24; Layout.alignment: Qt.AlignHCenter }
                                    Text { text: qsTr("Video Selected"); color: Theme.textPrimary; font.pixelSize: 12; Layout.alignment: Qt.AlignHCenter }
                                }
                            }
                            
                            Rectangle {
                                anchors.top: parent.top; anchors.right: parent.right; anchors.margins: 10
                                width: 26; height: 26; radius: 13; color: Qt.rgba(0,0,0,0.6)
                                Text { anchors.centerIn: parent; text: "✕"; color: "white"; font.pixelSize: 12 }
                                MouseArea { anchors.fill: parent; onClicked: { hasImage = false; hasVideo = false; selectedMediaUrl = "" } }
                            }
                        }
                        
                        // --- NEW: Rich Text Toolbar ---
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.topMargin: 8
                            spacing: 16
                            
                            Item {
                                Layout.preferredWidth: 32; Layout.preferredHeight: 32
                                Rectangle {
                                    anchors.fill: parent; radius: 6; color: Theme.surfaceElevated
                                    Text { anchors.centerIn: parent; text: "B"; font.weight: Font.Bold; color: Theme.textPrimary; font.family: Theme.fontFamily }
                                }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                            }
                            Item {
                                Layout.preferredWidth: 32; Layout.preferredHeight: 32
                                Rectangle {
                                    anchors.fill: parent; radius: 6; color: Theme.surfaceElevated
                                    Text { anchors.centerIn: parent; text: "I"; font.italic: true; color: Theme.textPrimary; font.family: Theme.fontFamily }
                                }
                                MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor }
                            }
                            MiraIcon { name: "hash"; size: 18; color: Theme.gray }
                            MiraIcon { name: "mention"; size: 18; color: Theme.gray } // Used to be 'at'
                            Item { Layout.fillWidth: true }
                            
                            // Character Count
                            Text {
                                text: (root.charLimit - threadText.length)
                                color: (root.charLimit - threadText.length) < 20 ? Theme.likeRed : Theme.textTertiary
                                font.pixelSize: 12
                            }
                        }

                        // --- NEW: Action Row ---
                        ScrollView {
                            Layout.fillWidth: true; Layout.preferredHeight: 50; Layout.topMargin: 12
                            contentWidth: actionRow.implicitWidth; clip: true
                            
                            RowLayout {
                                id: actionRow
                                spacing: 12
                                
                                // Tag People
                                Rectangle {
                                    height: 32; width: 100; radius: 16; color: "transparent"; border.color: Theme.divider
                                    RowLayout { anchors.centerIn: parent; spacing: 6 
                                        MiraIcon { name: "profile"; size: 14; color: Theme.textPrimary }
                                        Text { text: qsTr("Tag People"); color: Theme.textPrimary; font.pixelSize: 12 }
                                    }
                                    MouseArea { anchors.fill: parent; onClicked: taggingDialog.open() }
                                }
                                
                                // Add Location
                                Rectangle {
                                    height: 32; width: 110; radius: 16; color: "transparent"; border.color: Theme.divider
                                    RowLayout { anchors.centerIn: parent; spacing: 6 
                                        MiraIcon { name: "globe"; size: 14; color: Theme.textPrimary }
                                        Text { text: qsTr("Add Location"); color: Theme.textPrimary; font.pixelSize: 12 }
                                    }
                                    MouseArea { anchors.fill: parent; onClicked: locationDialog.open() }
                                }
                                
                                // Schedule
                                Rectangle {
                                    height: 32; width: 100; radius: 16; color: "transparent"; border.color: Theme.divider
                                    RowLayout { anchors.centerIn: parent; spacing: 6 
                                        Text { text: "🕒"; font.pixelSize: 12 }
                                        Text { text: qsTr("Schedule"); color: Theme.textPrimary; font.pixelSize: 12 }
                                    }
                                    MouseArea { anchors.fill: parent; onClicked: scheduleDialog.open() }
                                }
                            }
                        }

                        // Media Icons Row
                        RowLayout {
                            spacing: 24; Layout.topMargin: 20
                            
                            // Photo
                            MiraIcon { 
                                name: "image"; size: 22; color: Theme.textSecondary
                                MouseArea { anchors.fill: parent; onClicked: imageDialog.open() } 
                            }
                            
                            // Video
                            MiraIcon { 
                                name: "video"; size: 22; color: Theme.textSecondary
                                MouseArea { anchors.fill: parent; onClicked: videoDialog.open() } 
                            }
                            
                            // Poll
                            MiraIcon { 
                                name: "list"; size: 22; color: Theme.textSecondary
                                MouseArea { 
                                    anchors.fill: parent
                                    onClicked: root.showPoll = !root.showPoll
                                } 
                            }
                            
                            Item { Layout.fillWidth: true }
                        }
                    }
                }
            }
        }
        
        // Footer (Anyone can reply)
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 48; color: "transparent"
            Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: Theme.divider }
            RowLayout {
                anchors.fill: parent; anchors.leftMargin: Theme.space20; anchors.rightMargin: Theme.space20
                Text { text: Loc.getString("anyoneCanReply"); color: Theme.textTertiary; font.pixelSize: 14; font.family: Theme.fontFamily }
                Item { Layout.fillWidth: true }
                MiraIcon { name: "settings"; size: 16; color: Theme.textTertiary }
            }
        }
    }
    
    Timer { id: postTimer; interval: 1000; onTriggered: { isPosting = false; root.closed() } }

    FileDialog {
        id: imageDialog
        title: qsTr("Select Image")
        nameFilters: ["Image files (*.jpg *.png *.jpeg)"]
        onAccepted: {
            root.selectedMediaUrl = selectedFile.toString()
            root.hasImage = true
            root.hasVideo = false
        }
    }

    FileDialog {
        id: videoDialog
        title: qsTr("Select Video")
        nameFilters: ["Video files (*.mp4 *.mov *.avi)"]
        onAccepted: {
            root.selectedMediaUrl = selectedFile.toString()
            root.hasVideo = true
            root.hasImage = false
        }
    }
    
    // Quick Simulation Dialogs
    Dialog {
        id: locationDialog; title: qsTr("Select Location"); width: 300; modal: true; anchors.centerIn: parent
        ColumnLayout {
            anchors.fill: parent; spacing: 8
            Repeater {
                model: ["Riyadh, SA", "Dubai, UAE", "London, UK", "Neom, SA"]
                delegate: Item { 
                    Layout.fillWidth: true; Layout.preferredHeight: 40
                    Text { text: modelData; anchors.centerIn: parent; color: Theme.textPrimary }
                    MouseArea { anchors.fill: parent; onClicked: { root.taggedLocation = modelData; locationDialog.close() } }
                }
            }
        }
    }
    
    Dialog {
        id: taggingDialog; title: qsTr("Tag People"); width: 300; modal: true; anchors.centerIn: parent
        Text { text: "User selection simulation..."; color: Theme.textPrimary; anchors.centerIn: parent; padding: 20 }
        standardButtons: Dialog.Ok
    }
    
    Dialog {
        id: scheduleDialog; title: qsTr("Schedule Post"); width: 300; modal: true; anchors.centerIn: parent
        ColumnLayout {
            anchors.fill: parent; spacing: 8
            Text { text: qsTr("Select time"); color: Theme.textPrimary; Layout.alignment: Qt.AlignHCenter }
            Repeater {
                model: ["Tomorrow, 9:00 AM", "Tomorrow, 5:00 PM", "Next Monday, 9:00 AM"]
                delegate: Item { 
                    Layout.fillWidth: true; Layout.preferredHeight: 40
                    Text { text: modelData; anchors.centerIn: parent; color: Theme.textPrimary }
                    MouseArea { anchors.fill: parent; onClicked: { root.scheduledTime = modelData; scheduleDialog.close() } }
                }
            }
        }
    }
}
