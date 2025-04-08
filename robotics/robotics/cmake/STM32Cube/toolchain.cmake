set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
  /usr/arm-none-eabi/share/cmake
  /usr/arm-none-eabi/lib/cmake
  /usr/share/robotics/cmake/STM32Cube/cmake/
)

include(GccArmToolchain)

set(MY_ARCH_FLAGS "-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=soft -mthumb")
set(MY_COMPILE_FLAGS "-ffunction-sections -fdata-sections -fno-exceptions -fshort-enums -Oz -g3 -gdwarf-3")
set(MY_COMMON_FLAGS "${MY_ARCH_FLAGS} -specs=nano.specs -specs=nosys.specs")

set(CMAKE_C_FLAGS "${MY_COMMON_FLAGS} ${MY_COMPILE_FLAGS}")
set(CMAKE_CXX_FLAGS "${MY_COMMON_FLAGS} ${MY_COMPILE_FLAGS} -fno-rtti -fno-threadsafe-statics -fuse-cxa-atexit")
set(CMAKE_ASM_FLAGS "${MY_COMMON_FLAGS} -x assembler-with-cpp")
set(CMAKE_EXE_LINKER_FLAGS "-Wl,-T,${CMAKE_CURRENT_LIST_DIR}/linker_scripts/${STM32CUBE_TARGET}_FLASH.ld -Wl,--gc-sections -lc -lm")
