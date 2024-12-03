# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

cmake_minimum_required(VERSION 3.14)
project(dicePhysics LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)


find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Quick3D Quick3DPhysics)

qt_add_executable(${PROJECT_NAME}
    main.cpp
    dice3dcontroller.h
    dice3dcontroller.cpp
    dicemodel.h
    dicemodel.cpp
    dicegeometry.h dicegeometry.cpp
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

target_link_libraries(${PROJECT_NAME} PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Quick
    Qt::Quick3D
    Qt::Quick3DPhysics
)



# Resources:
set(qml_resource_files
    maps/cloth-heightmap.png
    maps/numbers-normal.png
    maps/numbers.png
    maps/weave.png
    maps/black-heightmap.png
    maps/d4_Base_color.png
    maps/d4_Normal_OpenGL.png
    maps/d6_Base_color.png
    maps/d6_Normal_OpenGL.png
    maps/d8_Base_color.png
    maps/d8_Normal_OpenGL.png
    maps/d10_Base_color.png
    maps/d10_Normal_OpenGL.png
    maps/d12_Base_color.png
    maps/d12_Normal_OpenGL.png
    maps/d20_Base_color.png
    maps/d20_Normal_OpenGL.png
    maps/d100_Base_color.png
    maps/d100_Normal_OpenGL.png

    meshes/d4.mesh
    meshes/d6.mesh
    meshes/d8.mesh
    meshes/d10.mesh
    meshes/d12.mesh
    meshes/d20.mesh
    meshes/d100.mesh
)

qt6_add_qml_module(${PROJECT_NAME}
  URI Controllers
  QML_FILES
    Main.qml
  SOURCES
    dice3dcontroller.h
    dice3dcontroller.cpp
    dicemodel.h
    dicemodel.cpp
  VERSION 1.0
  QML_FILES DiceInterface.qml
  QML_FILES RegularDice.qml
)

qt_add_resources(${PROJECT_NAME} "qml"
    PREFIX
        "/"
    FILES
        ${qml_resource_files}
)

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
