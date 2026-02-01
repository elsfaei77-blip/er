import QtQuick
import MiraApp

Item {
    id: root
    width: size
    height: size
    
    property string name: ""
    property int size: 24
    property color color: Theme.textPrimary
    property bool active: false
    property real strokeWidth: 2.2
    
    // Animation properties
    property real targetScale: 1.0
    
    scale: targetScale
    Behavior on scale {
        NumberAnimation {
            duration: Theme.animNormal
            easing.type: Theme.springEasing
            easing.amplitude: Theme.springOvershoot
        }
    }

    opacity: active ? 1.0 : 0.6
    Behavior on opacity { NumberAnimation { duration: 200 } }

    signal clicked()

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        smooth: true
        renderTarget: Canvas.Image
        renderStrategy: Canvas.Cooperative
        
        onPaint: {
            var ctx = canvas.getContext("2d");
            ctx.reset();
            ctx.clearRect(0, 0, width, height);
            
            ctx.strokeStyle = root.color;
            ctx.lineWidth = root.strokeWidth;
            ctx.lineCap = "round";
            ctx.lineJoin = "round";
            
            var s = root.size;
            var pad = root.strokeWidth / 2;
            
            switch(root.name) {
                case "home":
                    ctx.beginPath();
                    ctx.moveTo(s * 0.15, s * 0.48);
                    ctx.lineTo(s * 0.5, s * 0.18);
                    ctx.lineTo(s * 0.85, s * 0.48);
                    ctx.lineTo(s * 0.85, s * 0.82);
                    ctx.lineTo(s * 0.15, s * 0.82);
                    ctx.closePath();
                    ctx.stroke();
                    // Door
                    ctx.beginPath();
                    ctx.moveTo(s * 0.42, s * 0.82);
                    ctx.lineTo(s * 0.42, s * 0.62);
                    ctx.lineTo(s * 0.58, s * 0.62);
                    ctx.lineTo(s * 0.58, s * 0.82);
                    ctx.stroke();
                    break;

                case "logo":
                case "mira":
                case "threads_logo":
                    // MIRA Logo - Classic Sharp M with Premium Glow
                    ctx.shadowColor = root.color;
                    ctx.shadowBlur = 12;
                    ctx.lineWidth = 2.8;
                    ctx.beginPath();
                    var pad = s * 0.22;
                    var left = pad;
                    var right = s - pad;
                    var top = pad;
                    var bottom = s - pad;
                    var midX = s * 0.5;
                    var midY = s * 0.62;

                    ctx.moveTo(left, bottom);
                    ctx.lineTo(left, top);
                    ctx.lineTo(midX, midY);
                    ctx.lineTo(right, top);
                    ctx.lineTo(right, bottom);
                    ctx.stroke();
                    
                    // Reset shadow for other icons paints (just in case)
                    ctx.shadowBlur = 0;
                    break;

                    
                case "search":
                    ctx.beginPath();
                    ctx.arc(s * 0.45, s * 0.45, s * 0.26, 0, Math.PI * 2);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(s * 0.63, s * 0.63);
                    ctx.lineTo(s * 0.85, s * 0.85);
                    ctx.stroke();
                    break;
                    
                case "heart":
                case "like":
                    ctx.beginPath();
                    if (root.active && root.name === "like") {
                        ctx.fillStyle = Theme.likeRed;
                        ctx.strokeStyle = Theme.likeRed;
                    }
                    var hx = s * 0.5;
                    var hy = s * 0.35;
                    ctx.moveTo(hx, hy + s * 0.1);
                    ctx.bezierCurveTo(hx, hy, hx - s * 0.35, hy - s * 0.15, hx - s * 0.35, hy + s * 0.2);
                    ctx.bezierCurveTo(hx - s * 0.35, hy + s * 0.45, hx, hy + s * 0.6, hx, hy + s * 0.6);
                    ctx.bezierCurveTo(hx, hy + s * 0.6, hx + s * 0.35, hy + s * 0.45, hx + s * 0.35, hy + s * 0.2);
                    ctx.bezierCurveTo(hx + s * 0.35, hy - s * 0.15, hx, hy, hx, hy + s * 0.1);
                    if (root.active && root.name === "like") ctx.fill();
                    ctx.stroke();
                    break;
                    
                case "profile":
                    // Head
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.38, s * 0.16, 0, Math.PI * 2);
                    ctx.stroke();
                    // Body
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.9, s * 0.35, Math.PI, Math.PI * 2);
                    ctx.stroke();
                    break;
                    
                case "reply":
                    ctx.beginPath();
                    var r = s * 0.08;
                    ctx.moveTo(s * 0.22, s * 0.3);
                    ctx.lineTo(s * 0.78, s * 0.3);
                    ctx.arcTo(s * 0.85, s * 0.3, s * 0.85, s * 0.37, r);
                    ctx.lineTo(s * 0.85, s * 0.63);
                    ctx.arcTo(s * 0.85, s * 0.7, s * 0.78, s * 0.7, r);
                    ctx.lineTo(s * 0.4, s * 0.7);
                    ctx.lineTo(s * 0.2, s * 0.88);
                    ctx.lineTo(s * 0.2, s * 0.37);
                    ctx.arcTo(s * 0.2, s * 0.3, s * 0.28, s * 0.3, r);
                    ctx.stroke();
                    break;
                    
                case "repost":
                    // Top arrow
                    ctx.beginPath();
                    ctx.moveTo(s * 0.25, s * 0.4);
                    ctx.lineTo(s * 0.7, s * 0.4);
                    ctx.arcTo(s * 0.75, s * 0.4, s * 0.75, s * 0.45, 3);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(s * 0.6, s * 0.3);
                    ctx.lineTo(s * 0.7, s * 0.4);
                    ctx.lineTo(s * 0.6, s * 0.5);
                    ctx.stroke();
                    // Bottom arrow
                    ctx.beginPath();
                    ctx.moveTo(s * 0.75, s * 0.6);
                    ctx.lineTo(s * 0.3, s * 0.6);
                    ctx.arcTo(s * 0.25, s * 0.6, s * 0.25, s * 0.55, 3);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(s * 0.4, s * 0.7);
                    ctx.lineTo(s * 0.3, s * 0.6);
                    ctx.lineTo(s * 0.4, s * 0.5);
                    ctx.stroke();
                    break;
                    
                case "share":
                    ctx.beginPath();
                    ctx.moveTo(s * 0.2, s * 0.5);
                    ctx.lineTo(s * 0.8, s * 0.25);
                    ctx.lineTo(s * 0.55, s * 0.85);
                    ctx.lineTo(s * 0.45, s * 0.55);
                    ctx.closePath();
                    ctx.stroke();
                    break;
                    
                case "create_plus":
                    ctx.beginPath();
                    ctx.moveTo(s * 0.5, s * 0.2);
                    ctx.lineTo(s * 0.5, s * 0.8);
                    ctx.moveTo(s * 0.2, s * 0.5);
                    ctx.lineTo(s * 0.8, s * 0.5);
                    ctx.stroke();
                    break;
                    
                case "create":
                    var cr = s * 0.25;
                    ctx.beginPath();
                    ctx.rect(pad, pad, s - pad*2, s - pad*2);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(s * 0.5, s * 0.3);
                    ctx.lineTo(s * 0.5, s * 0.7);
                    ctx.moveTo(s * 0.3, s * 0.5);
                    ctx.lineTo(s * 0.7, s * 0.5);
                    ctx.stroke();
                    break;
                    
                case "verified":
                    ctx.fillStyle = Theme.blue;
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.5, s * 0.45, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.strokeStyle = "black";
                    ctx.lineWidth = 1.5;
                    ctx.beginPath();
                    ctx.moveTo(s * 0.3, s * 0.5);
                    ctx.lineTo(s * 0.45, s * 0.65);
                    ctx.lineTo(s * 0.7, s * 0.35);
                    ctx.stroke();
                    break;

                case "direct":
                    ctx.beginPath();
                    ctx.moveTo(s * 0.15, s * 0.5);
                    ctx.lineTo(s * 0.85, s * 0.15);
                    ctx.lineTo(s * 0.55, s * 0.85);
                    ctx.lineTo(s * 0.45, s * 0.55);
                    ctx.closePath();
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(s * 0.45, s * 0.55);
                    ctx.lineTo(s * 0.85, s * 0.15);
                    ctx.stroke();
                    break;
                    
                case "settings":
                    // Minimalist & Streamlined Premium Cogwheel
                    var cx = s * 0.5;
                    var cy = s * 0.5;
                    var r1 = s * 0.32; // Inner edge of teeth
                    var r2 = s * 0.40; // Outer edge of teeth
                    var r3 = s * 0.12; // Center hole
                    var teeth = 8;
                    
                    // Simple center circle
                    ctx.beginPath();
                    ctx.arc(cx, cy, r3, 0, Math.PI * 2);
                    ctx.stroke();
                    
                    // Smooth, blocky yet rounded teeth for a modern look
                    ctx.beginPath();
                    for (var i = 0; i < teeth; i++) {
                        var baseAngle = i * (Math.PI * 2 / teeth);
                        var sweep = Math.PI * 2 / (teeth * 2.5);
                        
                        var a1 = baseAngle - sweep;
                        var a2 = baseAngle + sweep;
                        
                        // Outer part of tooth
                        ctx.arc(cx, cy, r2, a1, a2, false);
                        // Connect to inner circle
                        ctx.arc(cx, cy, r1, a2, (i + 1) * (Math.PI * 2 / teeth) - sweep, false);
                    }
                    ctx.closePath();
                    ctx.stroke();
                    break;
                    
                case "back":
                    ctx.beginPath();
                    ctx.moveTo(s * 0.7, s * 0.2);
                    ctx.lineTo(s * 0.4, s * 0.5);
                    ctx.lineTo(s * 0.7, s * 0.8);
                    ctx.stroke();
                    break;
                    
                case "close":
                    ctx.beginPath();
                    ctx.moveTo(s * 0.25, s * 0.25);
                    ctx.lineTo(s * 0.75, s * 0.75);
                    ctx.moveTo(s * 0.75, s * 0.25);
                    ctx.lineTo(s * 0.25, s * 0.75);
                    ctx.stroke();
                    break;
                    
                case "image":
                    ctx.beginPath();
                    ctx.rect(s * 0.15, s * 0.2, s * 0.7, s * 0.6);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.arc(s * 0.35, s * 0.4, s * 0.08, 0, Math.PI * 2);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(s * 0.15, s * 0.65);
                    ctx.lineTo(s * 0.4, s * 0.45);
                    ctx.lineTo(s * 0.6, s * 0.6);
                    ctx.lineTo(s * 0.75, s * 0.5);
                    ctx.lineTo(s * 0.85, s * 0.65);
                    ctx.stroke();
                    break;

                case "camera":
                    ctx.beginPath();
                    ctx.rect(s * 0.15, s * 0.3, s * 0.7, s * 0.5);
                    ctx.moveTo(s * 0.35, s * 0.3);
                    ctx.lineTo(s * 0.4, s * 0.2);
                    ctx.lineTo(s * 0.6, s * 0.2);
                    ctx.lineTo(s * 0.65, s * 0.3);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.55, s * 0.15, 0, Math.PI * 2);
                    ctx.stroke();
                    break;

                case "mic":
                    ctx.beginPath();
                    ctx.rect(s * 0.35, s * 0.15, s * 0.3, s * 0.5);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.5, s * 0.3, 0.2 * Math.PI, 0.8 * Math.PI);
                    ctx.moveTo(s * 0.5, s * 0.82);
                    ctx.lineTo(s * 0.5, s * 0.95);
                    ctx.stroke();
                    break;

                case "hash":
                    ctx.beginPath();
                    ctx.moveTo(s * 0.3, s * 0.2); ctx.lineTo(s * 0.3, s * 0.8);
                    ctx.moveTo(s * 0.7, s * 0.2); ctx.lineTo(s * 0.7, s * 0.8);
                    ctx.moveTo(s * 0.2, s * 0.35); ctx.lineTo(s * 0.8, s * 0.35);
                    ctx.moveTo(s * 0.2, s * 0.65); ctx.lineTo(s * 0.8, s * 0.65);
                    ctx.stroke();
                    break;

                case "list":
                    ctx.beginPath();
                    ctx.moveTo(s * 0.2, s * 0.3); ctx.lineTo(s * 0.8, s * 0.3);
                    ctx.moveTo(s * 0.2, s * 0.5); ctx.lineTo(s * 0.8, s * 0.5);
                    ctx.moveTo(s * 0.2, s * 0.7); ctx.lineTo(s * 0.8, s * 0.7);
                    ctx.stroke();
                    break;

                case "mention":
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.5, s * 0.35, 0, Math.PI * 2);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.5, s * 0.15, 0, Math.PI * 2);
                    ctx.stroke();
                    break;

                case "quote":
                    ctx.beginPath();
                    ctx.moveTo(s * 0.3, s * 0.3); ctx.lineTo(s * 0.3, s * 0.7);
                    ctx.moveTo(s * 0.7, s * 0.3); ctx.lineTo(s * 0.7, s * 0.7);
                    ctx.stroke();
                    break;

                case "repliesTab":
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.5, s * 0.3, 0, Math.PI * 2);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(s * 0.3, s * 0.5); ctx.lineTo(s * 0.7, s * 0.5);
                    ctx.stroke();
                    break;

                case "globe":
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.5, s * 0.38, 0, Math.PI * 2);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.ellipse(s * 0.5, s * 0.5, s * 0.15, s * 0.38);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(s * 0.12, s * 0.5);
                    ctx.lineTo(s * 0.88, s * 0.5);
                    ctx.stroke();
                    break;

                case "help":
                case "question":
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.4, s * 0.2, 0.8 * Math.PI, 0.2 * Math.PI, true);
                    ctx.quadraticCurveTo(s * 0.7, s * 0.55, s * 0.5, s * 0.65);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.arc(s * 0.5, s * 0.8, s * 0.02, 0, Math.PI * 2);
                    ctx.stroke();
                    break;

                case "reels":
                case "video":
                    // Reels Clapperboard Icon
                    var cr = s * 0.15;
                    ctx.beginPath();
                    // Main body
                    ctx.rect(pad + s * 0.05, pad + s * 0.2, s - pad * 2 - s * 0.1, s - pad * 2 - s * 0.3);
                    ctx.stroke();
                    // Clapper top
                    ctx.beginPath();
                    ctx.moveTo(s * 0.1, s * 0.2);
                    ctx.lineTo(s * 0.9, s * 0.2);
                    ctx.lineTo(s * 0.8, s * 0.08);
                    ctx.lineTo(s * 0.2, s * 0.08);
                    ctx.closePath();
                    ctx.stroke();
                    // Slanted stripes in clapper
                    ctx.beginPath();
                    ctx.moveTo(s * 0.35, s * 0.08); ctx.lineTo(s * 0.45, s * 0.2);
                    ctx.moveTo(s * 0.55, s * 0.08); ctx.lineTo(s * 0.65, s * 0.2);
                    ctx.stroke();
                    // Play triangle
                    ctx.beginPath();
                    ctx.moveTo(s * 0.42, s * 0.4);
                    ctx.lineTo(s * 0.62, s * 0.52);
                    ctx.lineTo(s * 0.42, s * 0.64);
                    ctx.closePath();
                    if (root.active) ctx.fill();
                    ctx.stroke();
                    break;

                case "ai":
                case "sparkle":
                    // AI Sparkle Icon
                    var cx = s * 0.5;
                    var cy = s * 0.5;
                    ctx.beginPath();
                    // 4-pointed star/sparkle
                    ctx.moveTo(cx, cy - s * 0.4);
                    ctx.quadraticCurveTo(cx, cy, cx + s * 0.4, cy);
                    ctx.quadraticCurveTo(cx, cy, cx, cy + s * 0.4);
                    ctx.quadraticCurveTo(cx, cy, cx - s * 0.4, cy);
                    ctx.quadraticCurveTo(cx, cy, cx, cy - s * 0.4);
                    ctx.stroke();
                    // Small dot inside or nearby
                    ctx.beginPath();
                    ctx.arc(cx + s * 0.25, cy - s * 0.25, s * 0.08, 0, Math.PI * 2);
                    ctx.stroke();
                    break;
                case "maximize":
                case "fullscreen":
                    // Modern Minimalist Expand (Top-Right & Bottom-Left only)
                    var m = s * 0.18; // Margin
                    var c = s * 0.32; // Corner length
                    ctx.lineCap = "round";
                    ctx.lineJoin = "round";
                    // Top-Right
                    ctx.beginPath(); ctx.moveTo(s - m - c, m); ctx.lineTo(s - m, m); ctx.lineTo(s - m, m + c); ctx.stroke();
                    // Bottom-Left
                    ctx.beginPath(); ctx.moveTo(m + c, s - m); ctx.lineTo(m, s - m); ctx.lineTo(m, s - m - c); ctx.stroke();
                    break;

                case "play":
                    // Filled rounded triangle
                    ctx.fillStyle = root.color;
                    ctx.beginPath();
                    // Geometric adjustments to center visual weight
                    var px = s * 0.35;
                    var py = s * 0.25;
                    var pd = s * 0.5;
                    ctx.moveTo(px, py);
                    ctx.lineTo(px + pd, s * 0.5);
                    ctx.lineTo(px, s - py);
                    ctx.closePath();
                    ctx.fill();
                    break;

                case "pause":
                    // Two filled rounded rectangles
                    ctx.fillStyle = root.color;
                    var bw = s * 0.18; // Bar width
                    var bh = s * 0.5;  // Bar height
                    var bx = s * 0.25; // X position start
                    var by = s * 0.25;
                    
                    // Left bar
                    ctx.beginPath();
                    ctx.rect(bx, by, bw, bh);
                    ctx.fill();
                    
                    // Right bar
                    ctx.beginPath();
                    ctx.rect(s - bx - bw, by, bw, bh);
                    ctx.fill();
                    break;
            }
        }
    }
    
    onColorChanged: canvas.requestPaint()
    onActiveChanged: canvas.requestPaint()
    onSizeChanged: canvas.requestPaint()
}
