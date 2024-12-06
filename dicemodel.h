/***************************************************************************
 *	Copyright (C) 2022 by Renaud Guezennec                               *
 *   http://www.rolisteam.org/contact                                      *
 *                                                                         *
 *   This software is free software; you can redistribute it and/or modify *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/
#ifndef DICEMODEL_H
#define DICEMODEL_H

#include <QAbstractListModel>
#include <QColor>
#include <QQmlEngine>
#include <utility>

class DiceModel : public QAbstractListModel {
    Q_OBJECT
    QML_ELEMENT
public:
    enum class DiceType {
        FOURSIDE = 0,
        SIXSIDE,
        OCTOSIDE,
        TENSIDE,
        TWELVESIDE,
        TWENTYSIDE,
        ONEHUNDREDSIDE
    };
    Q_ENUM(DiceType)

    enum Roles {
        Type = Qt::UserRole + 1,
        Color
    };
    Q_ENUM(Roles)

    explicit DiceModel(QObject* parent = nullptr);

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void addDice(DiceType type, QColor color);
    void removeDice(DiceType type);

private:
    QList<std::pair<DiceType, QColor>> m_dices;
};

#endif // DICEMODEL_H
