import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp

Rectangle {
    id: root
    width: parent.width
    height: 60
    radius: 30
    color: isOwnMessage ? Theme.accent : Theme.surface
    
    property bool isOwnMessage: false
    property int duration: 0 // in seconds
    property bool isPlaying: false
    property real playProgress: 0.0
    
    signal playClicked()
    signal pauseClicked()
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12
        
        // Play/Pause button
        Rectangle {
            Layout.preferredWidth: 36
            Layout.preferredHeight: 36
            radius: 18
            color: isOwnMessage ? "white" : Theme.accent
            
            MiraIcon {
                anchors.centerIn: parent
                name: root.isPlaying ? "pause" : "play"
                size: 16
                color: isOwnMessage ? Theme.accent : "white"
            }
            
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (root.isPlaying) {
                        root.pauseClicked()
                    } else {
                        root.playClicked()
                    }
                }
            }
        }
        
        // Waveform visualization
        Canvas {
            id: waveformCanvas
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                
                var barCount = 30
                var barWidth = width / barCount
                var color = isOwnMessage ? "white" : Theme.accent
                
                ctx.fillStyle = color
                
                for (var i = 0; i < barCount; i++) {
                    var barHeight = Math.random() * height * 0.8 + height * 0.2
                    var x = i * barWidth
                    var y = (height - barHeight) / 2
                    
                    // Highlight played portion
                    if (i / barCount < root.playProgress) {
                        ctx.globalAlpha = 1.0
                    } else {
                        ctx.globalAlpha = 0.3
                    }
                    
                    ctx.fillRect(x + 1, y, barWidth - 2, barHeight)
                }
            }
            
            Connections {
                target: root
                function onPlayProgressChanged() {
                    waveformCanvas.requestPaint()
                }
            }
        }
        
        // Duration
        Text {
            text: formatDuration(root.duration)
            color: isOwnMessage ? "white" : Theme.textPrimary
            font.pixelSize: 12
            font.weight: Font.Medium
        }
    }
    
    function formatDuration(seconds) {
        var mins = Math.floor(seconds / 60)
        var secs = seconds % 60
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }
}
