import QtQuick
import QtQuick.Shapes
import MiraApp

Item {
    id: root
    width: 40; height: 40
    
    property bool refreshing: false
    property real pullProgress: 0.0
    property color color: Theme.textPrimary
    property color glowColor: Theme.accent
    
    property real animVal: 0.0
    
    // Base Logo Shape (Always visible)
    Shape {
        anchors.fill: parent
        anchors.margins: 4
        layer.enabled: true
        layer.samples: 8
        
        ShapePath {
            strokeWidth: 3
            strokeColor: root.color
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            
            startX: 6; startY: 28
            PathLine { x: 6; y: 6 }
            PathLine { x: 16; y: 18 }
            PathLine { x: 26; y: 6 }
            PathLine { x: 26; y: 28 }
        }
    }
    
    // Worm/Glow Effect Shape (Conditional)
    Shape {
        anchors.fill: parent
        anchors.margins: 4
        layer.enabled: true
        layer.samples: 8
        visible: root.refreshing || root.pullProgress > 0.1
        
        ShapePath {
            strokeWidth: 3
            strokeColor: root.glowColor
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            
            strokeStyle: ShapePath.DashLine
            dashPattern: [10, 20]
            dashOffset: -root.animVal
            
            startX: 6; startY: 28
            PathLine { x: 6; y: 6 }
            PathLine { x: 16; y: 18 }
            PathLine { x: 26; y: 6 }
            PathLine { x: 26; y: 28 }
        }
    }
    
    // Animation Driver
    NumberAnimation {
        id: flowAnim
        target: root
        property: "animVal"
        from: 0
        to: 30
        duration: 1200
        running: root.refreshing || root.pullProgress > 0.05
        loops: Animation.Infinite
    }
}

