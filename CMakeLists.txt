cmake_minimum_required(VERSION 3.15...3.30)

# Toolchain
if(NOT WIN32)
  set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cmake/mingw.cmake)
endif()

project(
  FramerateUnlocker
  DESCRIPTION "Need for Speed Rivals Framerate Unlocker"
  LANGUAGES
    C
    CXX
    #ASM_MASM
)

# Global settings
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Compiler flags
if(MSVC)
  # Static runtime
  set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

  # Strip symbols
  add_link_options(
    $<$<CONFIG:Debug>:/DEBUG:NONE>
    $<$<CONFIG:RelWithDebInfo>:/DEBUG:NONE>
    $<$<CONFIG:Release>:>
    $<$<CONFIG:MinSizeRel>:>
  )
elseif(MINGW)
  # Static runtime
  add_link_options(-static)

  # Strip symbols
  add_link_options(
    $<$<CONFIG:Debug>:-s>
    $<$<CONFIG:RelWithDebInfo>:-s>
    $<$<CONFIG:Release>:>
    $<$<CONFIG:MinSizeRel>:>
  )
endif()

# Dependencies
include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/deps.cmake)

# Include Frostbite sub-project
add_subdirectory(Frostbite)

# Main library target
add_library(
  FramerateUnlocker
  SHARED
    dllmain.cpp
    util/memoryutils.cpp
    #asm/MiscPatches.asm
)

target_include_directories(
  FramerateUnlocker
  PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/util
)

target_link_libraries(
  FramerateUnlocker
  PRIVATE
    FrostbiteEngine
    minhook
    safetyhook
)

set_target_properties(FramerateUnlocker PROPERTIES SUFFIX ".asi")

# Find Steam installation path
set(STEAM_APPID 1262600)
if(CMAKE_HOST_WIN32)
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(STEAM_PATH_REG
      "HKEY_LOCAL_MACHINE\\SOFTWARE\\WOW6432Node\\Valve\\Steam"
    )
  else()
    set(STEAM_PATH_REG "HKEY_LOCAL_MACHINE\\SOFTWARE\\Valve\\Steam")
  endif()

  get_filename_component(
    STEAM_PATH
    "[${STEAM_PATH_REG};InstallPath]"
    ABSOLUTE
  )
elseif(CMAKE_HOST_LINUX)
  set(STEAM_PATH "$ENV{HOME}/.steam/steam")
endif()

if(EXISTS "${STEAM_PATH}")
  message(STATUS "Steam path: ${STEAM_PATH}")
  # From libraryfolders.vdf get the path to the library where the game with ${STEAM_APPID} is installed
  file(READ "${STEAM_PATH}/config/libraryfolders.vdf" LIBRARY_FOLDERS_VDF) # Read the file
  string(
    REGEX MATCHALL
    "\"path\"\t+\"([^\"]+)\""
    LIBRARY_FOLDERS
    ${LIBRARY_FOLDERS_VDF}
  ) # Get all the library folders
  list(
    TRANSFORM LIBRARY_FOLDERS
    REPLACE "\"path\"\t+\"([^\"]+)\"" "\\1"
    OUTPUT_VARIABLE LIBRARY_FOLDERS
  ) # Remove the "path" and the quotes
  math(EXPR LIBRARY_FOLDERS_COUNT "${LIBRARY_FOLDERS_COUNT} - 1") # Get the number of library folders

  foreach(LIBRARY_FOLDER IN LISTS LIBRARY_FOLDERS)
    if(EXISTS "${LIBRARY_FOLDER}/steamapps/appmanifest_${STEAM_APPID}.acf")
      file(
        READ
        "${LIBRARY_FOLDER}/steamapps/appmanifest_${STEAM_APPID}.acf"
        STEAM_MANIFEST
      ) # Read the file
      string(
        REGEX MATCH
        "\"installdir\"\t+\"([^\"]+)\""
        STEAM_MANIFEST
        ${STEAM_MANIFEST}
      ) # Get the install dir
      string(
        REGEX REPLACE
        "\"installdir\"\t+\"([^\"]+)\""
        "\\1"
        STEAM_MANIFEST
        ${STEAM_MANIFEST}
      ) # Remove the "installdir" and the quotes
      set(STEAM_GAME_PATH
        "${LIBRARY_FOLDER}/steamapps/common/${STEAM_MANIFEST}"
      )
      if(EXISTS "${STEAM_GAME_PATH}")
        break()
      endif()
    endif()
  endforeach()

  if(NOT EXISTS "${STEAM_GAME_PATH}")
    message(
      WARNING
      "Could not find the game path, copy the mod manually to the game folder"
    )
  else()
    set(TARGET_GAME_PATH "${STEAM_GAME_PATH}/Scripts")

    # Copy the mod to the game folder
    add_custom_command(
      TARGET FramerateUnlocker
      POST_BUILD
      COMMAND ${CMAKE_COMMAND}
      ARGS
        -E copy_if_different $<TARGET_FILE:FramerateUnlocker>
        ${TARGET_GAME_PATH}
      VERBATIM
      USES_TERMINAL
      COMMAND_EXPAND_LISTS
    )

    message(STATUS "Mod will be installed in ${TARGET_GAME_PATH}")
  endif()
endif()