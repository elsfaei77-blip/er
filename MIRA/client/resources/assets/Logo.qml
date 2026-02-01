import QtQuick 2.15
import QtQuick.Shapes 1.15
import "."

Item {
    id: root
    width: 60
    height: 60
    
    property color color: Constants.neonBlue
    property bool glowing: true
    
    Shape {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        
        // The M Shape from the image: Two vertical lines, meeting in middle
        // It looks like |\/| but sharper.
        ShapePath {
            strokeColor: root.color
            strokeWidth: 3
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            
            startX: 10; startY: 50
            PathLine { x: 10; y: 10 } // Left Up
            PathLine { x: 30; y: 35 } // Middle Down
            PathLine { x: 50; y: 10 } // Right Up
            PathLine { x: 50; y: 50 } // Right Down
        }
    }
    
    // Simple Glow Attempt (Layering)
    Shape {
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        visible: root.glowing
        opacity: 0.5
        layer.enabled: true
        // In Qt5/6 without GraphicalEffects, simple opacity layering acts as poor man's glow
        // or just drawing it again with wider stroke
        
        ShapePath {
            strokeColor: root.color
            strokeWidth: 6
            fillColor: "transparent"
            startX: 10; startY: 50
            PathLine { x: 10; y: 10 }
            PathLine { x: 30; y: 35 }
            PathLine { x: 50; y: 10 }
            PathLine { x: 50; y: 50 }
        }
    }
}
