import QtQuick
import QtQuick.Particles
import MiraApp

Item {
    id: root
    width: 1
    height: 1
    
    function explode() {
        emitter.pulse(200)
    }

    ParticleSystem {
        id: particleSystem
        anchors.centerIn: parent
    }

    ImageParticle {
        source: "qrc:/assets/particle_star.png" // Fallback or dynamic shape if image missing
        color: Theme.accent
        colorVariation: 0.6
        alpha: 0
    }

    Emitter {
        id: emitter
        group: "stars"
        emitRate: 0
        lifeSpan: 1000
        size: 24
        sizeVariation: 12
        velocity: AngleDirection {
            angle: 270
            angleVariation: 360
            magnitude: 100
            magnitudeVariation: 50
        }
    }
}
