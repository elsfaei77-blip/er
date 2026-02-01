cmake_minimum_required(VERSION 3.16)

project(MIRA_Client VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 COMPONENTS Core Gui Quick Network Sql QuickControls2 Widgets Core5Compat REQUIRED)

qt_add_executable(MIRA_Client
    main.cpp
    src/AuthService.cpp
    src/AuthService.h
    src/NetworkManager.cpp
    src/NetworkManager.h
    src/ThreadModel.cpp
    src/ThreadModel.h
    src/ConversationModel.cpp
    src/ConversationModel.h
    src/MessageModel.cpp
    src/MessageModel.h
    src/CommentModel.cpp
    src/CommentModel.h
    src/SearchViewModel.cpp
    src/SearchViewModel.h
    src/ProfileViewModel.cpp
    src/ProfileViewModel.h
    src/AIService.cpp
    src/AIService.h
    src/NotificationService.cpp
    src/NotificationService.h
    src/NotificationModel.cpp
    src/NotificationModel.h
    src/HapticManager.cpp
    src/HapticManager.h
    resources/qml.qrc
)

# Android specific configuration
if(ANDROID)
    set_property(TARGET MIRA_Client PROPERTY QT_ANDROID_PACKAGE_NAME "com.mira.app")
    set_property(TARGET MIRA_Client PROPERTY QT_ANDROID_VERSION_NAME "1.0")
    set_property(TARGET MIRA_Client PROPERTY QT_ANDROID_VERSION_CODE "1")
    set_property(TARGET MIRA_Client PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
endif()

target_link_libraries(MIRA_Client PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Network
    Qt6::Sql
    Qt6::QuickControls2
    Qt6::Widgets
    Qt6::Core5Compat
)

# Traditional install only for Desktop
if(NOT ANDROID)
    install(TARGETS MIRA_Client
        BUNDLE DESTINATION .
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
endif()
