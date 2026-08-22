pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

import Quickshell
import Quickshell.Services.UPower
import Quickshell.Wayland
import qs.components
import qs.components.styled
import qs.modules.lock as Lock
import qs.theme

Rectangle {
    id: root

    readonly property bool isPrimary: screen === Quickshell.screens[0]
    required property ShellScreen screen
    required property Lock.LockContext ctx

    // For the animations.
    property bool startAnim: false
    property bool exiting: false
    property var wallpaperPath: "../../assets/extra-14.jpg"

    color: "transparent"

    onVisibleChanged: bg.captureFrame()
    Component.onCompleted: {
        startAnim = true;
        passwordInput.forceActiveFocus();
    }

    ScreencopyView {
        id: bg

        captureSource: root.screen
        anchors.fill: parent
        opacity: hasContent ? 1 : 0
        live: false
        layer.enabled: true

        Behavior on opacity {
            animation: Animations.elementMoveSlow.numberAnimation(this)
        }
        layer.effect: MultiEffect {
            autoPaddingEnabled: false
            blurEnabled: true
            blur: root.startAnim ? 1 : 0.0
            blurMax: 64
            blurMultiplier: 1
            contrast: root.startAnim ? 0.05 : 0
            saturation: root.startAnim ? 0.1 : 0
            layer.enabled: true

            Behavior on blur {
                animation: Animations.elementMoveSlow.numberAnimation(this)
            }
            Behavior on contrast {
                animation: Animations.elementMoveSlow.numberAnimation(this)
            }
            Behavior on saturation {
                animation: Animations.elementMoveSlow.numberAnimation(this)
            }
            layer.effect: MultiEffect {
                autoPaddingEnabled: false
                blurEnabled: true
                blur: root.startAnim ? 1 : 0.0
                blurMax: 64

                Behavior on blur {
                    animation: Animations.elementMoveSlow.numberAnimation(this)
                }
            }
        }
    }
    Rectangle {
        anchors.fill: parent
        color: Colors.background.tertiary
        opacity: root.startAnim ? 0.75 : 0.0

        Behavior on opacity {
            animation: Animations.elementMoveSlow.numberAnimation(this)
        }
    }
    Clock {
        anchors.centerIn: parent
        scale: root.startAnim ? 1.0 : 0.75
        opacity: root.startAnim ? 1 : 0

        Behavior on scale {
            animation: Animations.elementMoveSlow.numberAnimation(this)
        }
        Behavior on opacity {
            animation: Animations.elementMove.numberAnimation(this)
        }
    }
    RowLayout {
        id: centerLayout

        spacing: 50
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        z: 100
        anchors.bottomMargin: root.startAnim ? 100 : -250

        Behavior on anchors.bottomMargin {
            animation: Animations.elementMoveSlow.numberAnimation(this)
        }

        Item {
            implicitHeight: passwordBox.height
            implicitWidth: passwordBox.width

            Rectangle {
                id: passwordBox

                visible: root.isPrimary
                color: Colors.background.tertiary
                implicitWidth: passwordBoxContent.width + 25
                implicitHeight: 75
                layer.enabled: true
                radius: Appearance.radius(4)
                z: 100

                layer.effect: Shadow {
                }

                Rectangle {
                    id: passwordBoxContent

                    anchors.centerIn: parent
                    implicitWidth: passwordBoxLayout.width + 25
                    implicitHeight: 50
                    color: Colors.background.primary
                    radius: Appearance.radius(-2)

                    RowLayout {
                        id: passwordBoxLayout

                        anchors.centerIn: parent
                        spacing: 20

                        StyledTextInput {
                            id: passwordInput

                            property bool hidden: true

                            padding: 10
                            echoMode: hidden ? TextInput.Password : TextInput.Normal
                            placeholderText: "Welcome, nferhat"
                            enabled: !root.ctx.unlockInProgress
                            inputMethodHints: Qt.ImhSensitiveData
                            focus: true

                            background: Rectangle {
                                color: "transparent"
                                implicitWidth: 300
                                implicitHeight: 10
                            }

                            onTextChanged: root.ctx.currentText = text
                            onAccepted: root.ctx.tryUnlock()
                        }
                        Button {
                            implicitWidth: 32
                            implicitHeight: 32
                            Layout.alignment: Qt.AlignCenter

                            background: Rectangle {
                                color: "transparent"
                            }

                            onClicked: passwordInput.hidden = !passwordInput.hidden

                            MaterialIcon {
                                id: buttonIcon

                                text: passwordInput.hidden ? "visibility_off" : "visibility"
                                color: passwordInput.hidden ? Colors.text.tertiary : Colors.accent

                                Behavior on color {
                                    animation: Animations.elementMoveFast.colorAnimation(this)
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: errorBox

                implicitHeight: 35
                implicitWidth: passwordBox.width * 0.8
                anchors.top: passwordBox.bottom
                anchors.horizontalCenter: passwordBox.horizontalCenter
                color: Colors.background.tertiary
                visible: root.isPrimary && root.ctx.showFailure
                anchors.topMargin: (root.ctx.showFailure || root.ctx.accountLocked) ? 10 : -50
                layer.enabled: true
                radius: Appearance.radius(-6)
                z: 90

                Behavior on anchors.topMargin {
                    animation: Animations.elementMove.numberAnimation(this)
                }
                layer.effect: Shadow {
                }

                StyledText {
                    color: root.ctx.accountLocked ? Colors.ansi.color1 : Colors.ansi.color3
                    anchors.centerIn: parent
                    text: (root.ctx.accountLocked) ? "Account Locked" : "Wrong password, try again"
                }
            }
        }
        Rectangle {
            id: statusBox

            visible: root.isPrimary
            color: Colors.background.tertiary
            implicitWidth: statusBoxContent.width + 25
            implicitHeight: 75
            layer.enabled: true
            radius: Appearance.radius(4)
            Layout.topMargin: root.startAnim ? 0 : 50

            layer.effect: Shadow {
            }
            Behavior on Layout.topMargin {
                animation: Animations.elementMoveSlow.numberAnimation(this)
            }

            Rectangle {
                id: statusBoxContent

                anchors.centerIn: parent
                implicitWidth: statusBoxLayout.width + 25
                implicitHeight: 50
                color: Colors.background.primary
                radius: Appearance.radius(-2)

                RowLayout {
                    id: statusBoxLayout

                    readonly property color iconColor: ColorUtils.mix(Colors.ansi.color4, Colors.text.primary)

                    anchors.centerIn: parent
                    implicitHeight: 30
                    spacing: 20

                    NotificationIcon {
                        color: statusBoxLayout.iconColor
                        count: 10
                    }
                    Separator {
                        vert: true
                    }
                    RowLayout {
                        readonly property color iconColor: ColorUtils.mix(Colors.ansi.color4, Colors.text.primary)

                        spacing: 12.5

                        MaterialIcon {
                            text: ""
                            color: parent.iconColor
                        }
                        MaterialIcon {
                            text: ""
                            color: parent.iconColor
                        }
                        MaterialIcon {
                            text: ""
                            color: parent.iconColor
                        }
                    }
                    Separator {
                        visible: batteryBar.visible
                        vert: true
                    }
                    WavyProgressBar {
                        id: batteryBar

                        readonly property UPowerDevice device: UPower.displayDevice
                        readonly property color deviceColor: {
                            if (device.state === UPowerDeviceState.Charging)
                                return Colors.ansi.color2;

                            const percentage = device.percentage;
                            if (percentage > 0.80)
                                return Colors.ansi.color2;
                            else if (percentage > 0.33)
                                return Colors.ansi.color4;
                            else if (percentage > 0.15)
                                return Colors.ansi.color3;
                            else
                                return Colors.ansi.color1;
                        }

                        visible: device.isLaptopBattery && device.ready
                        implicitWidth: 45
                        implicitHeight: 22
                        radius: Appearance.radius(-10)
                        normalColor: ColorUtils.mix(Colors.background.tertiary, deviceColor)
                        filledColor: deviceColor
                        percentage: device.percentage
                        wave: device.state === UPowerDeviceState.Charging
                    }
                }
            }
        }
    }
    Connections {
        function onUnlocked() {
            root.startAnim = false;
            root.exiting = true;
        }

        target: root.ctx
    }
}
