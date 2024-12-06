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
#include "dicemodel.h"

DiceModel::DiceModel(QObject* parent)
    : QAbstractListModel(parent)
{
}

QVariant DiceModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    return {};
}

int DiceModel::rowCount(const QModelIndex& parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return m_dices.size();
}

QVariant DiceModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto const r = m_dices.at(index.row());
    QVariant var;
    if (role == Color)
        var = r.second;
    else
        var = QVariant::fromValue(r.first);

    return var; // QVariant::fromValue(r);
}

QHash<int, QByteArray> DiceModel::roleNames() const
{
    return { { Type, "type" }, { Color, "baseCol" } };
}

void DiceModel::addDice(DiceType type, QColor color)
{
    beginInsertRows(QModelIndex(), m_dices.size(), m_dices.size());
    m_dices.append({ type, color });
    endInsertRows();
}

void DiceModel::removeDice(DiceType type)
{
    auto it = std::find_if(std::begin(m_dices), std::end(m_dices),
        [type](const std::pair<DiceType, QColor>& item) { return type == item.first; });

    if (it == std::end(m_dices))
        return;

    auto pos = std::distance(std::begin(m_dices), it);
    beginRemoveRows(QModelIndex(), pos, pos);
    m_dices.remove(pos);
    endRemoveRows();
}
