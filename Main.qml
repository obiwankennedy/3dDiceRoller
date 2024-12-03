import QtQuick
import QtQuick3D
import QtQuick3D.Physics
import QtQuick3D.Helpers
import QtQuick.Dialogs
import QtQuick.Controls
import QtQuick.Layouts
import Controllers

ApplicationWindow {
    id: root
    width: 1280
    height: 720
    visible: true
    title: qsTr("QtQuick3DPhysics Custom Shapes")

    PhysicsWorld {
        id: physicsWorld
        running: true
        enableCCD: true
        scene: viewport.scene
        gravity: Qt.vector3d(0, -980.7, 0)
        typicalLength: 1
        typicalSpeed: 1000
        minimumTimestep: 15
        maximumTimestep: 20
    }


    View3D {
        id: viewport
        anchors.fill: parent
        camera: camera

        environment: SceneEnvironment {
            clearColor: "white"
            backgroundMode: SceneEnvironment.SkyBox
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
            lightProbe: proceduralSky
        }

        Texture {
            id: proceduralSky
            textureData: ProceduralSkyTextureData {
                sunLongitude: -115
            }
        }

        Texture {
            id: weaveNormal
            source: "qrc:/maps/weave.png"
            scaleU: 200
            scaleV: 200
            generateMipmaps: true
            mipFilter: Texture.Linear
        }

        Node {
            id: scene
            PerspectiveCamera {
                id: camera
                position: Qt.vector3d(0.0, 150.0, 0)
                eulerRotation: Qt.vector3d(-90, 0, 0)

                onEulerRotationChanged: console.log("eulerRotation: "+eulerRotation)
                onPositionChanged: console.log("Position:"+position)
                clipFar: 300
                clipNear: 100//0.1
            }
            /*OrthographicCamera {
                id: camera
                clipFar: 100
                clipNear: 0.1
                position: Qt.vector3d(0.0, 10.0, 0)
                eulerRotation.x: -90 //: Qt.vector3d(-87, -0, 0)
            }*/

            DirectionalLight {
                eulerRotation: Qt.vector3d(-45, 25, 0)
                castsShadow: true
                brightness: 1
                shadowMapQuality: Light.ShadowMapQualityVeryHigh
            }

            StaticRigidBody {
                id: tablecloth

                position: Qt.vector3d(0, 0, 0)

                Model {
                    geometry: HeightFieldGeometry {
                        id: tableclothGeometry
                        extents: Qt.vector3d(500, 0, 500)
                        heightMap: "qrc:/maps/black-heightmap.png"
                        smoothShading: false
                    }
                    materials: DefaultMaterial {
                        opacity: 0.0
                    }
                }

                collisionShapes: HeightFieldShape {
                    id: hfShape
                    extents: tableclothGeometry.extents
                    source: "qrc:/maps/black-heightmap.png"
                }
            }
            StaticRigidBody {
                id: northWall
                position: Qt.vector3d(0, 200, -100)
                eulerRotation: Qt.vector3d(90, 0, 0)
                Model {
                    geometry: HeightFieldGeometry {
                        id: northWallGeometry
                        extents: Qt.vector3d(500, 0, 500)
                        heightMap: "qrc:/maps/black-heightmap.png"
                        smoothShading: false
                    }
                    materials: DefaultMaterial {
                        opacity: 0.2
                        diffuseColor: "#888800"
                    }
                }
                collisionShapes: HeightFieldShape {
                    id: nwShape
                    extents: northWallGeometry.extents
                    source: "qrc:/maps/black-heightmap.png"
                }
            }
            StaticRigidBody {
                id: southWall
                position: Qt.vector3d(0, 200, 100)
                eulerRotation: Qt.vector3d(-90, 0, 0)
                Model {
                    geometry: HeightFieldGeometry {
                        id: southWallGeometry
                        extents: Qt.vector3d(500, 0, 500)
                        source: "qrc:/maps/black-heightmap.png"
                        smoothShading: false
                    }
                    materials: DefaultMaterial {
                        opacity: 0.2
                        diffuseColor: "#888800"
                    }
                }
                collisionShapes: HeightFieldShape {
                    id: swShape
                    extents: southWallGeometry.extents
                    source: "qrc:/maps/black-heightmap.png"
                }
            }
            StaticRigidBody {
                id: westWall
                position: Qt.vector3d(-190, 200, 0)
                eulerRotation: Qt.vector3d(0, 0, -90)
                Model {
                    geometry: HeightFieldGeometry {
                        id: westWallGeometry
                        extents: Qt.vector3d(500, 0, 500)
                        source: "qrc:/maps/black-heightmap.png"
                        smoothShading: false
                    }
                    materials: DefaultMaterial {
                        opacity: 0.2
                        diffuseColor: "#888800"
                    }
                }
                collisionShapes: HeightFieldShape {
                    id: wwShape
                    extents: westWallGeometry.extents
                    source: "qrc:/maps/black-heightmap.png"
                }
            }

            StaticRigidBody {
                id: aestWall
                position: Qt.vector3d(190, 200, 0)
                eulerRotation: Qt.vector3d(0, 0, 90)
                Model {
                    geometry: HeightFieldGeometry {
                        id: aestWallGeometry
                        extents: Qt.vector3d(500, 0, 500)
                        source: "qrc:/maps/black-heightmap.png"
                        smoothShading: false
                    }
                    materials: DefaultMaterial {
                        opacity: 0.2
                        diffuseColor: "#888800"
                    }
                }
                collisionShapes: HeightFieldShape {
                    id: awShape
                    extents: aestWallGeometry.extents
                    source: "qrc:/maps/black-heightmap.png"
                }
            }

            AxisHelper {
            }

            Component {
                id: genericDiceComp
                RegularDice {
                    scaleFactor: _factor.value
                }

            }

            Repeater3D {
                id: dicePool
                model: Dice3DController.model
                delegate: genericDiceComp
                /*Loader {
                   sourceComponent: DiceModel.TENSIDE === type ? dice10sComp :
                }*/
                function restore() {
                    for (let i = 0; i < count; i++) {
                        objectAt(i).restore()
                    }
                }
            }
        } // scene

        MouseArea {
            id: ma
            anchors.fill: parent
            property DynamicRigidBody current
            property real xvelocity: 0.0
            property real zvelocity: 0.0
            property real xpos: 0.0
            property real ypos: 0.0
            property real t: 0.0
            function initVelocity(point) {
                xpos = point.x
                ypos = point.z
                t = Date.now()
            }
            function computeVelocity(point) {
                var nx = point.x
                var ny = point.z
                var nt = Date.now()
                var distx = nx - xpos
                var disty = ny - ypos
                var interval = nt - t
                if(interval == 0)
                    return
                console.log("interval: ",ny," disty: ",disty," ypos",ypos)
                ma.xvelocity = distx//Math.sqrt(distx*distx)  //interval
                ma.zvelocity = disty//Math.sqrt(disty*disty) //interval
                xpos = nx
                ypos = ny
                t = nt
            }

            onPressed: (mouse)=> {
                var result = viewport.pick(mouse.x, mouse.y)
                if(result.objectHit) {
                     ma.current = result.objectHit.parent
                     ma.current.isKinematic = true
                     var point = viewport.mapTo3DScene(Qt.vector3d(mouse.x, mouse.y, 0))
                     ma.current.kinematicPosition = Qt.vector3d(point.x, point.y-10, point.z)
                    initVelocity(point)
                }
            }
            onPositionChanged: (mouse)=>{
                if(null === ma.current)
                    return

                var point = viewport.mapTo3DScene(Qt.vector3d(mouse.x, mouse.y, 0))
                ma.current.kinematicPosition = Qt.vector3d(point.x, point.y-10, point.z)
                computeVelocity(point)
           }
            onReleased: (mouse)=>{
                 if(null == current)
                      return
                 var point = viewport.mapTo3DScene(Qt.vector3d(mouse.x, mouse.y, 0))

                 ma.current.kinematicPosition = Qt.vector3d(point.x, point.y-10, point.z)
                 ma.current.isKinematic = false
                 current.applyCentralForce(Qt.vector3d(-xvelocity, 0, -zvelocity))
                 console.log(xvelocity+" "+zvelocity)
                 current = null
           }
        }
    }

    ColorDialog {
        id: colorDialog
        property int side: 0
        onAccepted: {
            if( side == 4)
                Dice3DController.fourColor = selectedColor
            else if(side == 6 )
                Dice3DController.sixColor = selectedColor
            else if(side == 8 )
                Dice3DController.eightColor = selectedColor
            else if(side == 10 )
                Dice3DController.tenColor = selectedColor
            else if(side == 12 )
                Dice3DController.twelveColor = selectedColor
            else if(side == 20 )
                Dice3DController.twentyColor = selectedColor
            else if(side == 100 )
                Dice3DController.oneHundredColor = selectedColor
        }
    }


    //! [controller]
   /* WasdController {
        //keysEnabled: false
        //mouseEnabled: false
        controlledObject: camera
        speed: 0.2
    }*/
    //! [controller]

    RowLayout {
        id: _toolBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right


        property int fourCount: 0
        property int sixCount: 0
        property int eightCount: 0
        property int tenCount: 0
        property int twelveCount: 0
        property int twentyCount: 0
        property int oneHundredCount: 0

        Label {
            text: qsTr("Dice Size:")
        }

        Slider {
            id: _factor
            from: 1.8
            to: 10.0
            value: 8.0
        }

        ListModel {
            id: colors
            ListElement {
                side: 4
                type: DiceModel.FOURSIDE
            }
            ListElement {
                side: 6
                type: DiceModel.SIXSIDE
            }
            ListElement {
                side: 8
                type: DiceModel.OCTOSIDE
            }
            ListElement {
                side: 10
                type: DiceModel.TENSIDE
            }
            ListElement {
                side: 12
                type: DiceModel.TWELVESIDE
            }
            ListElement {
                side: 20
                type: DiceModel.TWENTYSIDE
            }
            ListElement {
                side: 100
                type: DiceModel.ONEHUNDREDSIDE
            }
        }

        GridLayout {
            flow: GridLayout.TopToBottom
            rows: 2

            Repeater {
                model: colors

                Label {
                    text: model.side
                }
                ColumnLayout {
                    SpinBox {
                        from: 0
                        to: 100
                        property bool increase: false
                        up.onPressedChanged : {
                            increase = true
                        }
                        down.onPressedChanged : {
                            increase = false
                        }
                        onValueModified: {
                            if(increase)
                                Dice3DController.addDice(model.type)
                            else
                                Dice3DController.removeDice(model.type)

                        }
                    }
                    Button {
                        contentItem: Rectangle {
                            color: Dice3DController.diceColor(model.type)
                        }
                        onClicked: {
                            colorDialog.selectedColor = Dice3DController.diceColor(model.type)
                            colorDialog.side = model.side
                            colorDialog.open()
                        }
                    }
                }

            }
        }
    }


}
//! [window]
