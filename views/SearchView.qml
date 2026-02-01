import QtQuick 2.15
import "../"

Item {
    Rectangle {
        anchors.fill: parent
        color: Constants.background
        
        Text {
            anchors.centerIn: parent
            text: "Search/Explore\n(Placeholder)"
            color: Constants.textSecondary
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
