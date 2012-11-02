/****************************************************************************
 * This file is part of Desktop Shell.
 *
 * Copyright (c) 2012 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:LGPL2.1+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.0
import FluidCore 1.0
import FluidUi 1.0
import GreenIsland 1.0

Item {
    id: appchooser

    FrameSvgItem {
        id: frame
        anchors.fill: parent
        imagePath: "widgets/frame"
        prefix: "plain"
    }

    Row {
        anchors.fill: frame
        spacing: 8

        Item {
            id: leftColumn
            width: parent.width / 4
            height: parent.height

            TextField {
                id: searchField
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }
                placeholderText: qsTr("Type to search...")
            }

            Component {
                id: itemDelegate

                ListItem {
                    id: wrapper
                    checked: ListView.isCurrentItem
                    enabled: true

                    Label {
                        text: label
                        font.weight: Font.Bold
                    }
                }
            }

            ListView {
                id: categoriesList
                anchors {
                    left: searchField.left
                    top: searchField.bottom
                    right: categoriesScrollBar.visible ? categoriesScrollBar.left : parent.right
                    bottom: parent.bottom
                }
                orientation: ListView.Vertical
                focus: true
                model: AppChooserCategoriesModel {}
                delegate: itemDelegate
                highlight: Highlight{}
                highlightRangeMode: ListView.StrictlyEnforceRange

                Connections {
                    target: searchField
                    onTextChanged: {
                        // TODO: Put searchField.text somewhere => categoriesList.model.setQuery(searchField.text);
                    }
                }
            }

            ScrollBar {
                id: categoriesScrollBar
                anchors {
                    top: searchField.bottom
                    right: parent.right
                    bottom: parent.bottom
                }
                flickableItem: categoriesList
            }
        }

        Item {
            id: rightColumn
            width: parent.width - leftColumn.width
            height: parent.height

            GridView {
                id: grid
                anchors.fill: parent
                cacheBuffer: 1000
                cellWidth: 128
                cellHeight: 128
                model: VisualDataModel {
                    id: visualModel

                    model: AvailableApplicationsModel {}
                    delegate: AppChooserDelegate {
                        visualIndex: VisualDataModel.itemsIndex
                        icon: "image://desktoptheme/" + (iconName ? iconName : "unknown")
                        label: name
                    }
                }

                displaced: Transition {
                    NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
                }
            }
        }
    }
}
