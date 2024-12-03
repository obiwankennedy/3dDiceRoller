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
#ifndef DICE3DCONTROLLER_H
#define DICE3DCONTROLLER_H

#include "dicemodel.h"
#include <QObject>
#include <memory>

class Dice3DController : public QObject {
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON
    Q_PROPERTY(DiceModel* model READ model CONSTANT)
    Q_PROPERTY(QColor fourColor READ fourColor WRITE setFourColor NOTIFY fourColorChanged)
    Q_PROPERTY(QColor sixColor READ sixColor WRITE setSixColor NOTIFY sixColorChanged)
    Q_PROPERTY(QColor eightColor READ eightColor WRITE setEightColor NOTIFY eightColorChanged)
    Q_PROPERTY(QColor tenColor READ tenColor WRITE setTenColor NOTIFY tenColorChanged)
    Q_PROPERTY(QColor twelveColor READ twelveColor WRITE setTwelveColor NOTIFY twelveColorChanged)
    Q_PROPERTY(QColor twentyColor READ twentyColor WRITE setTwentyColor NOTIFY twentyColorChanged)
    Q_PROPERTY(QColor oneHundredColor READ oneHundredColor WRITE setOneHundredColor NOTIFY oneHundredColorChanged)
public:
    explicit Dice3DController(QObject* parent = nullptr);

    DiceModel* model() const;

    Q_INVOKABLE void addDice(DiceModel::DiceType type);
    Q_INVOKABLE void removeDice(DiceModel::DiceType type);

    QColor fourColor() const;
    void setFourColor(const QColor& newFourColor);

    QColor sixColor() const;
    void setSixColor(const QColor& newSixColor);

    QColor eightColor() const;
    void setEightColor(const QColor& newEightColor);

    QColor tenColor() const;
    void setTenColor(const QColor& newTenColor);

    QColor twelveColor() const;
    void setTwelveColor(const QColor& newTwelveColor);

    QColor twentyColor() const;
    void setTwentyColor(const QColor& newTwentyColor);

    QColor oneHundredColor() const;
    void setOneHundredColor(const QColor& oneHColor);

    Q_INVOKABLE QColor diceColor(DiceModel::DiceType type) const;

    Q_INVOKABLE QString diceTypeToCode(DiceModel::DiceType type) const;

signals:
    void fourColorChanged();
    void sixColorChanged();
    void eightColorChanged();
    void tenColorChanged();
    void twelveColorChanged();
    void twentyColorChanged();
    void oneHundredColorChanged();

private:
    std::unique_ptr<DiceModel> m_model;
    std::array<QColor, 7> m_colors;
};

#endif // DICE3DCONTROLLER_H
