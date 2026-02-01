import QtQuick 2.15
import QtQuick.Controls 2.15
import "../"

Button {
    id: control
    
    property string source
    property int size: 24
    property color iconColor: Constants.textPrimary

    background: Item {} // Transparent background

    contentItem: Image {
        source: control.source
        sourceSize.width: control.size
        sourceSize.height: control.size
        fillMode: Image.PreserveAspectFit
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter
        opacity: control.down ? 0.7 : 1.0
        
        // Use ColorOverlay if you need to recolor SVGs or masks (requires GraphicalEffects)
        // For simplicity in standard QML, we assume white/colored icons or use basic tinting if supported.
        // Since "only qml" is requested and GraphicalEffects can be tricky with versions, 
        // we'll stick to Image for now. If user provides SVGs, modern Qt supports 'color' property on Image in some versions,
        // or we can just rely on the image source being correct. 
        // Let's assume the user will provide icons. I will use a placeholder text if image is missing?
        // Actually, let's use Text based generic icons (Unicode) for 'No Assets' approach to ensure it works out of the box.
    }
    
    // Fallback: If no image source, use a Unicode character if provided? 
    // Let's just make it purely an Image button for now, but I'll add a Rectangle placeholder if source is empty.
    
    Rectangle {
        visible: control.source === ""
        anchors.centerIn: parent
        width: control.size
        height: control.size
        color: "transparent"
        border.color: control.iconColor
        border.width: 1
        radius: 4
        
        Text {
            anchors.centerIn: parent
            text: "?"
            color: control.iconColor
            font.pixelSize: control.size * 0.6
        }
    }
}
