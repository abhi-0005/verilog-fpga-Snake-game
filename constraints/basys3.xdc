## Clock
set_property PACKAGE_PIN W5     [get_ports CLK100MHZ]
set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ]

## Push Button for Reset (BTNC)
set_property PACKAGE_PIN U18      [get_ports BTNC]
set_property IOSTANDARD LVCMOS33  [get_ports BTNC]

## VGA output (4 bits each for R, G, B + HS, VS)
# Red
set_property PACKAGE_PIN A3  [get_ports VGA_R[0]]
set_property PACKAGE_PIN B4  [get_ports VGA_R[1]]
set_property PACKAGE_PIN C5  [get_ports VGA_R[2]]
set_property PACKAGE_PIN D5  [get_ports VGA_R[3]]
# Green
set_property PACKAGE_PIN A1  [get_ports VGA_G[0]]
set_property PACKAGE_PIN B1  [get_ports VGA_G[1]]
set_property PACKAGE_PIN C1  [get_ports VGA_G[2]]
set_property PACKAGE_PIN D1  [get_ports VGA_G[3]]
# Blue
set_property PACKAGE_PIN E1  [get_ports VGA_B[0]]
set_property PACKAGE_PIN F1  [get_ports VGA_B[1]]
set_property PACKAGE_PIN G1  [get_ports VGA_B[2]]
set_property PACKAGE_PIN H1  [get_ports VGA_B[3]]
# Sync signals
set_property PACKAGE_PIN J1  [get_ports VGA_HS]
set_property PACKAGE_PIN K1  [get_ports VGA_VS]

## 7-Segment Display: Example for segment A and segment B (add the rest)
set_property PACKAGE_PIN L18 [get_ports CA[0]]
set_property PACKAGE_PIN M18 [get_ports CA[1]]
# Continue for CB and other segments as per your design

## Joystick Analog Inputs (JA header example, if used)
set_property PACKAGE_PIN T9  [get_ports JA1]
set_property PACKAGE_PIN U9  [get_ports JA2]
