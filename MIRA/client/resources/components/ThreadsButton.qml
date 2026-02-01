// ThreadsButton.qml - Exact Threads button component
import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: control
    
    // Properties matching Threads button API
    property bool primary: false
    property bool outline: false
    property bool danger: false
    property int size: ThreadsConstants.buttonHeight
    
    width: implicitWidth
    height: size
    implicitWidth: Math.max(100, contentItem.implicitWidth + leftPadding + rightPadding)
    
    leftPadding: ThreadsConstants.spacing4
    rightPadding: ThreadsConstants.spacing4
    
    // Smooth press animation
    scale: down ? 0.97 : 1.0
    Behavior on scale { NumberAnimation { duration: ThreadsConstants.animationFast } }
    
    background: Rectangle {
        radius: ThreadsConstants.radiusFull
        color: {
            if (control.danger) return ThreadsConstants.error
            if (control.primary) return ThreadsConstants.textPrimary
            if (control.outline) return "transparent"
            return ThreadsConstants.surface
        }
        
        border.width: control.outline ? 1 : 0
        border.color: ThreadsConstants.border
        
        // Pressed state overlay
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: control.down ? ThreadsConstants.pressedOverlay : "transparent"
        }
    }
    
    contentItem: Text {
        text: control.text
        font.family: ThreadsConstants.fontFamily
        font.pixelSize: ThreadsConstants.fontBody
        font.weight: ThreadsConstants.weightSemiBold
        color: {
            if (control.danger) return ThreadsConstants.background
            if (control.primary) return ThreadsConstants.background
            return ThreadsConstants.textPrimary
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
