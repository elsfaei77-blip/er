import QtQuick 2.15
import QtQuick.Controls 2.15
import "../assets"
import "../"

Item {
    id: root
    width: 40
    height: 40
    
    property string iconPath: ""
    property color iconColor: Constants.textPrimary
    property alias mouseArea: ma
    
    signal clicked()
    
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: width / 2
        
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: Constants.neonBlue
            opacity: ma.pressed ? 0.2 : (ma.containsMouse ? 0.1 : 0)
        }
    }
    
    Icon {
        anchors.centerIn: parent
        pathData: iconPath
        color: root.iconColor
        width: 24
        height: 24
    }
    
    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
