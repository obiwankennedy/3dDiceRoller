import QtQuick
import QtQuick3D
import QtQuick3D.Physics
import Controllers

DynamicRigidBody {
    id: root

    required property real scaleFactor
    required property color baseCol
    required property int index
    required property int type

    property real internalScale: DiceModel.SIXSIDE == type ? 3.5 : DiceModel.TENSIDE == type ? 1 : 1.

    property vector3d initialPosition: Qt.vector3d(11 + 1.5*Math.cos(index/(Math.PI/4)), 5 + index * 1.5, 0)

    readonly property string diceCode: Dice3DController.diceTypeToCode(root.type)


    scale: Qt.vector3d(scaleFactor*internalScale, scaleFactor*internalScale, scaleFactor*internalScale)
    eulerRotation: Qt.vector3d(randomInRange(0, 360),
                               randomInRange(0, 360),
                               randomInRange(0, 360))

    onInertiaTensorChanged: console.log("InertiaTensor:",inertiaTensor)

    position: initialPosition

    collisionShapes: ConvexMeshShape {
        id: diceShape
        source: "qrc:/meshes/%1.mesh".arg(root.diceCode)
    }

    function randomInRange(min, max) {
        return Math.random() * (max - min) + min;
    }

    function restore() {
        reset(initialPosition, centerOfMassRotation)
    }

    Texture {
        id: normals
        source: "qrc:/maps/%1_Normal_OpenGL.png".arg(root.diceCode)
    }

    Texture {
        id: numberFill
        source: "qrc:/maps/%1_Base_color.png".arg(root.diceCode)
        generateMipmaps: true
        mipFilter: Texture.Linear
    }

    physicsMaterial: PhysicsMaterial {
        id: physicsMaterial
        staticFriction: 0.5
        dynamicFriction: 0.5
        restitution: 0.5
    }

    Model {
        id: thisModel
        pickable: true
        source: diceShape.source
        materials: PrincipledMaterial {
            metalness: 1.0
            roughness: randomInRange(0.2, 0.6)
            baseColor: baseCol
            emissiveMap: numberFill
            emissiveFactor: Qt.vector3d(1, 1, 1)
            normalMap: numberNormal
            normalStrength: 0.75
        }
    }
}
