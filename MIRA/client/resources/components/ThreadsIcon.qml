// ThreadsIcon.qml - Icon component for Threads
import QtQuick 2.15

Item {
    id: root
    
    property string icon: ""
    property color color: ThreadsConstants.textPrimary
    property int size: ThreadsConstants.iconMedium
    
    width: size
    height: size
    
    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            // Scale to fit the icon size
            var scale = size / 24 // Icons are 24x24 by default
            ctx.scale(scale, scale)
            
            // Set drawing properties
            ctx.strokeStyle = root.color
            ctx.lineWidth = 1.5
            ctx.lineCap = "round"
            ctx.lineJoin = "round"
            ctx.fillStyle = root.color
            
            // Parse and draw the SVG path
            // This is a simplified version - for production use Qt SVG
            if (icon !== "") {
                var path = new Path2D(icon)
                ctx.fill(path)
            }
        }
    }
    
    // Redraw when properties change
    onIconChanged: requestPaint()
    onColorChanged: requestPaint()
    
    function requestPaint() {
        // Find the canvas child and trigger repaint
        for (var i = 0; i < children.length; i++) {
            if (children[i].toString().indexOf("Canvas") >= 0) {
                children[i].requestPaint()
            }
        }
    }
}
