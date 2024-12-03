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
#include "dice3dcontroller.h"

Dice3DController::Dice3DController(QObject* parent)
    : QObject { parent }
    , m_model(new DiceModel())
{
    m_colors[0] = Qt::black;
    m_colors[1] = Qt::black;
    m_colors[2] = Qt::black;
    m_colors[3] = Qt::black;
    m_colors[4] = Qt::black;
    m_colors[5] = Qt::black;
    m_colors[6] = Qt::black;
}

DiceModel* Dice3DController::model() const
{
    return m_model.get();
}

void Dice3DController::addDice(DiceModel::DiceType type)
{
    m_model->addDice(type, diceColor(type));
}

void Dice3DController::removeDice(DiceModel::DiceType type)
{
    m_model->removeDice(type);
}

QColor Dice3DController::diceColor(DiceModel::DiceType type) const
{
    return m_colors[static_cast<int>(type)];
}

QString Dice3DController::diceTypeToCode(DiceModel::DiceType type) const
{
    static QHash<DiceModel::DiceType, QString> data {
        { DiceModel::DiceType::FOURSIDE, "d4" },
        { DiceModel::DiceType::SIXSIDE, "d6" },
        { DiceModel::DiceType::OCTOSIDE, "d8" },
        { DiceModel::DiceType::TENSIDE, "d10" },
        { DiceModel::DiceType::TWELVESIDE, "d12" },
        { DiceModel::DiceType::TWENTYSIDE, "d20" },
        { DiceModel::DiceType::ONEHUNDREDSIDE, "d100" }
    };

    return data.value(type);
}

QColor Dice3DController::fourColor() const
{
    return diceColor(DiceModel::DiceType::FOURSIDE);
}

void Dice3DController::setFourColor(const QColor& newFourColor)
{
    if (fourColor() == newFourColor)
        return;
    m_colors[static_cast<int>(DiceModel::DiceType::FOURSIDE)] = newFourColor;
    emit fourColorChanged();
}

QColor Dice3DController::sixColor() const
{
    return diceColor(DiceModel::DiceType::SIXSIDE);
}

void Dice3DController::setSixColor(const QColor& newSixColor)
{
    if (sixColor() == newSixColor)
        return;
    m_colors[static_cast<int>(DiceModel::DiceType::SIXSIDE)] = newSixColor;
    emit sixColorChanged();
}

QColor Dice3DController::eightColor() const
{
    return diceColor(DiceModel::DiceType::OCTOSIDE);
}

void Dice3DController::setEightColor(const QColor& newEightColor)
{
    if (eightColor() == newEightColor)
        return;
    m_colors[static_cast<int>(DiceModel::DiceType::TENSIDE)] = newEightColor;
    emit eightColorChanged();
}

QColor Dice3DController::tenColor() const
{
    return diceColor(DiceModel::DiceType::TENSIDE);
}

void Dice3DController::setTenColor(const QColor& newTenColor)
{
    if (tenColor() == newTenColor)
        return;
    m_colors[static_cast<int>(DiceModel::DiceType::TENSIDE)] = newTenColor;
    emit tenColorChanged();
}

QColor Dice3DController::twelveColor() const
{
    return diceColor(DiceModel::DiceType::TWELVESIDE);
}

void Dice3DController::setTwelveColor(const QColor& newTwelveColor)
{
    if (twelveColor() == newTwelveColor)
        return;
    m_colors[static_cast<int>(DiceModel::DiceType::TWELVESIDE)] = newTwelveColor;
    emit twelveColorChanged();
}

QColor Dice3DController::twentyColor() const
{
    return diceColor(DiceModel::DiceType::TWENTYSIDE);
}

void Dice3DController::setTwentyColor(const QColor& newTwentyColor)
{
    if (twentyColor() == newTwentyColor)
        return;
    m_colors[static_cast<int>(DiceModel::DiceType::TWENTYSIDE)] = newTwentyColor;
    emit twentyColorChanged();
}

QColor Dice3DController::oneHundredColor() const
{
    return diceColor(DiceModel::DiceType::ONEHUNDREDSIDE);
}
void Dice3DController::setOneHundredColor(const QColor& oneHColor)
{
    if (oneHColor == oneHundredColor())
        return;
    m_colors[static_cast<int>(DiceModel::DiceType::ONEHUNDREDSIDE)] = oneHColor;
    emit oneHundredColorChanged();
}
