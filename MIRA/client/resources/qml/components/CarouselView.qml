import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Item {
    id: root
    width: parent.width
    height: width // Square aspect ratio
    
    property var imageUrls: []
    property int currentIndex: 0
    
    clip: true
    
    // Main swipeable view
    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: root.currentIndex
        onCurrentIndexChanged: root.currentIndex = currentIndex
        
        Repeater {
            model: root.imageUrls
            
            Rectangle {
                width: swipeView.width
                height: swipeView.height
                color: Theme.surface
                
                Image {
                    anchors.fill: parent
                    source: modelData
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: true
                    
                    // Loading indicator
                    BusyIndicator {
                        anchors.centerIn: parent
                        running: parent.status === Image.Loading
                        visible: running
                    }
                    
                    // Error state
                    Text {
                        anchors.centerIn: parent
                        visible: parent.status === Image.Error
                        text: qsTr("Failed to load image")
                        color: Theme.textSecondary
                        font.pixelSize: 14
                    }
                }
            }
        }
    }
    
    // Page indicators (dots)
    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 12
        spacing: 6
        visible: root.imageUrls.length > 1
        
        Repeater {
            model: root.imageUrls.length
            
            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: index === root.currentIndex ? "white" : Qt.rgba(1, 1, 1, 0.5)
                
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }
                
                // Drop shadow for visibility
                layer.enabled: true
                layer.effect: DropShadow {
                    color: Qt.rgba(0, 0, 0, 0.3)
                    radius: 4
                    samples: 8
                }
            }
        }
    }
    
    // Image counter badge
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 12
        width: counterText.implicitWidth + 16
        height: 24
        radius: 12
        color: Qt.rgba(0, 0, 0, 0.6)
        visible: root.imageUrls.length > 1
        
        Text {
            id: counterText
            anchors.centerIn: parent
            text: (root.currentIndex + 1) + "/" + root.imageUrls.length
            color: "white"
            font.pixelSize: 12
            font.weight: Font.Bold
        }
    }
    
    // Navigation arrows (optional, for desktop)
    MouseArea {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 3
        visible: root.currentIndex > 0
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            if (root.currentIndex > 0) {
                swipeView.decrementCurrentIndex()
            }
        }
        
        Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 8
            width: 32
            height: 32
            radius: 16
            color: Qt.rgba(0, 0, 0, 0.5)
            visible: parent.containsMouse
            
            Text {
                anchors.centerIn: parent
                text: "‹"
                color: "white"
                font.pixelSize: 24
                font.bold: true
            }
        }
    }
    
    MouseArea {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width / 3
        visible: root.currentIndex < root.imageUrls.length - 1
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            if (root.currentIndex < root.imageUrls.length - 1) {
                swipeView.incrementCurrentIndex()
            }
        }
        
        Rectangle {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 8
            width: 32
            height: 32
            radius: 16
            color: Qt.rgba(0, 0, 0, 0.5)
            visible: parent.containsMouse
            
            Text {
                anchors.centerIn: parent
                text: "›"
                color: "white"
                font.pixelSize: 24
                font.bold: true
            }
        }
    }
}
