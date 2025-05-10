include_guard(GLOBAL)

if (NOT STM32CUBE_TARGET)
  message(FATAL_ERROR "STM32CUBE_TARGET is not defined")
endif()

string(REGEX REPLACE "STM32(..).*" "\\1" STM32_FAMILY ${STM32CUBE_TARGET})

include(FetchContent)

if (NOT STM32CUBE_HASH)
  if (STM32_FAMILY STREQUAL "F3")
    set(STM32CUBE_HASH "1e7cbc6439178007ce021aabc2ed2580572e753a")
    set(STM32CUBE_TARGET_MACRO "STM32F303x8")
  elseif (STM32_FAMILY STREQUAL "F4")
    set(STM32CUBE_HASH "b8a21834c127ecc82c87c982d14de8cb3a65cf56")
    set(STM32CUBE_TARGET_MACRO "STM32F446xx")
  else()
    message(FATAL_ERROR "STM32CUBE_HASH is not defined and no default hash is available for STM32 family ${STM32_FAMILY}")
  endif()
endif()

FetchContent_Populate(STM32Cube
  GIT_REPOSITORY git@github.com:STMicroelectronics/STM32Cube${STM32_FAMILY}.git
  GIT_TAG ${STM32CUBE_HASH}
  SOURCE_DIR /usr/arm-none-eabi/src/STM32Cube${STM32_FAMILY}
  BINARY_DIR ${CMAKE_BINARY_DIR}/3rd-party/STM32Cube${STM32_FAMILY}/build
  SUBBUILD_DIR ${CMAKE_BINARY_DIR}/3rd-party/STM32Cube${STM32_FAMILY}/subbuild
)


#* ----------------- CMSIS ----------------- *#
add_library(cmsis INTERFACE)
target_include_directories(cmsis INTERFACE
${stm32cube_SOURCE_DIR}/Drivers/CMSIS/Include
)

#* ----------------- STM32Cube CMSIS ----------------- *#
add_library(stm32cube-cmsis INTERFACE)
target_include_directories(stm32cube-cmsis INTERFACE
  ${stm32cube_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F3xx/Include
)
target_link_libraries(stm32cube-cmsis INTERFACE cmsis)

#* ----------------- STM32Cube ----------------- *#
string(TOLOWER STM32_FAMILY_LOWER ${STM32_FAMILY})

file(GLOB_RECURSE HAL_SOURCES CONFIGURE_DEPENDS
  "${stm32cube_SOURCE_DIR}/Core/*.cpp"
  "${stm32cube_SOURCE_DIR}/Core/*.c"
  "${stm32cube_SOURCE_DIR}/Drivers/STM32${STM32_FAMILY}xx_HAL_Driver/*.c"
)
list(FILTER HAL_SOURCES EXCLUDE REGEX "template\.c$")

add_library(stm32cube STATIC ${HAL_SOURCES})

set(HAL_INCLUDES "")
list(APPEND HAL_INCLUDES "${stm32cube_SOURCE_DIR}/Core/Inc")
list(APPEND HAL_INCLUDES "${stm32cube_SOURCE_DIR}/Drivers/STM32${STM32_FAMILY}xx_HAL_Driver/Inc")
list(APPEND HAL_INCLUDES "${stm32cube_SOURCE_DIR}/Drivers/CMSIS/Include")
list(APPEND HAL_INCLUDES "${stm32cube_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32${STM32_FAMILY}xx/Include")
list(APPEND HAL_INCLUDES "/usr/share/robotics/cmake/STM32Cube/stm32cube-conf")
target_include_directories(stm32cube PUBLIC ${HAL_INCLUDES})

target_compile_definitions(stm32cube PUBLIC -D${STM32CUBE_TARGET_MACRO})
