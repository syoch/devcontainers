if (NOT STM32CUBE_TARGET)
  message(FATAL_ERROR "STM32CUBE_TARGET is not defined")
endif()

string(REGEX REPLACE "STM32(..).*" "\\1" STM32_FAMILY ${STM32CUBE_TARGET})

include(FetchContent)

FetchContent_Populate(STM32Cube
  GIT_REPOSITORY git@github.com:STMicroelectronics/STM32Cube${STM32_FAMILY}.git
  GIT_TAG 1e7cbc6439178007ce021aabc2ed2580572e753a
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

add_library(stm32cube STATIC)

file(GLOB_RECURSE HAL_SOURCES CONFIGURE_DEPENDS
  "${stm32cube_SOURCE_DIR}/Core/*.cpp"
  "${stm32cube_SOURCE_DIR}/Core/*.c"
  "${stm32cube_SOURCE_DIR}/Drivers/STM32F3xx_HAL_Driver/*.c"
)
list(REMOVE_ITEM HAL_SOURCES "${stm32cube_SOURCE_DIR}/Drivers/STM32F3xx_HAL_Driver/Src/stm32f3xx_hal_timebase_rtc_alarm_template.c")
list(REMOVE_ITEM HAL_SOURCES "${stm32cube_SOURCE_DIR}/Drivers/STM32F3xx_HAL_Driver/Src/stm32f3xx_hal_timebase_rtc_wakeup_template.c")
list(REMOVE_ITEM HAL_SOURCES "${stm32cube_SOURCE_DIR}/Drivers/STM32F3xx_HAL_Driver/Src/stm32f3xx_hal_timebase_tim_template.c")
list(REMOVE_ITEM HAL_SOURCES "${stm32cube_SOURCE_DIR}/Drivers/STM32F3xx_HAL_Driver/Src/stm32f3xx_hal_msp_template.c")
target_sources(stm32cube PRIVATE ${HAL_SOURCES})

set(HAL_INCLUDES "")
list(APPEND HAL_INCLUDES "${stm32cube_SOURCE_DIR}/Core/Inc")
list(APPEND HAL_INCLUDES "${stm32cube_SOURCE_DIR}/Drivers/STM32F3xx_HAL_Driver/Inc")
target_include_directories(stm32cube PUBLIC ${HAL_INCLUDES})

target_link_libraries(stm32cube PUBLIC stm32cube-conf stm32cube-cmsis)

string(REGEX REPLACE "STM32(....)K(.).." "STM32\\1x\\2" STM32CUBE_TARGET_MACRO ${STM32CUBE_TARGET})
target_compile_definitions(stm32cube PUBLIC
  -D${STM32CUBE_TARGET_MACRO}
)