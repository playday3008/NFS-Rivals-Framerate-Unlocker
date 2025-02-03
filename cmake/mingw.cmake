# The name of the target operating system
set(CMAKE_SYSTEM_NAME Windows)

# Define possible toolchain prefixes
set(POSSIBLE_TOOLCHAIN_PREFIXES
  "x86_64-w64-mingw32ucrt"
  "x86_64-w64-mingw32"
)

# Function to check if toolchain exists
function(check_toolchain prefix result)
  find_program(GCC_PATH "${prefix}-gcc")
  if(GCC_PATH)
    set(${result} TRUE PARENT_SCOPE)
  else()
    set(${result} FALSE PARENT_SCOPE)
  endif()
  unset(GCC_PATH CACHE)
endfunction()

# Find first valid toolchain
set(TOOLCHAIN_PREFIX "")
foreach(prefix ${POSSIBLE_TOOLCHAIN_PREFIXES})
  check_toolchain(${prefix} TOOLCHAIN_VALID)
  if(TOOLCHAIN_VALID)
    set(TOOLCHAIN_PREFIX ${prefix})
    break()
  endif()
endforeach()

if(TOOLCHAIN_PREFIX STREQUAL "")
  message(FATAL_ERROR "No valid MinGW toolchain found!")
else()
  message(STATUS "Using MinGW toolchain: ${TOOLCHAIN_PREFIX}")
endif()

# Which compilers to use
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++)
set(CMAKE_RC_COMPILER ${TOOLCHAIN_PREFIX}-windres)

# Where is the target environment located
set(CMAKE_FIND_ROOT_PATH /usr/${TOOLCHAIN_PREFIX})

# Adjust the default behavior of the FIND_XXX() commands:

# Search programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
