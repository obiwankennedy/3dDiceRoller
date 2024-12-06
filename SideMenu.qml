import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Controllers

Drawer {
    id: drawer

    property alias mouseEnabled: mouseCtrl.checked
    property alias factor: _factor.value
    property alias fixedCamera: fixedCamera.checked

    height: root.height
    width: _toolBar.width + 40



    ColorDialog {
        id: colorDialog
        property int side: 0
        parentWindow: Overlay.overlay
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
    Flickable {
        anchors.fill: parent
        contentHeight: _toolBar.implicitHeight
        flickableDirection: Flickable.AutoFlickIfNeeded
        ScrollBar.vertical: ScrollBar {
            policy: Screen.height < 600 ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
        }
        ColumnLayout {
            id: _toolBar
            anchors.horizontalCenter: parent.horizontalCenter


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
                to: 100.0
                value: 8.0
            }

            CheckBox {
                id: fixedCamera
                text: qsTr("Use fixed camera")
                checked: true
            }

            CheckBox {
                id: mouseCtrl
                text: qsTr("disable mouseArea")
                checked: false
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

            Repeater {
                model: colors

                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        text: "D%1".arg(model.side)
                    }

                    ToolButton {
                        icon.name: "list-remove"
                        onClicked:  {
                            Dice3DController.removeDice(model.type)
                            label.value -= 1;
                        }
                    }


                    Label {
                        id: label
                        property int value: 0
                        text: value
                    }

                    ToolButton {
                        icon.name: "list-add"
                        onClicked:{
                            Dice3DController.addDice(model.type)
                            label.value += 1;
                        }
                    }

                    ToolButton {
                        Layout.preferredWidth: height
                        Layout.fillHeight: true
                        contentItem: Rectangle {
                            id: rect
                            color: Dice3DController.diceColor(model.type)

                            Connections {
                                target: Dice3DController
                                function onColorChanged() {
                                    rect.color = Dice3DController.diceColor(model.type)
                                }
                            }
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
