import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import MiraApp
import "../components"

Rectangle {
    id: chatRoot
    color: "transparent" // Let Nebula background show through
    
    property var chatPartner: ({ "username": "zuck", "avatarColor": Theme.accent })
    
    MessageModel {
        id: messageModel
        partnerId: chatRoot.chatPartner.id || 0
        onPartnerIdChanged: refresh()
    }
    
    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: messageModel.refresh()
    }
    


    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Chat Header
        Item {
            Layout.fillWidth: true; Layout.preferredHeight: Theme.headerHeight
            z: 100
            
            Rectangle {
                anchors.fill: parent
                color: Theme.surface // Glassy
            }
            
            RowLayout {
                anchors.fill: parent; anchors.leftMargin: Theme.space8; anchors.rightMargin: Theme.space16
                Item {
                    width: 48; height: 48
                    MiraIcon { 
                        anchors.centerIn: parent; name: "back"; size: 22; color: Theme.textPrimary; active: true 
                        onClicked: mainStack.pop()
                    }
                    MouseArea { anchors.fill: parent; onClicked: mainStack.pop() }
                }
                MiraAvatar {
                    userId: chatRoot.chatPartner.id || 0
                    username: chatRoot.chatPartner.username
                    avatarSource: chatRoot.chatPartner.avatarColor
                    size: 38
                    clickable: true
                }
                ColumnLayout {
                    spacing: 0
                    Text { text: chatPartner.username; color: Theme.textPrimary; font.weight: Theme.weightBold; font.pixelSize: 15; font.family: Theme.fontFamily }
                    RowLayout {
                        spacing: 4
                        Rectangle { width: 6; height: 6; radius: 3; color: "#4CAF50" }
                        Text { text: qsTr("Active now"); color: Theme.textSecondary; font.pixelSize: 11; font.family: Theme.fontFamily }
                    }
                }
                Item { Layout.fillWidth: true }
                MiraIcon { name: "verified"; size: 18; active: true; color: Theme.accent }
            }
            Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }
        }
        
        // Chat Area
        ListView {
            id: chatList
            Layout.fillWidth: true; Layout.fillHeight: true; model: messageModel
            clip: true; spacing: 16; Layout.leftMargin: 20; Layout.rightMargin: 20; boundsBehavior: Flickable.StopAtBounds
            
            delegate: Item {
                width: chatList.width; height: msgBubble.height + (model.reaction !== "" ? 20 : 0)
                
                Rectangle {
                    id: msgBubble
                    anchors.right: model.sentByUser ? parent.right : undefined
                    anchors.left: model.sentByUser ? undefined : parent.left
                    width: Math.min(chatList.width * 0.75, msgText.implicitWidth + 32)
                    height: msgText.implicitHeight + 20
                    radius: 20
                    color: model.sentByUser ? Theme.accent : Theme.surface
                    border.color: model.sentByUser ? "transparent" : Theme.divider
                    border.width: model.sentByUser ? 0 : 1
                    
                    // Message Entry Animation (PHASE 10: Spark Inclusion)
                    opacity: 0
                    transform: Translate { id: msgTranslate; y: 15 }
                    SequentialAnimation {
                        id: msgEntryAnim
                        PauseAnimation { duration: 50 } 
                        ParallelAnimation {
                            NumberAnimation { target: msgBubble; property: "opacity"; to: 1; duration: Theme.animNormal; easing.type: Theme.luxuryEasing }
                            NumberAnimation { target: msgTranslate; property: "y"; to: 0; duration: Theme.animNormal; easing.type: Theme.luxuryEasing }
                            SequentialAnimation {
                                NumberAnimation { target: sparkGlow; property: "opacity"; from: 0; to: 0.6; duration: 200 }
                                NumberAnimation { target: sparkGlow; property: "opacity"; to: 0; duration: 800 }
                            }
                        }
                    }
                    Component.onCompleted: msgEntryAnim.start()

                    RectangularGlow {
                        id: sparkGlow
                        anchors.fill: parent
                        glowRadius: 15
                        spread: 0.2
                        color: model.sentByUser ? Theme.accent : Theme.surfaceAccent
                        cornerRadius: msgBubble.radius
                        opacity: 0
                        z: -1
                    }

                    Text {
                        id: msgText; anchors.centerIn: parent; width: parent.width - 32
                        text: model.text; color: model.sentByUser ? Theme.background : Theme.textPrimary
                        font.pixelSize: 15; wrapMode: Text.WordWrap; font.family: Theme.fontFamily; lineHeight: 1.2
                    }
                    
                    // Reaction Indicator
                    Rectangle {
                        visible: model.reaction !== ""
                        anchors.bottom: parent.bottom; anchors.bottomMargin: -12
                        anchors.right: model.sentByUser ? parent.right : undefined
                        anchors.left: model.sentByUser ? undefined : parent.left
                        width: 24; height: 24; radius: 12; color: Theme.surfaceElevated; border.color: Theme.divider
                        Text { anchors.centerIn: parent; text: model.reaction; font.pixelSize: 14 }
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onPressAndHold: {
                            if (model.sentByUser) {
                                msgOptionsSheet.targetIdx = index
                                msgOptionsSheet.open()
                            } else {
                                // For received, only react
                                picker.targetIdx = index
                                picker.open()
                            }
                        }
                    }
                }
            }
        }
        
        // Input Bar (PHASE 9: Fluid Expansion)
        Rectangle {
            id: inputContainer
            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(Math.max(72, inputRow.implicitHeight + 28), 200)
            color: Theme.surface // Glassy
            
            Behavior on Layout.preferredHeight {
                NumberAnimation { duration: 250; easing.type: Theme.springEasing }
            }

            Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: Theme.divider; opacity: 0.5 }
            
            RowLayout {
                id: inputRow
                anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 16; spacing: 12
                Layout.alignment: Qt.AlignBottom
                
                MiraIcon {
                    name: "camera"
                    size: 24
                    color: Theme.textSecondary
                    active: true
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: 24
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.max(44, msgInput.implicitHeight + 12)
                    radius: 22; 
                    color: Theme.surface
                    border.color: Theme.divider; border.width: 1
                    Layout.alignment: Qt.AlignBottom
                    Layout.bottomMargin: 14
                    
                    RowLayout {
                        anchors.fill: parent; anchors.leftMargin: 16; anchors.rightMargin: 12
                        TextArea { 
                            id: msgInput
                            Layout.fillWidth: true
                            placeholderText: qsTr("Message..."); 
                            placeholderTextColor: Theme.textTertiary
                            color: Theme.textPrimary
                            background: null
                            font.pixelSize: 15; font.family: Theme.fontFamily 
                            wrapMode: TextArea.Wrap
                            verticalAlignment: TextArea.AlignVCenter
                        }
                        
                        MiraIcon {
                            name: msgInput.text.length > 0 ? "arrow_up" : "mic"
                            size: 20
                            color: msgInput.text.length > 0 ? Theme.accent : Theme.textSecondary
                            active: true
                            Layout.alignment: Qt.AlignBottom
                            Layout.bottomMargin: 12
                            onClicked: {
                                if (msgInput.text.length > 0) {
                                    messageModel.sendMessage(msgInput.text);
                                    msgInput.text = "";
                                    if (typeof HapticManager !== "undefined") HapticManager.triggerImpactMedium()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Global Message Options
    ActionSheet {
        id: msgOptionsSheet
        property int targetIdx: -1
        model: [
            { "label": qsTr("Edit"), "icon": "✎" },
            { "label": qsTr("Delete"), "icon": "🗑", "isDestructive": true },
            { "label": qsTr("React"), "icon": "☺" }
        ]
        onItemClicked: (idx, label) => {
            if (label === qsTr("Delete")) {
                messageModel.deleteMessage(targetIdx)
            } else if (label === qsTr("Edit")) {
                editMsgArea.text = messageModel.data(messageModel.index(targetIdx, 0), 258 /* ContentRole is Qt::UserRole + 2? No, check Roles in header */)
                // Wait, it's safer to just get it from the model if we know the role name.
                // In QML, model properties like 'text' are directly accessible in delegate but not here easily.
                // I'll provide a helper if needed or just use index.
                editMsgDialog.targetIdx = targetIdx
                editMsgDialog.open()
            } else if (label === qsTr("React")) {
                picker.targetIdx = targetIdx
                picker.open()
            }
        }
    }

    Dialog {
        id: editMsgDialog
        anchors.centerIn: parent
        width: parent.width * 0.9
        title: qsTr("Edit Message")
        modal: true
        standardButtons: Dialog.Save | Dialog.Cancel
        property int targetIdx: -1
        
        ColumnLayout {
            anchors.fill: parent
            TextArea {
                id: editMsgArea
                Layout.fillWidth: true
                wrapMode: TextArea.WordWrap
                focus: true
                background: Rectangle { color: Theme.surface; radius: 8 }
                color: Theme.textPrimary
            }
        }
        onAccepted: {
            if (targetIdx !== -1) {
                messageModel.editMessage(targetIdx, editMsgArea.text)
            }
        }
    }

    // Global Reaction Picker
    ReactionPicker {
        id: picker; visible: opacity > 0
        property int targetIdx: -1
        onReactionSelected: (emoji) => {
            messageModel.addReaction(targetIdx, emoji);
            picker.opacity = 0; // Quick hide
        }
    }
}
