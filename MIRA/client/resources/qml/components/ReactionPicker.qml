import QtQuick
import QtQuick.Layouts
import MiraApp

Rectangle {
    id: root
    width: 200; height: 44; radius: 22
    color: Theme.surfaceElevated
    border.color: Theme.divider; border.width: 1
    
    signal reactionSelected(string emoji)
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 0
        
        Repeater {
            model: ["❤️", "🙌", "🔥", "👏", "😢", "😮"]
            delegate: Item {
                id: delegateRoot
                Layout.fillWidth: true; Layout.fillHeight: true
                
                property real itemScale: 0
                opacity: itemScale
                
                Text {
                    anchors.centerIn: parent
                    text: modelData
                    font.pixelSize: 22
                    scale: (ma.containsMouse ? 1.4 : 1.0) * delegateRoot.itemScale
                    
                    Behavior on scale { 
                        NumberAnimation { 
                            duration: Theme.animNormal
                            easing.type: Theme.springEasing
                            easing.amplitude: Theme.springOvershoot
                        } 
                    }
                }
                
                SequentialAnimation {
                    id: staggeredEntry
                    PauseAnimation { duration: index * Theme.staggerDelay }
                    NumberAnimation { 
                        target: delegateRoot; property: "itemScale"; from: 0; to: 1.0; 
                        duration: Theme.animNormal; easing.type: Theme.springEasing 
                    }
                }
                
                Connections {
                    target: root
                    function onOpened() { staggeredEntry.start() }
                }

                MouseArea {
                    id: ma
                    anchors.fill: parent; hoverEnabled: true
                    onClicked: root.reactionSelected(modelData)
                }
            }
        }
    }
    
    // Appear animation
    scale: 0; opacity: 0
    signal opened()
    
    ParallelAnimation {
        id: appearAnim
        NumberAnimation { target: root; property: "scale"; from: 0.8; to: 1.0; duration: Theme.animNormal; easing.type: Theme.springEasing }
        NumberAnimation { target: root; property: "opacity"; from: 0; to: 1.0; duration: Theme.animNormal }
        onStarted: root.opened()
    }
    
    function open() { appearAnim.start() }
}
