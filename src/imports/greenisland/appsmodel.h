/****************************************************************************
 * This file is part of GreenIslandQmlPlugin.
 *
 * Copyright (c) 2012 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:GPL3$
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#ifndef APPSMODEL_H
#define APPSMODEL_H

#include <QSet>
#include <QAbstractListModel>
#include <QSortFilterProxyModel>
#include <QQmlComponent>

#include <VApplicationInfo>

class VFileSystemWatcher;

class AppsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        NameRole = Qt::UserRole + 1,
        CommentRole,
        IconNameRole,
        CategoriesRole
    };

    AppsModel(QObject *parent = 0);

    QHash<int, QByteArray> roleNames() const;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    int rowCount(const QModelIndex &parent = QModelIndex()) const;

private:
    QList<VApplicationInfo *> m_apps;
    VFileSystemWatcher *m_watcher;
    QSet<QString> m_categories;

    void populate();
    void cleanupCategories();

private slots:
    void slotFileCreated(const QString &path);
    void slotFileDeleted(const QString &path);
    void slotFileChanged(const QString &path);
};

QML_DECLARE_TYPE(AppsModel)

class AppsModelSorted : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    AppsModelSorted(QObject *parent = 0);
    ~AppsModelSorted();

private:
    AppsModel *m_model;
};

QML_DECLARE_TYPE(AppsModelSorted)

#endif // APPSMODEL_H
