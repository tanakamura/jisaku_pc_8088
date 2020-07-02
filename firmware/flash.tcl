interface ftdi
ftdi_vid_pid 0x0403 0x6010
ftdi_channel 0
ftdi_layout_init 0x0098 0x008b
reset_config none

source [find cpld/xilinx-xc7.cfg]
source [find cpld/jtagspi.cfg]

adapter_khz 10000

init
jtagspi_init 0 bscan_spi_xc7a35t.bit
set wd [pwd]

#flash erase_address 0x000000 0x400000
#flash write_image $wd/../jisaku_pc/jisaku_pc.runs/impl_1/z80_uart_top.bit 0x000000

flash erase_address 0x800000 0x010000
flash write_image $wd/z80_main 0x800000
exit

