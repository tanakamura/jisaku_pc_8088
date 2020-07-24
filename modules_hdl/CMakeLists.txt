cmake_minimum_required(VERSION 3.17)
project(sim)
find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_executable(addr_conv addr_conv_main.cpp)
verilate(addr_conv 
  SOURCES addr_converter.sv
  VERILATOR_ARGS --timescale-override 1ns/1ps -Wno-fatal --trace
  )

add_executable(i8088_cpu i8088_cpu_main.cpp)
add_executable(i8088_top i8088_top_main.cpp)
add_executable(ps2keyboard ps2keyboard_main.cpp)


verilate(i8088_cpu
  SOURCES i8088_cpu.sv ../firmware/i8088_rom.v ../firmware/rom.v
  VERILATOR_ARGS  --timescale-override 1ns/1ps --trace --top-module i8088_cpu
)

verilate(i8088_top
  SOURCES ../top_hdl/i8088_top.sv i8088_cpu.sv ../firmware/i8088_rom.v ../firmware/rom.v
  VERILATOR_ARGS  --timescale-override 1ns/1ps --trace --top-module jisaku_pc_top -DGENERATE_VERILATOR=1
)

verilate(ps2keyboard
  SOURCES ps2_keyboard.sv
  VERILATOR_ARGS  --timescale-override 1ns/1ps --trace --top-module ps2_keyboard -DGENERATE_VERILATOR=1
)

add_executable(genhex ../firmware/genhex.c)
add_executable(pack_8088_rom ../firmware/pack_8088_rom.c)

add_custom_target(firmware ALL
  DEPENDS 8088_firmware_hex.dat)

set(FW_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})

add_custom_command(OUTPUT ${FW_BUILD_DIR}/por_8088
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../firmware/por_8088.s
  COMMAND nasm ${CMAKE_CURRENT_SOURCE_DIR}/../firmware/por_8088.s -o ${FW_BUILD_DIR}/por_8088)
add_custom_command(OUTPUT ${FW_BUILD_DIR}/spi_load_8088
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../firmware/spi_load_8088.s
  COMMAND nasm ${CMAKE_CURRENT_SOURCE_DIR}/../firmware/spi_load_8088.s -o ${FW_BUILD_DIR}/spi_load_8088)

add_custom_command(OUTPUT ${FW_BUILD_DIR}/8088_firmware
  DEPENDS pack_8088_rom
  DEPENDS ${FW_BUILD_DIR}/por_8088
  DEPENDS ${FW_BUILD_DIR}/spi_load_8088
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/pack_8088_rom ${FW_BUILD_DIR}/8088_firmware)

add_custom_command(OUTPUT ${FW_BUILD_DIR}/8088_firmware_hex.dat
  DEPENDS ${FW_BUILD_DIR}/8088_firmware
  COMMAND ${FW_BUILD_DIR}/genhex 256 < ${FW_BUILD_DIR}/8088_firmware > ${FW_BUILD_DIR}/8088_firmware_hex.dat)
