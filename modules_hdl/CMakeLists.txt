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


verilate(i8088_cpu
  SOURCES i8088_cpu.sv ../firmware/i8088_rom.v ../firmware/rom.v
  VERILATOR_ARGS  --timescale-override 1ns/1ps --trace --top-module i8088_cpu
)

verilate(i8088_top
  SOURCES ../top_hdl/i8088_top.sv i8088_cpu.sv ../firmware/i8088_rom.v ../firmware/rom.v
  VERILATOR_ARGS  --timescale-override 1ns/1ps --trace --top-module jisaku_pc_top -DGENERATE_VERILATOR=1
)

add_executable(genhex ../firmware/genhex.c)

set(FW_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})

add_custom_target(firmware ALL
  DEPENDS ${FW_BUILD_DIR}/z80_firmware_hex.dat ${FW_BUILD_DIR}/8088_firmware_hex.dat)

add_custom_command(OUTPUT ${FW_BUILD_DIR}/z80_firmware.o
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../firmware/z80_firmware.s
  COMMAND z80-as ${CMAKE_CURRENT_SOURCE_DIR}/../firmware/z80_firmware.s -o ${FW_BUILD_DIR}/z80_firmware.o)

add_custom_command(OUTPUT ${FW_BUILD_DIR}/z80_firmware
  DEPENDS ${FW_BUILD_DIR}/z80_firmware.o
  COMMAND z80-ld -Ttext=0 -O binary ${FW_BUILD_DIR}/z80_firmware.o -o ${FW_BUILD_DIR}/z80_firmware && 
  z80-objdump -D ${FW_BUILD_DIR}/z80_firmware.o )


add_custom_command(OUTPUT ${FW_BUILD_DIR}/z80_firmware_hex.dat
  DEPENDS ${FW_BUILD_DIR}/z80_firmware
  COMMAND ${FW_BUILD_DIR}/genhex < ${FW_BUILD_DIR}/z80_firmware > ${FW_BUILD_DIR}/z80_firmware_hex.dat)



add_custom_command(OUTPUT ${FW_BUILD_DIR}/8088_firmware
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/../firmware/8088_firmware.s
  COMMAND nasm ${CMAKE_CURRENT_SOURCE_DIR}/../firmware/8088_firmware.s -o ${FW_BUILD_DIR}/8088_firmware)

add_custom_command(OUTPUT ${FW_BUILD_DIR}/8088_firmware_hex.dat
  DEPENDS ${FW_BUILD_DIR}/8088_firmware
  COMMAND ${FW_BUILD_DIR}/genhex 16 < ${FW_BUILD_DIR}/8088_firmware > ${FW_BUILD_DIR}/8088_firmware_hex.dat)
