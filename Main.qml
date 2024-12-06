import QtQuick
import QtQuick3D
import QtQuick3D.Physics
import QtQuick3D.Helpers
import QtQuick.Controls
import QtQuick.Layouts
import Controllers

ApplicationWindow {
    id: root
    width: 1280
    height: 720
    visible: true
    flags: Qt.WA_TranslucentBackground
    color: "gray"

    property real currDrawerWidth: menu.width * menu.position

    title: qsTr("Rolisteam 3D dice roller")

    Item
    {

        anchors.fill: parent

        PhysicsWorld {
            id: physicsWorld
            running: true
            enableCCD: true
            scene: viewport.scene
            gravity: Qt.vector3d(0, -980.7, 0)
            typicalLength: 1
            typicalSpeed: 500
            minimumTimestep: 15
            maximumTimestep: 20
        }

        View3D {
            id: viewport
            anchors.fill: parent
            camera: menu.fixedCamera ? camera : camera2

            environment: SceneEnvironment {
                clearColor: "transparent"
                backgroundMode: SceneEnvironment.Transparent
                antialiasingMode: SceneEnvironment.MSAA
                antialiasingQuality: SceneEnvironment.High
                lightProbe: proceduralSky
            }

            Texture {
                id: proceduralSky
                textureData: ProceduralSkyTextureData {
                    sunLongitude: -115
                    groundBottomColor : Qt.rgba(0.5, 0.5, 0.5, 0.5)
                }
            }

            OrbitCameraController {
                 anchors.fill: parent
                 origin: originNode
                 camera: camera2
                 enabled: !menu.fixedCamera
             }

            WasdController {
                 controlledObject: camera2
                 enabled: !menu.fixedCamera
             }

            Node {
                id: originNode
                //eulerRotation: Qt.vector3d(-14.2885, 410.287, 0)
                PerspectiveCamera {
                    id: camera2
                    position: Qt.vector3d(0.0, 200.0, 0)
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                    clipFar: 1000
                    clipNear: 0.1
                }
            }
                /*OrthographicCamera {
                    id: camera
                    clipFar: 151
                    clipNear: 1
                    position: Qt.vector3d(0.0, 150.0, 0)
                    eulerRotation.x: -90 //: Qt.vector3d(-87, -0, 0)
                }*/
                Node {
                    id: scene

                    PerspectiveCamera {
                        id: camera
                        position: Qt.vector3d(0.0, 200.0, 0)
                        eulerRotation: Qt.vector3d(-90, 0, 0)
                        clipFar: 1000
                        clipNear: 140
                    }

                DirectionalLight {
                    eulerRotation: Qt.vector3d(-45, 25, 0)
                    castsShadow: true
                    brightness: 1
                    shadowMapQuality: Light.ShadowMapQualityVeryHigh
                }

                StaticRigidBody {
                    id: tablecloth

                    position: Qt.vector3d(0, 0, 0)

                    physicsMaterial: PhysicsMaterial {
                        id: physicsMaterial
                        staticFriction: 0.7
                        dynamicFriction: 0.7
                        restitution: 1.05
                    }

                    Model {
                        geometry: HeightFieldGeometry {
                            id: tableclothGeometry
                            extents: Qt.vector3d(500, 0, 500)
                            heightMap: "qrc:/maps/black-heightmap.png"
                            smoothShading: false
                        }
                        materials: DefaultMaterial {
                            opacity: 0
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
                    position: Qt.vector3d(0, 200, -200)
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
                            diffuseColor: "#2222FF"
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
                    position: Qt.vector3d(0, 200, 200)
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
                            diffuseColor: "#880000"
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
                    position: Qt.vector3d(-200, 200, 0)
                    eulerRotation: Qt.vector3d(0, 0, -90)
                    Model {
                        geometry: HeightFieldGeometry {
                            id: westWallGeometry
                            extents: Qt.vector3d(500, 50, 500)
                            source: "qrc:/maps/black-heightmap.png"
                            smoothShading: false
                        }
                        materials: DefaultMaterial {
                            opacity: 0.2
                            diffuseColor: "#00FF00"
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
                    position: Qt.vector3d(200, 200, 0)
                    eulerRotation: Qt.vector3d(0, 0, 90)
                    Model {
                        source: "#Cube"
                        scale: Qt.vector3d(4., 1., 4.)
                        /*geometry: HeightFieldGeometry {
                            id: aestWallGeometry
                            extents: Qt.vector3d(500, 50, 500)
                            source: "qrc:/maps/black-heightmap.png"
                            smoothShading: false
                        }*/
                        materials: DefaultMaterial {
                            opacity: 0.2
                            diffuseColor: "#888800"
                        }
                    }
                    collisionShapes: BoxShape {
                        enableDebugDraw: true
                        //extents: Qt.vector3d(500, 500, 500)
                    }


                    /*HeightFieldShape {
                        id: awShape
                        extents: aestWallGeometry.extents
                        source: "qrc:/maps/black-heightmap.png"
                    }*/
                }

                StaticRigidBody {
                    id: ceilling
                    position: Qt.vector3d(0, 400, 0)
                    eulerRotation: Qt.vector3d(0,0, -180)
                    Model {
                        geometry: HeightFieldGeometry {
                            id: ceillingGeometry
                            extents: Qt.vector3d(500, 0, 500)
                            source: "qrc:/maps/black-heightmap.png"
                            smoothShading: false
                        }
                        materials: DefaultMaterial {
                            opacity: 0.2
                            diffuseColor: "#00FFFF"
                        }
                    }
                    collisionShapes: HeightFieldShape {
                        id: ceillingShape
                        extents: ceillingGeometry.extents
                        source: "qrc:/maps/black-heightmap.png"
                    }
                }

                AxisHelper {
                    //opacity: 0.3
                }

                Component {
                    id: genericDiceComp
                    RegularDice {
                        scaleFactor: menu.factor
                    }
                }

                Repeater3D {
                    id: dicePool
                    model: Dice3DController.model
                    delegate: genericDiceComp
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
                enabled: !menu.mouseEnabled
                property DynamicRigidBody current
                property real xvelocity: 0.0
                property real zvelocity: 0.0
                property real xpos: 0.0
                property real ypos: 0.0
                property real t: 0.0
                function initVelocity(point) {
                    xpos = point.x
                    ypos = point.y
                    t = Date.now()
                }
                function computeVelocity(point) {
                    var nx = point.x
                    var ny = point.y
                    var nt = Date.now()
                    var distx = nx - xpos
                    var disty = ny - ypos
                    var interval = nt - t
                    if(interval == 0)
                        return
                    console.log("distx: ",distx," disty: ",disty)
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

                       ma.current.kinematicRotation = ma.current.rotation
                       var point = viewport.mapTo3DScene(Qt.vector3d(mouse.x, mouse.y, 0))
                       ma.current.kinematicPosition = Qt.vector3d(point.x, point.y-10, point.z)
                       initVelocity(mouse)
                   }
               }
                onPositionChanged: (mouse)=>{
                   if(null === ma.current)
                        return

                   var point = viewport.mapTo3DScene(Qt.vector3d(mouse.x, mouse.y, 0))
                   ma.current.kinematicPosition = Qt.vector3d(point.x, point.y-10, point.z)
                   computeVelocity(mouse)
               }
                onExited: console.log("Exited")
                onReleased: (mouse)=>{
                    if(null == current)
                        return
                    var point = viewport.mapTo3DScene(Qt.vector3d(mouse.x, mouse.y, 0))

                    ma.current.kinematicPosition = Qt.vector3d(point.x, point.y-10, point.z)
                    ma.current.isKinematic = false

                    console.log("change kinematic:",ma.current.isKinematic)
                    const vec = Qt.vector3d(xvelocity, -0.4, zvelocity).normalized();

                    ma.current.applyCentralImpulse(vec)
                    ma.current.applyImpulse(vec, Qt.vector3d(0, 10, 0))

                    ma.current = null
                }
            }
        }

        SideMenu {
            id: menu
        }

        RoundButton {
            id: iconOpen
            icon.source: "qrc:/resources/menuIcon.svg"
            x: root.currDrawerWidth
            onClicked: {
                menu.open()
            }
        }
    }
}



//! [window]
