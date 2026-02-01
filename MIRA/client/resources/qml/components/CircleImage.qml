import QtQuick

Item {
    id: root
    property alias source: img.source
    property alias sourceSize: img.sourceSize
    property alias fillMode: img.fillMode
    property alias status: img.status
    property alias img: img

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        clip: true
        color: "transparent"

        Image {
            id: img
            anchors.fill: parent
        }
    }
}
