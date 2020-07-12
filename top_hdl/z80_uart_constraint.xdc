## This file is a general .xdc for the Arty A7-35 Rev. D
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports CLK100MHZ]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK100MHZ]


set_clock_groups -asynchronous -group [get_clocks sys_clk_pin]

## Switches
#set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #IO_L12N_T1_MRCC_16 Sch=sw[0]
#set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }]; #IO_L13P_T2_MRCC_16 Sch=sw[1]
#set_property -dict { PACKAGE_PIN C10   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }]; #IO_L13N_T2_MRCC_16 Sch=sw[2]
#set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }]; #IO_L14P_T2_SRCC_16 Sch=sw[3]

## RGB LEDs
#set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { led0_b }]; #IO_L18N_T2_35 Sch=led0_b
#set_property -dict { PACKAGE_PIN F6    IOSTANDARD LVCMOS33 } [get_ports { led0_g }]; #IO_L19N_T3_VREF_35 Sch=led0_g
#set_property -dict { PACKAGE_PIN G6    IOSTANDARD LVCMOS33 } [get_ports { led0_r }]; #IO_L19P_T3_35 Sch=led0_r
#set_property -dict { PACKAGE_PIN G4    IOSTANDARD LVCMOS33 } [get_ports { led1_b }]; #IO_L20P_T3_35 Sch=led1_b
#set_property -dict { PACKAGE_PIN J4    IOSTANDARD LVCMOS33 } [get_ports { led1_g }]; #IO_L21P_T3_DQS_35 Sch=led1_g
#set_property -dict { PACKAGE_PIN G3    IOSTANDARD LVCMOS33 } [get_ports { led1_r }]; #IO_L20N_T3_35 Sch=led1_r
#set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { led2_b }]; #IO_L21N_T3_DQS_35 Sch=led2_b
#set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports { led2_g }]; #IO_L22N_T3_35 Sch=led2_g
#set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports { led2_r }]; #IO_L22P_T3_35 Sch=led2_r
#set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { led3_b }]; #IO_L23P_T3_35 Sch=led3_b
#set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { led3_g }]; #IO_L24P_T3_35 Sch=led3_g
#set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { led3_r }]; #IO_L23N_T3_35 Sch=led3_r

## LEDs
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {led[3]}]

## Buttons
set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS33} [get_ports {btn[0]}]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports {btn[1]}]
set_property -dict {PACKAGE_PIN B9 IOSTANDARD LVCMOS33} [get_ports {btn[2]}]
set_property -dict {PACKAGE_PIN B8 IOSTANDARD LVCMOS33} [get_ports {btn[3]}]

## Pmod Header JA
#set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { ja[0] }]; #IO_0_15 Sch=ja[1]
#set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { ja[1] }]; #IO_L4P_T0_15 Sch=ja[2]
#set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVCMOS33 } [get_ports { ja[2] }]; #IO_L4N_T0_15 Sch=ja[3]
#set_property -dict { PACKAGE_PIN D12   IOSTANDARD LVCMOS33 } [get_ports { ja[3] }]; #IO_L6P_T0_15 Sch=ja[4]
#set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVCMOS33 } [get_ports { ja[4] }]; #IO_L6N_T0_VREF_15 Sch=ja[7]
#set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { ja[5] }]; #IO_L10P_T1_AD11P_15 Sch=ja[8]
#set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { ja[6] }]; #IO_L10N_T1_AD11N_15 Sch=ja[9]
#set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]; #IO_25_15 Sch=ja[10]

## Pmod Header JB
#set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVCMOS33 } [get_ports { jb[0] }]; #IO_L11P_T1_SRCC_15 Sch=jb_p[1]
#set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { jb[1] }]; #IO_L11N_T1_SRCC_15 Sch=jb_n[1]
#set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVCMOS33 } [get_ports { jb[2] }]; #IO_L12P_T1_MRCC_15 Sch=jb_p[2]
#set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { jb[3] }]; #IO_L12N_T1_MRCC_15 Sch=jb_n[2]
#set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { jb[4] }]; #IO_L23P_T3_FOE_B_15 Sch=jb_p[3]
#set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { jb[5] }]; #IO_L23N_T3_FWE_B_15 Sch=jb_n[3]
#set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { jb[6] }]; #IO_L24P_T3_RS1_15 Sch=jb_p[4]
#set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { jb[7] }]; #IO_L24N_T3_RS0_15 Sch=jb_n[4]

## Pmod Header JC
#set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { jc[0] }]; #IO_L20P_T3_A08_D24_14 Sch=jc_p[1]
#set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { jc[1] }]; #IO_L20N_T3_A07_D23_14 Sch=jc_n[1]
#set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { jc[2] }]; #IO_L21P_T3_DQS_14 Sch=jc_p[2]
#set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { jc[3] }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=jc_n[2]
#set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { jc[4] }]; #IO_L22P_T3_A05_D21_14 Sch=jc_p[3]
#set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { jc[5] }]; #IO_L22N_T3_A04_D20_14 Sch=jc_n[3]
#set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { jc[6] }]; #IO_L23P_T3_A03_D19_14 Sch=jc_p[4]
#set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { jc[7] }]; #IO_L23N_T3_A02_D18_14 Sch=jc_n[4]

## Pmod Header JD
#set_property -dict { PACKAGE_PIN D4    IOSTANDARD LVCMOS33 } [get_ports { jd[0] }]; #IO_L11N_T1_SRCC_35 Sch=jd[1]
#set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { jd[1] }]; #IO_L12N_T1_MRCC_35 Sch=jd[2]
#set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { jd[2] }]; #IO_L13P_T2_MRCC_35 Sch=jd[3]
#set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports { jd[3] }]; #IO_L13N_T2_MRCC_35 Sch=jd[4]
#set_property -dict { PACKAGE_PIN E2    IOSTANDARD LVCMOS33 } [get_ports { jd[4] }]; #IO_L14P_T2_SRCC_35 Sch=jd[7]
#set_property -dict { PACKAGE_PIN D2    IOSTANDARD LVCMOS33 } [get_ports { jd[5] }]; #IO_L14N_T2_SRCC_35 Sch=jd[8]
#set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { jd[6] }]; #IO_L15P_T2_DQS_35 Sch=jd[9]
#set_property -dict { PACKAGE_PIN G2    IOSTANDARD LVCMOS33 } [get_ports { jd[7] }]; #IO_L15N_T2_DQS_35 Sch=jd[10]

## USB-UART Interface
#set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
#set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }]; #IO_L14N_T2_SRCC_16 Sch=uart_txd_in

## ChipKit Outer Digital Header
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { ck_io0  }];
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { ck_io1  }];
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { ck_io2  }];
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { ck_io3  }];
set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { ck_io4  }];
set_property -dict {PACKAGE_PIN T14 IOSTANDARD LVCMOS33} [get_ports ck_io5]
set_property -dict {PACKAGE_PIN T15 IOSTANDARD LVCMOS33} [get_ports ck_io6]
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS33} [get_ports ck_io7]
set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS33} [get_ports ck_io8]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports ck_io9]
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports ck_io10]
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports ck_io11]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD LVCMOS33} [get_ports ck_io12]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports ck_io13]

## ChipKit Inner Digital Header
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS33} [get_ports ck_io26]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports ck_io27]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports ck_io28]
set_property -dict {PACKAGE_PIN R10 IOSTANDARD LVCMOS33} [get_ports ck_io29]
set_property -dict {PACKAGE_PIN R11 IOSTANDARD LVCMOS33} [get_ports ck_io30]
set_property -dict {PACKAGE_PIN R13 IOSTANDARD LVCMOS33} [get_ports ck_io31]
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports ck_io32]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports ck_io33]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD LVCMOS33} [get_ports ck_io34]
set_property -dict {PACKAGE_PIN N16 IOSTANDARD LVCMOS33} [get_ports ck_io35]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports ck_io36]
set_property -dict {PACKAGE_PIN U17 IOSTANDARD LVCMOS33} [get_ports ck_io37]
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports ck_io38]
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports ck_io39]
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS33} [get_ports ck_io40]
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports ck_io41]

## ChipKit Outer Analog Header - as Single-Ended Analog Inputs
## NOTE: These ports can be used as single-ended analog inputs with voltages from 0-3.3V (ChipKit analog pins A0-A5) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
## NOTE: The following constraints should be used with the XADC IP core when using these ports as analog inputs.
#set_property -dict { PACKAGE_PIN C5    IOSTANDARD LVCMOS33 } [get_ports { vaux4_n  }]; #IO_L1N_T0_AD4N_35 		Sch=ck_an_n[0]	ChipKit pin=A0
#set_property -dict { PACKAGE_PIN C6    IOSTANDARD LVCMOS33 } [get_ports { vaux4_p  }]; #IO_L1P_T0_AD4P_35 		Sch=ck_an_p[0]	ChipKit pin=A0
#set_property -dict { PACKAGE_PIN A5    IOSTANDARD LVCMOS33 } [get_ports { vaux5_n  }]; #IO_L3N_T0_DQS_AD5N_35 	Sch=ck_an_n[1]	ChipKit pin=A1
#set_property -dict { PACKAGE_PIN A6    IOSTANDARD LVCMOS33 } [get_ports { vaux5_p  }]; #IO_L3P_T0_DQS_AD5P_35 	Sch=ck_an_p[1]	ChipKit pin=A1
#set_property -dict { PACKAGE_PIN B4    IOSTANDARD LVCMOS33 } [get_ports { vaux6_n  }]; #IO_L7N_T1_AD6N_35 		Sch=ck_an_n[2]	ChipKit pin=A2
#set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { vaux6_p  }]; #IO_L7P_T1_AD6P_35 		Sch=ck_an_p[2]	ChipKit pin=A2
#set_property -dict { PACKAGE_PIN A1    IOSTANDARD LVCMOS33 } [get_ports { vaux7_n  }]; #IO_L9N_T1_DQS_AD7N_35 	Sch=ck_an_n[3]	ChipKit pin=A3
#set_property -dict { PACKAGE_PIN B1    IOSTANDARD LVCMOS33 } [get_ports { vaux7_p  }]; #IO_L9P_T1_DQS_AD7P_35 	Sch=ck_an_p[3]	ChipKit pin=A3
#set_property -dict { PACKAGE_PIN B2    IOSTANDARD LVCMOS33 } [get_ports { vaux15_n }]; #IO_L10N_T1_AD15N_35 	Sch=ck_an_n[4]	ChipKit pin=A4
#set_property -dict { PACKAGE_PIN B3    IOSTANDARD LVCMOS33 } [get_ports { vaux15_p }]; #IO_L10P_T1_AD15P_35 	Sch=ck_an_p[4]	ChipKit pin=A4
#set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVCMOS33 } [get_ports { vaux0_n  }]; #IO_L1N_T0_AD0N_15 		Sch=ck_an_n[5]	ChipKit pin=A5
#set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { vaux0_p  }]; #IO_L1P_T0_AD0P_15 		Sch=ck_an_p[5]	ChipKit pin=A5
## ChipKit Outer Analog Header - as Digital I/O
## NOTE: the following constraints should be used when using these ports as digital I/O.
#set_property -dict { PACKAGE_PIN F5    IOSTANDARD LVCMOS33 } [get_ports { ck_a0 }]; #IO_0_35           	Sch=ck_a[0]		ChipKit pin=A0
#set_property -dict { PACKAGE_PIN D8    IOSTANDARD LVCMOS33 } [get_ports { ck_a1 }]; #IO_L4P_T0_35      	Sch=ck_a[1]		ChipKit pin=A1
#set_property -dict { PACKAGE_PIN C7    IOSTANDARD LVCMOS33 } [get_ports { ck_a2 }]; #IO_L4N_T0_35      	Sch=ck_a[2]		ChipKit pin=A2
#set_property -dict { PACKAGE_PIN E7    IOSTANDARD LVCMOS33 } [get_ports { ck_a3 }]; #IO_L6P_T0_35      	Sch=ck_a[3]		ChipKit pin=A3
#set_property -dict { PACKAGE_PIN D7    IOSTANDARD LVCMOS33 } [get_ports { ck_a4 }]; #IO_L6N_T0_VREF_35 	Sch=ck_a[4]		ChipKit pin=A4
#set_property -dict { PACKAGE_PIN D5    IOSTANDARD LVCMOS33 } [get_ports { ck_a5 }]; #IO_L11P_T1_SRCC_35	Sch=ck_a[5]		ChipKit pin=A5

## ChipKit Inner Analog Header - as Differential Analog Inputs
## NOTE: These ports can be used as differential analog inputs with voltages from 0-1.0V (ChipKit Analog pins A6-A11) or as digital I/O.
## WARNING: Do not use both sets of constraints at the same time!
## NOTE: The following constraints should be used with the XADC core when using these ports as analog inputs.
#set_property -dict { PACKAGE_PIN B7    IOSTANDARD LVCMOS33 } [get_ports { vaux12_p }]; #IO_L2P_T0_AD12P_35	Sch=ad_p[12]	ChipKit pin=A6
#set_property -dict { PACKAGE_PIN B6    IOSTANDARD LVCMOS33 } [get_ports { vaux12_n }]; #IO_L2N_T0_AD12N_35	Sch=ad_n[12]	ChipKit pin=A7
#set_property -dict { PACKAGE_PIN E6    IOSTANDARD LVCMOS33 } [get_ports { vaux13_p }]; #IO_L5P_T0_AD13P_35	Sch=ad_p[13]	ChipKit pin=A8
#set_property -dict { PACKAGE_PIN E5    IOSTANDARD LVCMOS33 } [get_ports { vaux13_n }]; #IO_L5N_T0_AD13N_35	Sch=ad_n[13]	ChipKit pin=A9
#set_property -dict { PACKAGE_PIN A4    IOSTANDARD LVCMOS33 } [get_ports { vaux14_p }]; #IO_L8P_T1_AD14P_35	Sch=ad_p[14]	ChipKit pin=A10
#set_property -dict { PACKAGE_PIN A3    IOSTANDARD LVCMOS33 } [get_ports { vaux14_n }]; #IO_L8N_T1_AD14N_35	Sch=ad_n[14]	ChipKit pin=A11
## ChipKit Inner Analog Header - as Digital I/O
## NOTE: the following constraints should be used when using the inner analog header ports as digital I/O.

## ChipKit SPI
#set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { ck_miso }]; #IO_L17N_T2_35 Sch=ck_miso
#set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { ck_mosi }]; #IO_L17P_T2_35 Sch=ck_mosi
#set_property -dict { PACKAGE_PIN F1    IOSTANDARD LVCMOS33 } [get_ports { ck_sck }]; #IO_L18P_T2_35 Sch=ck_sck
#set_property -dict { PACKAGE_PIN C1    IOSTANDARD LVCMOS33 } [get_ports { ck_ss }]; #IO_L16N_T2_35 Sch=ck_ss

## ChipKit I2C
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports ck_scl]
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports ck_sda]
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { scl_pup }]; #IO_L9N_T1_DQS_AD3N_15 Sch=scl_pup
#set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { sda_pup }]; #IO_L9P_T1_DQS_AD3P_15 Sch=sda_pup

## Misc. ChipKit Ports
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports ck_ioa]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports ck_rst]

## SMSC Ethernet PHY
#set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { eth_col }]; #IO_L16N_T2_A27_15 Sch=eth_col
#set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { eth_crs }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=eth_crs
#set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { eth_mdc }]; #IO_L14N_T2_SRCC_15 Sch=eth_mdc
#set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { eth_mdio }]; #IO_L17P_T2_A26_15 Sch=eth_mdio
#set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { eth_ref_clk }]; #IO_L22P_T3_A17_15 Sch=eth_ref_clk
#set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS33 } [get_ports { eth_rstn }]; #IO_L20P_T3_A20_15 Sch=eth_rstn
#set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVCMOS33 } [get_ports { eth_rx_clk }]; #IO_L14P_T2_SRCC_15 Sch=eth_rx_clk
#set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { eth_rx_dv }]; #IO_L13N_T2_MRCC_15 Sch=eth_rx_dv
#set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[0] }]; #IO_L21N_T3_DQS_A18_15 Sch=eth_rxd[0]
#set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[1] }]; #IO_L16P_T2_A28_15 Sch=eth_rxd[1]
#set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[2] }]; #IO_L21P_T3_DQS_15 Sch=eth_rxd[2]
#set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { eth_rxd[3] }]; #IO_L18N_T2_A23_15 Sch=eth_rxd[3]
#set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { eth_rxerr }]; #IO_L20N_T3_A19_15 Sch=eth_rxerr
#set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { eth_tx_clk }]; #IO_L13P_T2_MRCC_15 Sch=eth_tx_clk
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { eth_tx_en }]; #IO_L19N_T3_A21_VREF_15 Sch=eth_tx_en
#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[0] }]; #IO_L15P_T2_DQS_15 Sch=eth_txd[0]
#set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[1] }]; #IO_L19P_T3_A22_15 Sch=eth_txd[1]
#set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[2] }]; #IO_L17N_T2_A25_15 Sch=eth_txd[2]
#set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { eth_txd[3] }]; #IO_L18P_T2_A24_15 Sch=eth_txd[3]

## Quad SPI Flash
#set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS33 } [get_ports { qspi_cs }]; #IO_L6P_T0_FCS_B_14 Sch=qspi_cs
#set_property -dict { PACKAGE_PIN K17   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[0] }]; #IO_L1P_T0_D00_MOSI_14 Sch=qspi_dq[0]
#set_property -dict { PACKAGE_PIN K18   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[1] }]; #IO_L1N_T0_D01_DIN_14 Sch=qspi_dq[1]
#set_property -dict { PACKAGE_PIN L14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_dq[2]
#set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_dq[3]

## Power Measurements
#set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33     } [get_ports { vsnsvu_n }]; #IO_L7N_T1_AD2N_15 Sch=ad_n[2]
#set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33     } [get_ports { vsnsvu_p }]; #IO_L7P_T1_AD2P_15 Sch=ad_p[2]
#set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVCMOS33     } [get_ports { vsns5v0_n }]; #IO_L3N_T0_DQS_AD1N_15 Sch=ad_n[1]
#set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVCMOS33     } [get_ports { vsns5v0_p }]; #IO_L3P_T0_DQS_AD1P_15 Sch=ad_p[1]
#set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS33     } [get_ports { isns5v0_n }]; #IO_L5N_T0_AD9N_15 Sch=ad_n[9]
#set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33     } [get_ports { isns5v0_p }]; #IO_L5P_T0_AD9P_15 Sch=ad_p[9]
#set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS33     } [get_ports { isns0v95_n }]; #IO_L8N_T1_AD10N_15 Sch=ad_n[10]
#set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS33     } [get_ports { isns0v95_p }]; #IO_L8P_T1_AD10P_15 Sch=ad_p[10]


set_property MARK_DEBUG true [get_nets AXI_rvalid]

set_property MARK_DEBUG true [get_nets {AXI_araddr33[5]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[2]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[3]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[14]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[13]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[22]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[4]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[21]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[6]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[7]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[23]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[15]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[16]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[8]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[9]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[10]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[11]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[12]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[24]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[30]}]
set_property MARK_DEBUG true [get_nets {AXI_araddr33[31]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[22]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[31]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[3]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[8]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[9]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[11]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[12]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[13]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[16]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[21]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[23]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[24]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[30]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[2]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[4]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[5]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[6]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[7]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[14]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[15]}]
set_property MARK_DEBUG true [get_nets {AXI_awaddr33[10]}]


set_property MARK_DEBUG true [get_nets {r_A_cpu[8]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[3]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[16]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[17]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[4]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[15]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[5]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[6]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[7]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[9]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[14]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[10]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[11]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[12]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[13]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[0]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[1]}]
set_property MARK_DEBUG true [get_nets {r_A_cpu[2]}]
set_property MARK_DEBUG true [get_nets {r_AD8_cpu[2]}]
set_property MARK_DEBUG true [get_nets {r_AD8_cpu[3]}]
set_property MARK_DEBUG true [get_nets {r_AD8_cpu[4]}]
set_property MARK_DEBUG true [get_nets {r_AD8_cpu[5]}]
set_property MARK_DEBUG true [get_nets {r_AD8_cpu[6]}]
set_property MARK_DEBUG true [get_nets {r_AD8_cpu[7]}]
set_property MARK_DEBUG true [get_nets {r_AD8_cpu[0]}]
set_property MARK_DEBUG true [get_nets {r_AD8_cpu[1]}]
set_property MARK_DEBUG true [get_nets AXI_awvalid]
set_property MARK_DEBUG true [get_nets AXI_wvalid]

set_property MARK_DEBUG true [get_nets AXI_rready]
set_property MARK_DEBUG true [get_nets AXI_arvalid]
set_property MARK_DEBUG true [get_nets ck_io7_OBUF]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[5]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[6]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[10]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[13]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[2]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[0]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[1]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[3]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[4]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[8]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[9]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[12]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[14]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[15]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[7]}]
set_property MARK_DEBUG true [get_nets {cpu/A32_busclk[11]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[2]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[11]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[7]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[14]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[19]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[15]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[18]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[4]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[9]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[22]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[28]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[29]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[17]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[8]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[30]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[12]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[13]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[25]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[1]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[10]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[16]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[26]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[27]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[24]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[31]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[0]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[3]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[6]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[20]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[21]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[23]}]
set_property MARK_DEBUG false [get_nets {AXI_wdata[5]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[0]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[1]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[15]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[25]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[29]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[24]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[30]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[23]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[6]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[10]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[2]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[21]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[13]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[14]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[18]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[28]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[9]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[26]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[20]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[4]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[5]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[17]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[16]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[11]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[7]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[8]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[27]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[31]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[19]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[12]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[3]}]
set_property MARK_DEBUG false [get_nets {AXI_rdata[22]}]
set_property MARK_DEBUG true [get_nets r_nRD_cpu]
set_property MARK_DEBUG true [get_nets r_nWR_cpu]
set_property MARK_DEBUG false [get_nets <const0>]
set_property MARK_DEBUG true [get_nets ck_io6_OBUF]

set_property MARK_DEBUG true [get_nets {cpu/AD8_out_cpu[0]}]
set_property MARK_DEBUG true [get_nets {cpu/AD8_out_cpu[1]}]
set_property MARK_DEBUG true [get_nets {cpu/AD8_out_cpu[2]}]
set_property MARK_DEBUG true [get_nets {cpu/AD8_out_cpu[3]}]
set_property MARK_DEBUG true [get_nets {cpu/AD8_out_cpu[4]}]
set_property MARK_DEBUG true [get_nets {cpu/AD8_out_cpu[5]}]
set_property MARK_DEBUG true [get_nets {cpu/AD8_out_cpu[6]}]
set_property MARK_DEBUG true [get_nets {cpu/AD8_out_cpu[7]}]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list axi_uart/simple_uart_i/mig_7series_0/u_simple_uart_mig_7series_0_1_mig/u_ddr3_infrastructure/gen_mmcm.mmcm_i_0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 20 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {r_A_cpu[0]} {r_A_cpu[1]} {r_A_cpu[2]} {r_A_cpu[3]} {r_A_cpu[4]} {r_A_cpu[5]} {r_A_cpu[6]} {r_A_cpu[7]} {r_A_cpu[8]} {r_A_cpu[9]} {r_A_cpu[10]} {r_A_cpu[11]} {r_A_cpu[12]} {r_A_cpu[13]} {r_A_cpu[14]} {r_A_cpu[15]} {r_A_cpu[16]} {r_A_cpu[17]} {r_A_cpu[18]} {r_A_cpu[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 30 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {AXI_araddr33[2]} {AXI_araddr33[3]} {AXI_araddr33[4]} {AXI_araddr33[5]} {AXI_araddr33[6]} {AXI_araddr33[7]} {AXI_araddr33[8]} {AXI_araddr33[9]} {AXI_araddr33[10]} {AXI_araddr33[11]} {AXI_araddr33[12]} {AXI_araddr33[13]} {AXI_araddr33[14]} {AXI_araddr33[15]} {AXI_araddr33[16]} {AXI_araddr33[17]} {AXI_araddr33[18]} {AXI_araddr33[19]} {AXI_araddr33[20]} {AXI_araddr33[21]} {AXI_araddr33[22]} {AXI_araddr33[23]} {AXI_araddr33[24]} {AXI_araddr33[25]} {AXI_araddr33[26]} {AXI_araddr33[27]} {AXI_araddr33[28]} {AXI_araddr33[29]} {AXI_araddr33[30]} {AXI_araddr33[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 30 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {AXI_awaddr33[2]} {AXI_awaddr33[3]} {AXI_awaddr33[4]} {AXI_awaddr33[5]} {AXI_awaddr33[6]} {AXI_awaddr33[7]} {AXI_awaddr33[8]} {AXI_awaddr33[9]} {AXI_awaddr33[10]} {AXI_awaddr33[11]} {AXI_awaddr33[12]} {AXI_awaddr33[13]} {AXI_awaddr33[14]} {AXI_awaddr33[15]} {AXI_awaddr33[16]} {AXI_awaddr33[17]} {AXI_awaddr33[18]} {AXI_awaddr33[19]} {AXI_awaddr33[20]} {AXI_awaddr33[21]} {AXI_awaddr33[22]} {AXI_awaddr33[23]} {AXI_awaddr33[24]} {AXI_awaddr33[25]} {AXI_awaddr33[26]} {AXI_awaddr33[27]} {AXI_awaddr33[28]} {AXI_awaddr33[29]} {AXI_awaddr33[30]} {AXI_awaddr33[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {r_AD8_cpu[0]} {r_AD8_cpu[1]} {r_AD8_cpu[2]} {r_AD8_cpu[3]} {r_AD8_cpu[4]} {r_AD8_cpu[5]} {r_AD8_cpu[6]} {r_AD8_cpu[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {cpu/A32_busclk[0]} {cpu/A32_busclk[1]} {cpu/A32_busclk[2]} {cpu/A32_busclk[3]} {cpu/A32_busclk[4]} {cpu/A32_busclk[5]} {cpu/A32_busclk[6]} {cpu/A32_busclk[7]} {cpu/A32_busclk[8]} {cpu/A32_busclk[9]} {cpu/A32_busclk[10]} {cpu/A32_busclk[11]} {cpu/A32_busclk[12]} {cpu/A32_busclk[13]} {cpu/A32_busclk[14]} {cpu/A32_busclk[15]} {cpu/A32_busclk[16]} {cpu/A32_busclk[17]} {cpu/A32_busclk[18]} {cpu/A32_busclk[19]} {cpu/A32_busclk[20]} {cpu/A32_busclk[21]} {cpu/A32_busclk[22]} {cpu/A32_busclk[23]} {cpu/A32_busclk[24]} {cpu/A32_busclk[25]} {cpu/A32_busclk[26]} {cpu/A32_busclk[27]} {cpu/A32_busclk[28]} {cpu/A32_busclk[29]} {cpu/A32_busclk[30]} {cpu/A32_busclk[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {cpu/AD8_out_cpu[0]} {cpu/AD8_out_cpu[1]} {cpu/AD8_out_cpu[2]} {cpu/AD8_out_cpu[3]} {cpu/AD8_out_cpu[4]} {cpu/AD8_out_cpu[5]} {cpu/AD8_out_cpu[6]} {cpu/AD8_out_cpu[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list AXI_arvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list AXI_awvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list AXI_rready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list AXI_rvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list AXI_wvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list ck_io6_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list ck_io7_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list n_0_0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list n_0_1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list n_0_2]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list n_0_3]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list n_0_4]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list n_0_5]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list r_nRD_cpu]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list r_nWR_cpu]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_83mhz]
