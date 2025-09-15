import QtQuick 2.0
import QtQuick.Layouts
import QtQuick.Controls as Qqc
import SddmComponents 2.0

Rectangle {
    color: "black"
    width   : Window.width
    height  : Window.height


    property int usernameIndex: userModel.lastIndex
    property var usernameCurrent: userModel.data(userModel.index(usernameIndex, 0), 257);

    Connections {
        target: sddm

        // onLoginSucceeded: {
        // }
        //
        // onLoginFailed: {
        // }
    }
// Background
    AnimatedImage {
        width: parent.width
        height: parent.height
        fillMode: Image.Tile
        source: "bgN5.gif"
    }

// Center logo and login
    ColumnLayout {
        width: parent.width
        height: parent.height
        AnimatedImage{
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 2
            Layout.bottomMargin: 2
            width: (parent.width / 3)
            height: (parent.width / 3)
            source: "WiredLogIn.gif"
            // source: "test_512p.jpg"
        }
        RowLayout {
            Layout.alignment: Qt.AlignCenter
            spacing: 10

            Qqc.Button {
                id:leftArrow
                text: "<"
                width: 40
                enabled: usernameIndex > 0
                onClicked: {
                    if (usernameIndex > 0) {
                        usernameIndex--
                        // userModel.lastIndex = usernameIndex
                    }
                }
            }

            Qqc.Label {
                id: usernameLabel
                width: 120
                text:usernameCurrent
                color: "#c1b492"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
            }

            Qqc.Button {
                id:rightArrow
                text: ">"
                width: 40
                enabled: usernameIndex < userModel.count - 1
                onClicked: {
                    if (usernameIndex < userModel.count - 1) {
                        usernameIndex++
                        // userModel.lastIndex = usernameIndex
                    }
                }
            }
        }

        // Keyboard navigation for user selection
        Keys.onLeftPressed: {
            if (usernameIndex > 0) {
                usernameIndex--
                userModel.lastIndex = usernameIndex
            }
        }
        Keys.onRightPressed: {
            if (usernameIndex < userModel.count - 1) {
                usernameIndex++
                userModel.lastIndex = usernameIndex
            }
        }


//         Parse date from userModel and fill the Username field

        Qqc.Label {
            Layout.alignment: Qt.AlignCenter
            text: "Ｐａｓｓｗｏｒｄ："
            color: "#c1b492"
            font.pixelSize: 16
        }
        Qqc.TextField {
            id: password
            echoMode: TextInput.Password
            Layout.alignment: Qt.AlignCenter
            color:"#c1b492"
            background: Rectangle {
                color: "#000"
                implicitWidth: 200
                border.color: "#d2738a"
            }

            KeyNavigation.backtab: rightArrow; KeyNavigation.tab: session
            Keys.onPressed: function (event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    sddm.login(usernameCurrent, password.text, session.index)
                    event.accepted = true
                }
            }
        }
        Qqc.Button {
            Layout.alignment: Qt.AlignCenter
            text:"Ｌｏｇｉｎ"
            font.pixelSize: 20
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 40
                color: "#d2738a"
                radius: 4
            }
            // contentItem: Text {
            //     text: control.text
            //     font.pixelSize: control.font.pixelSize
            //     color: "#c1b492"
            //     horizontalAlignment: Text.AlignHCenter
            //     verticalAlignment: Text.AlignVCenter
            //     anchors.fill: parent
            // }
            onClicked: sddm.login(username.text, password.text, session.index)
        }

    }
    AnimatedImage {
        id: shutdownBtn
        height: 80
        width: 80
        y: 10
        x: Window.width - width - 10
        source: "VisLain.gif"
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: sddm.powerOff()
            onEntered: {
                var component = Qt.createComponent("ShutdownToolTip.qml");
                if (component.status == Component.Ready) {
                    var tooltip = component.createObject(shutdownBtn);
                    tooltip.x = -45
                    tooltip.y = 60
                    tooltip.destroy(600);
                }
            }
        }
    }
    AnimatedImage {
        id: rebootBtn
        anchors.right: shutdownBtn.left
        anchors.rightMargin: 5
        y: shutdownBtn.y + 10
        height: 70
        width: 60
        source: "lain_myese.gif"
        fillMode: Image.PreserveAspectFit
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: sddm.reboot()
            onEntered: {
                var component = Qt.createComponent("RebootToolTip.qml");
                if (component.status == Component.Ready) {
                    var tooltip = component.createObject(rebootBtn);
                    tooltip.x = -45
                    tooltip.y = 50
                    tooltip.destroy(600);
                }
            }
        }
    }
    ComboBox {
        id: session
        height: 30
        width: 200
        x: 15
        y: 20
        model: sessionModel
        index: sessionModel.lastIndex
        color: "#000"
        borderColor: "#d2738a"
        focusColor: "#d2738a"
        hoverColor: "#d2738a"
        textColor: "#c1b492"
        arrowIcon: Qt.resolvedUrl("angle-down.png")
        KeyNavigation.backtab: password
        KeyNavigation.tab: rebootBtn
    }

    // Component.onCompleted: {
    //     if (username.text == "") {
    //         username.focus = true
    //     } else {
    //         password.focus = true
    //     }
    // }
}

