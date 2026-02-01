import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects 
import "../"

Button {
    id: control
    
    property string textContent: "Button"
    property bool isPrimary: true
    property bool isDangerous: false
    property var clickAction: function() {} // Callback

    width: implicitWidth
    height: 44
    implicitWidth: label.implicitWidth + 40

    background: Rectangle {
        id: bgRect
        radius: height / 2
        color: {
            if (control.isDangerous) return "transparent"
            if (control.isPrimary) return Constants.textPrimary
            return "transparent"
        }
        
        border.width: control.isPrimary ? 0 : 1
        border.color: control.isDangerous ? Constants.danger : Constants.divider
        
        // Ripple effect simulation using OpacityAnimator
        Rectangle {
            id: ripple
            anchors.centerIn: parent
            width: 0 
            height: 0
            radius: width/2
            color: control.isPrimary ? "black" : "white"
            opacity: 0.2
            
            ParallelAnimation {
                id: rippleAnim
                NumberAnimation { target: ripple; property: "width"; to: control.width * 1.5; duration: 300 }
                NumberAnimation { target: ripple; property: "height"; to: control.width * 1.5; duration: 300 }
                OpacityAnimator { target: ripple; from: 0.2; to: 0; duration: 300 }
                onFinished: { ripple.width = 0; ripple.height = 0; }
            }
        }
    }

    contentItem: Text {
        id: label
        text: control.textContent
        font.pixelSize: Constants.fontBody
        font.weight: Constants.weightBold
        color: {
            if (control.isDangerous) return Constants.danger
            if (control.isPrimary) return Constants.background
            return Constants.textPrimary
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    // Scale animation on press
    scale: control.down ? 0.96 : 1.0
    Behavior on scale { NumberAnimation { duration: 100 } }

    onClicked: {
        rippleAnim.start()
        control.clickAction()
    }
}
