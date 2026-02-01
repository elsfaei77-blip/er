import QtQuick
import QtQuick.Layouts
import MiraApp

Item {
    id: root
    width: parent.width
    height: 60
    anchors.top: parent.top
    anchors.topMargin: 50
    z: 1000

    property string message: ""
    property string type: "success" // success, error, warning

    function show(msg, toastType = "success") {
        message = msg
        type = toastType
        anim.restart()
        if (typeof HapticManager !== "undefined") {
            if (type === "success") HapticManager.triggerNotificationSuccess()
            else if (type === "error") HapticManager.triggerNotificationError()
            else HapticManager.triggerNotificationWarning()
        }
    }

    Rectangle {
        id: toastRect
        anchors.horizontalCenter: parent.horizontalCenter
        width: Math.min(parent.width - 40, contentRow.implicitWidth + 40)
        height: 50
        radius: 25
        color: Theme.toastBackground
        border.color: Theme.divider
        border.width: 1
        opacity: 0
        scale: 0.8

        RowLayout {
            id: contentRow
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: type === "success" ? "✅" : (type === "error" ? "❌" : "⚠️")
                font.pixelSize: 16
            }

            Text {
                text: root.message
                color: Theme.textPrimary
                font.pixelSize: 15
                font.weight: Theme.weightMedium
            }
        }
    }

    SequentialAnimation {
        id: anim
        ParallelAnimation {
            NumberAnimation { target: toastRect; property: "opacity"; from: 0; to: 1; duration: 400; easing.type: Easing.OutExpo }
            NumberAnimation { target: toastRect; property: "scale"; from: 0.8; to: 1; duration: 400; easing.type: Easing.OutBack }
            NumberAnimation { target: toastRect; property: "anchors.topMargin"; from: 30; to: 50; duration: 400; easing.type: Easing.OutExpo }
        }
        PauseAnimation { duration: 2500 }
        ParallelAnimation {
            NumberAnimation { target: toastRect; property: "opacity"; to: 0; duration: 400; easing.type: Easing.InExpo }
            NumberAnimation { target: toastRect; property: "scale"; to: 0.8; duration: 400; easing.type: Easing.InExpo }
        }
    }
}
