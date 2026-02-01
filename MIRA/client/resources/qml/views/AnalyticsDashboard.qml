import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import MiraApp
import "../components"

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent" // Let NebulaBackground show through
    
    // Glass Background for improved readability over Nebula
    Rectangle {
        anchors.fill: parent
        color: Theme.background
        opacity: 0.85
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Header
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.headerHeight
            color: "transparent"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                
                MiraIcon {
                    name: "back"
                    size: 24
                    color: Theme.textPrimary
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mainStack.pop()
                    }
                }
                
                Text {
                    Layout.fillWidth: true
                    text: qsTr("Professional Dashboard")
                    color: Theme.textPrimary
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    horizontalAlignment: Text.AlignHCenter
                }
                
                MiraIcon {
                    name: "share"
                    size: 24
                    color: Theme.textPrimary
                }
            }
        }
        
        // Content
        Flickable {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentHeight: contentColumn.implicitHeight + 40
            clip: true
            
            ColumnLayout {
                id: contentColumn
                width: parent.width
                spacing: 24
                
                // Key Metrics (Glass Cards)
                GridLayout {
                    Layout.fillWidth: true
                    Layout.margins: 16
                    columns: 2
                    rowSpacing: 16
                    columnSpacing: 16
                    
                    Repeater {
                        model: [
                            { title: qsTr("Accounts Reached"), value: "12.5K", change: "+15%", color: Theme.accent, icon: "analytics" },
                            { title: qsTr("Engagement"), value: "8.2K", change: "+22%", color: Theme.purple, icon: "heart" },
                            { title: qsTr("Total Followers"), value: "3,402", change: "+1.2%", color: Theme.blue, icon: "user_plus" },
                            { title: qsTr("Content Shared"), value: "156", change: "+12", color: Theme.pink, icon: "share" }
                        ]
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 110
                            radius: 24
                            color: Theme.glassBackground
                            border.color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.3)
                            border.width: 1
                            
                            // Glow effect
                            Rectangle {
                                anchors.fill: parent
                                radius: 24
                                color: modelData.color
                                opacity: 0.05
                            }
                            
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 8
                                
                                RowLayout {
                                    Layout.fillWidth: true
                                    MiraIcon {
                                        name: modelData.icon
                                        size: 20
                                        color: modelData.color
                                        active: true
                                    }
                                    
                                    Item { Layout.fillWidth: true }
                                    
                                    Rectangle {
                                        width: changeText.implicitWidth + 12
                                        height: 20
                                        radius: 10
                                        color: Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.2)
                                        
                                        Text {
                                            id: changeText
                                            anchors.centerIn: parent
                                            text: modelData.change
                                            color: modelData.color
                                            font.pixelSize: 11
                                            font.weight: Font.Bold
                                        }
                                    }
                                }
                                
                                Text {
                                    text: modelData.value
                                    color: Theme.textPrimary
                                    font.pixelSize: 28
                                    font.weight: Font.Bold
                                }
                                
                                Text {
                                    text: modelData.title
                                    color: Theme.textSecondary
                                    font.pixelSize: 13
                                }
                            }
                        }
                    }
                }
                
                // Neon Chart Section
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
                    Layout.margins: 16
                    radius: 24
                    color: Theme.glassBackground
                    border.color: Theme.glassBorder
                    border.width: 1
                    clip: true
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16
                        
                        RowLayout {
                            Layout.fillWidth: true
                            Text {
                                text: qsTr("Growth Performance")
                                color: Theme.textPrimary
                                font.pixelSize: 16
                                font.weight: Font.Bold
                            }
                            Item { Layout.fillWidth: true }
                            Text {
                                text: "Last 30 Days"
                                color: Theme.textTertiary
                                font.pixelSize: 12
                            }
                        }
                        
                        // Bezier Chart Canvas
                        Canvas {
                            id: chart
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            antialiasing: true
                            
                            property var dataPoints: [20, 45, 30, 60, 55, 80, 70, 95]
                            property color lineColor: Theme.accent
                            
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                
                                var w = width;
                                var h = height;
                                var step = w / (dataPoints.length - 1);
                                var maxVal = 100; // fit to scale
                                
                                // Create Gradient Fill
                                var gradient = ctx.createLinearGradient(0, 0, 0, h);
                                gradient.addColorStop(0, Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 0.4));
                                gradient.addColorStop(1, "transparent");
                                
                                // Draw Area
                                ctx.beginPath();
                                ctx.moveTo(0, h);
                                for (var i = 0; i < dataPoints.length; i++) {
                                    var x = i * step;
                                    var y = h - (dataPoints[i] / maxVal) * h;
                                    if (i === 0) ctx.lineTo(x, y);
                                    else {
                                        // Simple smoothing for visual effect (midpoint bezier)
                                        var prevX = (i - 1) * step;
                                        var prevY = h - (dataPoints[i - 1] / maxVal) * h;
                                        var midX = (prevX + x) / 2;
                                        var midY = (prevY + y) / 2;
                                        ctx.quadraticCurveTo(prevX, prevY, midX, midY); // Approximation for smooth look
                                        // Actually quadratic to midpoint isn't quite right for continuous, 
                                        // let's do simple lineTo for robustness or detailed bezier if needed.
                                        // Reverting to lineTo for guaranteed stability, curveTo needs precise control points.
                                        // Let's try a cubic from prev to curr
                                        var cp1x = prevX + (x - prevX) / 2;
                                        var cp1y = prevY;
                                        var cp2x = prevX + (x - prevX) / 2;
                                        var cp2y = y;
                                        ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
                                    }
                                }
                                ctx.lineTo(w, h);
                                ctx.closePath();
                                ctx.fillStyle = gradient;
                                ctx.fill();
                                
                                // Draw Line
                                ctx.beginPath();
                                var startY = h - (dataPoints[0] / maxVal) * h;
                                ctx.moveTo(0, startY);
                                for (var j = 1; j < dataPoints.length; j++) {
                                    var currX = j * step;
                                    var currY = h - (dataPoints[j] / maxVal) * h;
                                    var prevX_ = (j - 1) * step;
                                    var prevY_ = h - (dataPoints[j - 1] / maxVal) * h;
                                    var cpx1 = prevX_ + (currX - prevX_) / 2;
                                    var cpx2 = prevX_ + (currX - prevX_) / 2;
                                    ctx.bezierCurveTo(cpx1, prevY_, cpx2, currY, currX, currY);
                                }
                                ctx.lineWidth = 3;
                                ctx.strokeStyle = lineColor;
                                ctx.stroke();
                                
                                // Draw Points
                                ctx.fillStyle = "#ffffff";
                                for (var k = 0; k < dataPoints.length; k++) {
                                    var px = k * step;
                                    var py = h - (dataPoints[k] / maxVal) * h;
                                    ctx.beginPath();
                                    ctx.arc(px, py, 4, 0, Math.PI * 2);
                                    ctx.fill();
                                }
                            }
                        }
                    }
                }
                
                // Top Performing Posts
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
                    Layout.margins: 16
                    radius: 24
                    color: Theme.glassBackground
                    border.color: Theme.glassBorder
                    border.width: 1
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 16
                        
                        Text {
                            text: qsTr("Top Content")
                            color: Theme.textPrimary
                            font.pixelSize: 16
                            font.weight: Font.Bold
                        }
                        
                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: 12
                            model: 5
                            interactive: false // physics handled by parent flickable usually, or allow small scroll
                            
                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 60
                                radius: 16
                                color: Theme.surfaceElevated
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 12
                                    
                                    Rectangle {
                                        Layout.preferredWidth: 40; Layout.preferredHeight: 40
                                        radius: 12
                                        gradient: Gradient {
                                            GradientStop { position: 0.0; color: Theme.aiGradientStart }
                                            GradientStop { position: 1.0; color: Theme.aiGradientEnd }
                                        }
                                        Text { anchors.centerIn: parent; text: index + 1; color: "white"; font.weight: Font.Bold }
                                    }
                                    
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 2
                                        Text { text: "Viral Post #" + (index + 420); color: Theme.textPrimary; font.weight: Font.Bold; font.pixelSize: 14 }
                                        Text { text: (Math.random() * 50 + 10).toFixed(1) + "K views"; color: Theme.textSecondary; font.pixelSize: 12 }
                                    }
                                    
                                    MiraIcon { name: "chevron_right"; size: 20; color: Theme.textTertiary }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
