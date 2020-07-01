cmake_minimum_required(VERSION 3.17)
project(sim)
find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_executable(addr_conv addr_conv_main.cpp)
verilate(addr_conv 
  SOURCES addr_converter.sv
  VERILATOR_ARGS --timescale-override 1ns/1ps -Wno-fatal --trace
  )

add_executable(z80_cpu z80_cpu_main.cpp)

set(Z80_SRCS
  tv80/tv80_core.v)

verilate(z80_cpu
  SOURCES z80_cpu.sv ${Z80_SRCS} ../firmware/z80_rom.v ../firmware/rom.v
  VERILATOR_ARGS --timescale-override 1ns/1ps -Wno-fatal --trace --top-module z80_cpu
  INCLUDE_DIRS tv80
  )


add_executable(genhex ../firmware/genhex.c)

set(FW_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR})

add_custom_target(firmware ALL
  DEPENDS ${FW_BUILD_DIR}/z80_firmware_hex.dat)

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