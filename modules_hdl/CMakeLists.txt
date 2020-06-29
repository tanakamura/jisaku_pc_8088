cmake_minimum_required(VERSION 3.17)
project(sim)
find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_executable(addr_conv addr_conv_main.cpp)
verilate(addr_conv SOURCES addr_converter.sv)

add_executable(z80_cpu z80_cpu_main.cpp)

file(GLOB Z80_SRCS ../jisaku_pc/z80/*.v)

verilate(z80_cpu
  SOURCES z80_cpu.sv ${Z80_SRCS} ../firmware/z80_rom.v ../firmware/rom.v
  VERILATOR_ARGS --timescale-override 1ns/1ps -Wno-fatal
  INCLUDE_DIRS ../jisaku_pc/z80
  )
