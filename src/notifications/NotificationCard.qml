/*
 * Quantum Shell - The desktop shell for Quantum OS following Material Design
 * Copyright (C) 2015 Michael Spencer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.3
import Material 0.1

View {
    id: card

    property bool showing: mouseArea.containsMouse

    property var notification

    radius: Units.dp(2)
    elevation: 3

    clipContent: false

    width: parent.width
    height: mouseArea.containsMouse && notification.text
            ? column.height + Units.dp(32) : Units.dp(70)

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        anchors.margins: -Units.dp(10)
        hoverEnabled: true

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left

            width: Units.dp(30)
            height: width
            radius: width/2

            color: "#333"

            opacity: mouseArea.containsMouse ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 250 }
            }

            IconButton {
                iconName: "navigation/close"
                anchors.centerIn: parent
                color: "white"
                size: Units.dp(16)

                onClicked: {
                    print("Closing...")
                    notifyServer.closeNotification(notification.hasOwnProperty("id")
                            ? notification.id : notification.notificationId)
                }
            }
        }
    }

    Item {
        id: actionItem

        anchors {
            left: parent.left
            leftMargin: Units.dp(16)
            verticalCenter: parent.verticalCenter
        }

        height: width
        width: Units.dp(40)

        Icon {
            size: Units.dp(36)
            anchors.centerIn: parent
            name: notification.iconName
        }
    }

    Column {
        id: column
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: Units.dp(72)
        anchors.margins: Units.dp(16)

        spacing: Units.dp(8)

        Label {
            style: "subheading"
            text: notification.summary
            elide: Text.ElideRight
            width: parent.width
            visible: text != ""
        }

        Label {
            style: "body1"
            text: notification.body
            elide: Text.ElideRight
            width: parent.width
            maximumLineCount: mouseArea.containsMouse ? 0 : 1
            visible: text != ""
        }

        ProgressBar {
            value: visible ? notification.percent : 0
            width: parent.width
            visible: notification.hasOwnProperty("percent")
        }
    }
}
