import QtQuick 2.15

Rectangle {
    id: root
    anchors.fill: parent
    
    // Deep Space Background
    gradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop { position: 0.0; color: "#050510" } // Deep Midnight Blue
        GradientStop { position: 1.0; color: "#0B0B1E" } // Slightly lighter deep blue
    }

    // Nebula Effect (Radial Gradients)
    Rectangle {
        width: parent.width * 1.5
        height: width
        radius: width / 2
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -parent.height * 0.3
        opacity: 0.4
        
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#4CC9F0" } // Cyan
            GradientStop { position: 1.0; color: "transparent" }
        }
        rotation: 45
    }

    Rectangle {
        width: parent.width * 1.2
        height: width
        radius: width / 2
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: -width * 0.3
        opacity: 0.3
        
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "#F72585" } // Magenta/Purple
            GradientStop { position: 1.0; color: "transparent" }
        }
    }
    
    // Stars (Optional: Simple random dots could be added here via Repeater if needed, 
    // but keeping it clean for now)
}
