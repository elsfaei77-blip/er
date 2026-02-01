import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import Qt5Compat.GraphicalEffects
import MiraApp
import "."

Item {
    id: root
    width: parent ? parent.width : 390
    height: Math.max(contentLayout.implicitHeight + Theme.space24, 80)
    
    // --- Phase 4: Premium Entry Animation ---
    opacity: 0
    transform: Translate { id: entryTranslate; y: 20 }
    
    property int postIndex: -1
    property int userId: 0
    property int entryIndex: 0 // For staggered animation
    property var viewModel: null
    
    // --- Data Properties ---
    property string username: ""
    property string content: ""
    property string timestamp: ""
    property string avatarColor: Theme.accent
    property bool isReply: false
    property bool showThreadLine: false
    property bool isVerified: false
    property bool isLiked: false
    property var mediaUrls: []
    property string imageUrl: ""
    property string videoUrl: ""
    property int likes: 0
    property int replies: 0
    property string reactionType: ""
    property string reactionSummary: ""
    
    property real radiusValue: cardMouseArea.pressed ? Theme.radiusLarge : 0
    Behavior on radiusValue { NumberAnimation { duration: 200; easing.type: Easing.OutQuart } }
    
    Component.onCompleted: {
        entryAnim.start()
    }
    
    ParallelAnimation {
        id: entryAnim
        PauseAnimation { duration: Math.max(0, Math.min(root.entryIndex * Theme.staggerDelay, 600)) }
        NumberAnimation { target: root; property: "opacity"; to: 1; duration: Theme.animLuxury; easing.type: Theme.luxuryEasing }
        NumberAnimation { target: entryTranslate; property: "y"; to: 0; duration: Theme.animLuxury; easing.type: Theme.luxuryEasing }
    }

    signal clicked()
    // signal profileClicked() // Removed in favor of mainWindow.openProfile

    // --- SADEEM GLASS CARD BACKGROUND ---
    Rectangle {
        id: cardBackground
        anchors.fill: parent
        anchors.margins: 4
        radius: Theme.radiusMedium
        color: Theme.surface
        border.color: Theme.divider
        border.width: 1
    }

    Rectangle { 
        id: pressOverlay
        anchors.fill: parent; color: Theme.hoverOverlay; visible: cardMouseArea.pressed
        radius: root.radiusValue
    }

    // SHIMMER LAYER (PHASE 9)
    Rectangle {
        id: shimmerRect
        anchors.fill: parent
        radius: root.radiusValue
        color: "transparent"
        clip: true
        
        LinearGradient {
            id: shimmerGradient
            anchors.fill: parent
            start: Qt.point(shimmerPos - 200, 0)
            end: Qt.point(shimmerPos, 200)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 0.5; color: isDarkMode ? Qt.rgba(1,1,1,0.03) : Qt.rgba(0,0,0,0.03) }
                GradientStop { position: 1.0; color: "transparent" }
            }
            
            property real shimmerPos: -200
            
            SequentialAnimation on shimmerPos {
                loops: Animation.Infinite
                PauseAnimation { duration: 8000 + Math.random() * 4000 }
                NumberAnimation { from: -400; to: root.width + 400; duration: 2500; easing.type: Easing.InOutSine }
            }
        }
    }

    // DEPTH FOCUS: Dims content when interacting with specific post elements
    Rectangle {
        id: focusDim
        anchors.fill: parent
        color: "#000000"
        opacity: reactionPicker.visible ? 0.4 : 0
        z: 998
        Behavior on opacity { NumberAnimation { duration: 300 } }
        visible: opacity > 0
    }

    MouseArea { 
        id: cardMouseArea; 
        anchors.fill: parent; 
        pressAndHoldInterval: 400
        onClicked: root.clicked() 
        onDoubleClicked: {
            if (root.postIndex !== -1 && root.viewModel) {
                if (!root.isLiked) {
                    root.viewModel.toggleLike(root.postIndex)
                    if (typeof HapticManager !== "undefined") HapticManager.triggerImpactHeavy()
                    if (typeof nativeToast !== "undefined") nativeToast.show(qsTr("Liked!"), "success")
                }
                heartAnimation.start()
            }
        }
        onPressAndHold: {
            if (typeof HapticManager !== "undefined") HapticManager.triggerImpactMedium()
            reactionPicker.visible = true
            reactionPicker.open()
        }
    }

    // Heart Animation Overlay
    MiraIcon {
        id: heartOverlay
        anchors.centerIn: parent
        name: "like"
        size: 80
        color: Theme.accent
        active: true
        opacity: 0
        scale: 0
        z: 100
        
        SequentialAnimation {
            id: heartAnimation
            ParallelAnimation {
                NumberAnimation { target: heartOverlay; property: "opacity"; from: 0; to: 1; duration: 250; easing.type: Easing.OutBack }
                NumberAnimation { target: heartOverlay; property: "scale"; from: 0; to: 1.2; duration: 250; easing.type: Easing.OutBack }
            }
            PauseAnimation { duration: 400 }
            ParallelAnimation {
                NumberAnimation { target: heartOverlay; property: "opacity"; to: 0; duration: 200 }
                NumberAnimation { target: heartOverlay; property: "scale"; to: 1.5; duration: 200 }
            }
        }
    }

    ColumnLayout {
        id: contentLayout
        anchors { left: parent.left; right: parent.right; top: parent.top; leftMargin: isReply ? 48 : Theme.space16; rightMargin: Theme.space16; topMargin: Theme.space16 }
        spacing: 0
        
        RowLayout {
            Layout.fillWidth: true; spacing: Theme.space12; Layout.alignment: Qt.AlignTop
            
            ColumnLayout {
                id: leftColumn; Layout.alignment: Qt.AlignTop; Layout.preferredWidth: isReply ? 32 : Theme.avatarLarge; spacing: Theme.space8
                MiraAvatar {
                    userId: root.userId
                    username: root.username
                    avatarSource: root.avatarColor
                    size: isReply ? 32 : Theme.avatarLarge
                    clickable: true
                    // MiraAvatar handles click internally via mainWindow.openProfile
                }
                Item {
                    Layout.fillHeight: true; Layout.fillWidth: true; visible: root.showThreadLine
                    Rectangle { anchors.horizontalCenter: parent.horizontalCenter; width: Theme.threadLine; height: parent.height + Theme.space16; color: Theme.divider; opacity: 0.3 }
                }
            }
            
            ColumnLayout {
                Layout.fillWidth: true; spacing: 0; Layout.alignment: Qt.AlignTop
                
                RowLayout {
                    Layout.fillWidth: true; spacing: 4
                    visible: (root.postIndex % 5 == 2) // Simulate random AI suggestions
                    Item { width: 4 }
                    MiraIcon { name: "ai"; size: 12; color: Theme.aiAccent; active: true }
                    Text { text: qsTr("Suggested by MIRA AI"); color: Theme.aiAccent; font.pixelSize: 11; font.weight: Theme.weightBold; font.family: Theme.fontFamily }
                }
                
                RowLayout {
                    Layout.fillWidth: true; spacing: 4
                    Text { 
                        text: root.username; color: Theme.textPrimary; font.pixelSize: isReply ? 14 : Theme.fontUsername; font.weight: Theme.weightBold; font.family: Theme.fontFamily 
                        MouseArea { 
                            anchors.fill: parent; 
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (typeof mainWindow !== "undefined") mainWindow.openProfile(root.userId)
                            } 
                        } 
                    }
                    MiraIcon { visible: root.isVerified; name: "verified"; size: 14; color: Theme.premiumBlue }
                    // PLATINUM BADGE (PHASE 10)
                    MiraIcon { 
                        visible: Theme.isPlatinumUser && (root.username === authService.currentUser.username)
                        name: "verified"
                        size: 14; color: "#E5E4E2" 
                        active: true
                    }
                    Item { Layout.fillWidth: true }
                    Text { text: root.timestamp; color: Theme.textSecondary; font.pixelSize: 12; font.family: Theme.fontFamily }
                    Text { 
                        text: "⋯"; color: Theme.textSecondary; font.pixelSize: 18; Layout.leftMargin: Theme.space8 
                        MouseArea { anchors.fill: parent; onClicked: optionsSheet.open() }
                    }
                }
                
                Text {
                    Layout.fillWidth: true; Layout.topMargin: 2; text: root.content; color: Theme.textPrimary
                    font.pixelSize: isReply ? 14 : Theme.fontContent; font.family: Theme.fontFamily; wrapMode: Text.WordWrap; lineHeight: 1.2
                }

                // LINK PREVIEW - REMOVED
                
                // Media Component
                Item {
                    visible: root.mediaUrls.length > 0 || root.imageUrl !== "" || root.videoUrl !== ""
                    Layout.fillWidth: true
                    Layout.preferredHeight: visible ? 300 : 0
                    Layout.topMargin: 12
                    
                    Rectangle {
                        anchors.fill: parent
                        radius: 12
                        color: Theme.surface
                        clip: true
                        border.color: Theme.divider
                        border.width: 1

                        // Single Image
                        Image {
                            anchors.fill: parent
                            visible: root.imageUrl !== ""
                            source: root.imageUrl
                            fillMode: Image.PreserveAspectCrop
                        }

                        // Enhanced Video Player
                        Item {
                            anchors.fill: parent
                            visible: root.videoUrl !== ""

                            Video {
                                id: videoPlayer
                                anchors.fill: parent
                                source: root.videoUrl
                                fillMode: VideoOutput.PreserveAspectCrop
                                loops: MediaPlayer.Infinite
                                autoPlay: true
                                
                                onPlaybackStateChanged: {
                                    if (playbackState === MediaPlayer.PlayingState) {
                                        controlsOverlay.visible = false
                                    }
                                }
                            }

                            // Interaction Area
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                property int lastClickTime: 0
                                
                                onClicked: {
                                    controlsOverlay.visible = !controlsOverlay.visible
                                    if (controlsOverlay.visible) {
                                        hideTimer.restart()
                                    }
                                }

                                onDoubleClicked: (mouse) => {
                                    var seekAmount = 5000 // 5 seconds
                                    if (mouse.x > width / 2) {
                                        // Seek Forward
                                        videoPlayer.position = Math.min(videoPlayer.duration, videoPlayer.position + seekAmount)
                                        forwardAnimation.start()
                                    } else {
                                        // Seek Backward
                                        videoPlayer.position = Math.max(0, videoPlayer.position - seekAmount)
                                        backwardAnimation.start()
                                    }
                                }
                            }

                            // Visual Feeback Icons (Double Tap)
                            Item {
                                id: forwardIndicator
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.rightMargin: 40
                                opacity: 0
                                width: 60; height: 60
                                
                                Rectangle { anchors.fill: parent; radius: 30; color: Qt.rgba(0.1, 0.1, 0.1, 0.8) }
                                Column {
                                    anchors.centerIn: parent
                                    Text { text: "»"; color: "white"; font.pixelSize: 24; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "+5s"; color: "white"; font.pixelSize: 12; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                
                                SequentialAnimation {
                                    id: forwardAnimation
                                    NumberAnimation { target: forwardIndicator; property: "opacity"; from: 0; to: 1; duration: 200 }
                                    NumberAnimation { target: forwardIndicator; property: "opacity"; to: 0; duration: 200 }
                                }
                            }

                            Item {
                                id: backwardIndicator
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 40
                                opacity: 0
                                width: 60; height: 60
                                
                                Rectangle { anchors.fill: parent; radius: 30; color: Qt.rgba(0.1, 0.1, 0.1, 0.8) }
                                Column {
                                    anchors.centerIn: parent
                                    Text { text: "«"; color: "white"; font.pixelSize: 24; anchors.horizontalCenter: parent.horizontalCenter }
                                    Text { text: "-5s"; color: "white"; font.pixelSize: 12; anchors.horizontalCenter: parent.horizontalCenter }
                                }
                                
                                SequentialAnimation {
                                    id: backwardAnimation
                                    NumberAnimation { target: backwardIndicator; property: "opacity"; from: 0; to: 1; duration: 200 }
                                    NumberAnimation { target: backwardIndicator; property: "opacity"; to: 0; duration: 200 }
                                }
                            }

                            // Controls Overlay
                            Item {
                                id: controlsOverlay
                                anchors.fill: parent
                                visible: !videoPlayer.autoPlay

                                // Center Play/Pause Button
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 56; height: 56
                                    radius: 28
                                    color: Qt.rgba(0.1, 0.1, 0.1, 0.8)
                                    border.color: Theme.divider; border.width: 1
                                    
                                    MiraIcon {
                                        anchors.centerIn: parent
                                        name: videoPlayer.playbackState === MediaPlayer.PlayingState ? "pause" : "play"
                                        size: 24
                                        active: true
                                        color: "white"
                                    }
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if (videoPlayer.playbackState === MediaPlayer.PlayingState) {
                                                videoPlayer.pause()
                                                hideTimer.stop()
                                            } else {
                                                videoPlayer.play()
                                                hideTimer.restart()
                                            }
                                        }
                                    }
                                }

                                // Bottom Control Bar
                                Rectangle {
                                    anchors.bottom: parent.bottom
                                    width: parent.width
                                    height: 48
                                    gradient: Gradient {
                                        GradientStop { position: 0.0; color: "transparent" }
                                        GradientStop { position: 1.0; color: "#80000000" }
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 12
                                        spacing: 12

                                        Text {
                                            text: formatTime(videoPlayer.position)
                                            color: "white"
                                            font.pixelSize: 12
                                            font.weight: Font.Medium
                                        }

                                        Slider {
                                            Layout.fillWidth: true
                                            from: 0
                                            to: videoPlayer.duration
                                            value: videoPlayer.position
                                            onMoved: videoPlayer.position = value
                                            
                                            background: Rectangle {
                                                x: parent.leftPadding
                                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                                implicitWidth: 200
                                                implicitHeight: 4
                                                width: parent.availableWidth
                                                height: implicitHeight
                                                radius: 2
                                                color: "#40ffffff"
                                                
                                                Rectangle {
                                                    width: parent.parent.visualPosition * parent.width
                                                    height: parent.height
                                                    color: "white" // Minimalist white progress
                                                    radius: 2
                                                }
                                            }
                                            
                                            handle: Rectangle {
                                                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                                implicitWidth: 12
                                                implicitHeight: 12
                                                radius: 6
                                                color: "white"
                                                scale: parent.pressed ? 1.2 : 1.0
                                                Behavior on scale { NumberAnimation { duration: 100 } }
                                            }
                                        }

                                        Text {
                                            text: formatTime(videoPlayer.duration)
                                            color: "white"
                                            font.pixelSize: 12
                                            font.weight: Font.Medium
                                        }
                                        
                                        // Maximize Button
                                        Item {
                                            width: 24; height: 24
                                            MiraIcon { 
                                                anchors.centerIn: parent
                                                name: "maximize"
                                                size: 16
                                                color: "white"
                                                active: true
                                            }
                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: {
                                                    videoPlayer.pause()
                                                    fullscreenPopup.open()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Timer {
                                id: hideTimer
                                interval: 3000
                                repeat: false
                                onTriggered: {
                                    if (videoPlayer.playbackState === MediaPlayer.PlayingState) {
                                        controlsOverlay.visible = false
                                    }
                                }
                            }
                            
                            function formatTime(ms) {
                                var totalSeconds = Math.floor(ms / 1000)
                                var minutes = Math.floor(totalSeconds / 60)
                                var seconds = totalSeconds % 60
                                return minutes + ":" + (seconds < 10 ? "0" : "") + seconds
                            }
                        }
                        
                        // Fullscreen Popup
                        Popup {
                            id: fullscreenPopup
                            anchors.centerIn: Overlay.overlay
                            width: Overlay.overlay ? Overlay.overlay.width : Screen.width
                            height: Overlay.overlay ? Overlay.overlay.height : Screen.height
                            modal: true
                            focus: true
                            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                            background: Rectangle { color: "black" }
                            
                            onOpened: {
                                fsVideo.source = root.videoUrl
                                fsVideo.position = videoPlayer.position
                                fsVideo.play()
                            }
                            onClosed: {
                                fsVideo.stop()
                                videoPlayer.position = fsVideo.position
                                videoPlayer.play()
                            }
                            
                            Video {
                                id: fsVideo
                                anchors.fill: parent
                                fillMode: VideoOutput.PreserveAspectFit
                                
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (fsVideo.playbackState === MediaPlayer.PlayingState) fsVideo.pause(); else fsVideo.play()
                                    }
                                }
                                
                                // Close Button (Top Right)
                                Item {
                                    anchors.right: parent.right; anchors.top: parent.top
                                    anchors.margins: 20
                                    width: 40; height: 40
                                    z: 10
                                    Rectangle { anchors.fill: parent; radius: 20; color: "#60000000" }
                                    Text { anchors.centerIn: parent; text: "✕"; color: "white"; font.pixelSize: 20 }
                                    MouseArea { anchors.fill: parent; onClicked: fullscreenPopup.close() }
                                }
                            }
                        }

                        // QUOTED POST - REMOVED

                        // Carousel (Existing logic refined)
                        Flickable {
                            anchors.fill: parent
                            visible: root.mediaUrls.length > 0
                            contentWidth: mediaRow.implicitWidth
                            flickableDirection: Flickable.HorizontalFlick
                            boundsBehavior: Flickable.StopAtBounds
                            clip: true
                            
                            Row {
                                id: mediaRow; spacing: 8
                                Repeater {
                                    model: root.mediaUrls
                                    delegate: Rectangle {
                                        width: 320; height: 300; radius: 12; color: Theme.surface; clip: true
                                        Image { 
                                            anchors.fill: parent
                                            source: modelData
                                            fillMode: Image.PreserveAspectCrop 
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Phase 5: Reaction Bubbles (Telegram Style)
                Flow {
                    Layout.fillWidth: true
                    Layout.topMargin: (root.reactionSummary && root.reactionSummary !== "") ? 8 : 0
                    spacing: 6
                    visible: (root.reactionSummary && root.reactionSummary !== "")

                    Repeater {
                        model: {
                            if (!root.reactionSummary || root.reactionSummary === "") return []
                            var pairs = root.reactionSummary.split(",")
                            var result = []
                            for (var i = 0; i < pairs.length; i++) {
                                var parts = pairs[i].split(":")
                                if (parts.length === 2) {
                                    result.push({ "emoji": parts[0], "count": parseInt(parts[1]) })
                                }
                            }
                            return result
                        }
                        delegate: Rectangle {
                            height: 26; radius: 13
                            width: bubbleLayout.implicitWidth + 16
                            color: (root.reactionType === modelData.emoji) ? Theme.accent : Theme.surface
                            border.color: (root.reactionType === modelData.emoji) ? "transparent" : Theme.divider
                            border.width: 1
                            opacity: 0.9

                            RowLayout {
                                id: bubbleLayout
                                anchors.centerIn: parent
                                spacing: 4
                                Text { 
                                    text: modelData.emoji; font.pixelSize: 14 
                                }
                                Text { 
                                    text: modelData.count; font.pixelSize: 12
                                    font.weight: Theme.weightBold; color: (root.reactionType === modelData.emoji) ? "white" : Theme.textPrimary 
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (root.postIndex !== -1 && root.viewModel) {
                                        root.viewModel.react(root.postIndex, modelData.emoji)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Action Bar
                RowLayout {
                    Layout.topMargin: Theme.space12; Layout.fillWidth: true; spacing: 20
                    z: 50
                    
                    MiraIcon { 
                        name: "reply"; size: 18; active: true
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: {
                                if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                                if (root.viewModel) root.viewModel.requestReply(root.postIndex)
                            }
                        }
                    }
                    MiraIcon { 
                        name: "repost"; size: 18; active: true
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: {
                                if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                                if (root.viewModel) root.viewModel.repost(root.postIndex)
                                if (typeof nativeToast !== "undefined") nativeToast.show(qsTr("Thread reposted"), "success")
                            }
                        }
                    }
                    MiraIcon { 
                        name: "share"; size: 18; active: true
                        MouseArea { 
                            anchors.fill: parent
                            onClicked: {
                                if (typeof HapticManager !== "undefined") HapticManager.triggerSelection()
                                if (root.viewModel) root.viewModel.share(root.postIndex)
                                if (typeof nativeToast !== "undefined") nativeToast.show(qsTr("Link copied"), "success")
                            }
                        }
                    }
                    Item { Layout.fillWidth: true }
                }
            }
        }
    }
    
    ReactionPicker {
        id: reactionPicker
        anchors.centerIn: parent
        visible: false
        z: 999
        
        scale: visible ? 1.0 : 0.8
        opacity: visible ? 1.0 : 0.0
        
        Behavior on scale { NumberAnimation { duration: 400; easing.type: Theme.springEasing } }
        Behavior on opacity { NumberAnimation { duration: 200 } }

        onReactionSelected: (emoji) => {
            visible = false
            if (root.postIndex !== -1 && root.viewModel) {
                root.viewModel.react(root.postIndex, emoji)
            }
        }
    }

    ActionSheet {
        id: optionsSheet
        model: root.userId === (authService.currentUser ? authService.currentUser.id : -1) ? [
            { "label": qsTr("Edit"), "icon": "✎" },
            { "label": qsTr("Delete"), "icon": "🗑", "isDestructive": true },
            { "label": qsTr("Share"), "icon": "📤" }
        ] : [
            { "label": qsTr("Block"), "icon": "🚫", "isDestructive": true },
            { "label": qsTr("Report"), "icon": "🚩", "isDestructive": true },
            { "label": qsTr("Share"), "icon": "📤" }
        ]
        onItemClicked: (idx, label) => {
            if (label === qsTr("Delete")) {
                if (root.postIndex !== -1 && root.viewModel) root.viewModel.deletePost(root.postIndex)
            } else if (label === qsTr("Edit")) {
                editDialog.open()
            } else if (label === qsTr("Block")) {
                if (root.postIndex !== -1 && root.viewModel) root.viewModel.blockUser(root.postIndex)
            }
        }
    }

    Dialog {
        id: editDialog
        anchors.centerIn: parent
        width: parent.width * 0.9
        title: qsTr("Edit Post")
        modal: true
        standardButtons: Dialog.Save | Dialog.Cancel
        
        ColumnLayout {
            anchors.fill: parent
            TextArea {
                id: editArea
                Layout.fillWidth: true
                text: root.content
                wrapMode: TextArea.WordWrap
                focus: true
                background: Rectangle { 
                    implicitWidth: 200; implicitHeight: 40; 
                    color: Theme.surface; radius: 8; 
                    border.color: Theme.divider 
                }
                color: Theme.textPrimary
            }
        }
        onAccepted: {
            if (root.postIndex !== -1 && root.viewModel) {
                root.viewModel.editPost(root.postIndex, editArea.text)
            }
        }
    }
    
    Rectangle { anchors { left: parent.left; right: parent.right; bottom: parent.bottom } height: 1; color: Theme.divider; opacity: 0.2; visible: !isReply }
    
    Canvas {
        id: branchingLine; visible: isReply; anchors.left: parent.left; anchors.top: parent.top; width: 48; height: 32
        onPaint: { var ctx = getContext("2d"); ctx.reset(); ctx.strokeStyle = Theme.divider; ctx.lineWidth = 1.5; ctx.globalAlpha = 0.3; ctx.beginPath(); ctx.moveTo(24, 0); ctx.bezierCurveTo(24, 16, 24, 24, 40, 24); ctx.stroke(); }
    }

    function formatTime(milliseconds) {
        var seconds = Math.floor(milliseconds / 1000);
        var minutes = Math.floor(seconds / 60);
        seconds = seconds % 60;
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    }
}
