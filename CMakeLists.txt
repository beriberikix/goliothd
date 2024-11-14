cmake_minimum_required(VERSION 3.14)
set(projname "goliothd")
project(${projname} C)

include(FetchContent)

# Fetch the Golioth SDK with all submodules
FetchContent_Declare(
    golioth_sdk
    GIT_REPOSITORY https://github.com/golioth/golioth-firmware-sdk.git
    GIT_TAG main # Or a specific tag/commit if required
    GIT_SHALLOW FALSE
)
FetchContent_MakeAvailable(golioth_sdk)

# Set the source files
set(srcs
    src/main.c
    ${golioth_sdk_SOURCE_DIR}/examples/common/golioth_basics.c
)

# Define the path to the user configuration file
get_filename_component(user_config_file "include/golioth_user_config.h" ABSOLUTE)
add_definitions(-DCONFIG_GOLIOTH_USER_CONFIG_INCLUDE="${user_config_file}")

# Add subdirectory for Linux port
add_subdirectory(${golioth_sdk_SOURCE_DIR}/port/linux/golioth_sdk build)

# Add the executable
add_executable(${projname} ${srcs})

# Include necessary directories
target_include_directories(${projname} PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${golioth_sdk_SOURCE_DIR}/examples/common
    ${golioth_sdk_SOURCE_DIR}/include
)

# Link the Golioth SDK
target_link_libraries(${projname} golioth_sdk)