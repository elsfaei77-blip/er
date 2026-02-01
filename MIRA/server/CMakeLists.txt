cmake_minimum_required(VERSION 3.10)
project(mira_server)

# Set C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find Drogon
find_package(Drogon REQUIRED)
find_package(jsoncpp CONFIG REQUIRED)

add_executable(mira_server 
    main.cc
    controllers/AuthController.cc
    controllers/PostController.cc
    controllers/UserController.cc
    controllers/SocialController.cc
    controllers/NotificationController.cc
)

target_link_libraries(mira_server PRIVATE Drogon::Drogon jsoncpp_lib)


file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/static/uploads)
# Copy static files if they exist
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/static)
    file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/static DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
endif()
