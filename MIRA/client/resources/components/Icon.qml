import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    id: root
    property string pathData: ""
    property color color: "white"
    
    // Scale the generic 24x24 viewBox to current size
    // Implicit assumption: pathData is roughly 24x24 unit based
    property real originalSize: 24
    
    width: 24
    height: 24
    
    Shape {
        anchors.fill: parent
        // Use ShapePath to render the string
        ShapePath {
            strokeWidth: 0
            fillColor: root.color
            PathSvg { path: root.pathData }
        }
        
        // Scale logic handled by the Shape automatically? 
        // No, PathSvg uses the raw coordinates. We need to scale.
        // Easiest is to scale the whole Item or Shape
        scale: Math.min(root.width / root.originalSize, root.height / root.originalSize)
        anchors.centerIn: parent
    }
}
