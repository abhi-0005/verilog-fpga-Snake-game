## Clock
set_property PACKAGE_PIN W5 [get_ports CLK100MHZ]
set_property IOSTANDARD LVCMOS33 [get_ports CLK100MHZ]

## Buttons (Directional Control)
# Center Button (Used for Reset)
set_property PACKAGE_PIN U18 [get_ports BTNC]
set_property IOSTANDARD LVCMOS33 [get_ports BTNC]
# Up Button
set_property PACKAGE_PIN T18 [get_ports BTNU]
set_property IOSTANDARD LVCMOS33 [get_ports BTNU]
# Left Button
set_property PACKAGE_PIN W19 [get_ports BTNL]
set_property IOSTANDARD LVCMOS33 [get_ports BTNL]
# Right Button
set_property PACKAGE_PIN T17 [get_ports BTNR]
set_property IOSTANDARD LVCMOS33 [get_ports BTNR]
# Down Button
set_property PACKAGE_PIN U17 [get_ports BTND]
set_property IOSTANDARD LVCMOS33 [get_ports BTND]

## VGA output
set_property PACKAGE_PIN G19 [get_ports {VGA_R[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[0]}]
set_property PACKAGE_PIN H19 [get_ports {VGA_R[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[1]}]
set_property PACKAGE_PIN J19 [get_ports {VGA_R[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[2]}]
set_property PACKAGE_PIN N19 [get_ports {VGA_R[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[3]}]
set_property PACKAGE_PIN J17 [get_ports {VGA_G[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[0]}]
set_property PACKAGE_PIN H17 [get_ports {VGA_G[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[1]}]
set_property PACKAGE_PIN G17 [get_ports {VGA_G[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[2]}]
set_property PACKAGE_PIN D17 [get_ports {VGA_G[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[3]}]
set_property PACKAGE_PIN N18 [get_ports {VGA_B[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[0]}]
set_property PACKAGE_PIN L18 [get_ports {VGA_B[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[1]}]
set_property PACKAGE_PIN K18 [get_ports {VGA_B[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[2]}]
set_property PACKAGE_PIN J18 [get_ports {VGA_B[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[3]}]
set_property PACKAGE_PIN P19 [get_ports VGA_HS]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_HS]
set_property PACKAGE_PIN R19 [get_ports VGA_VS]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_VS]

## 7-Segment Display (Ensure these match your CA/CB port widths)
set_property PACKAGE_PIN W7 [get_ports {CA[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CA[0]}]
set_property PACKAGE_PIN W6 [get_ports {CA[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {CA[1]}]
# ... (Add remaining segments CA[2-6] and CB as needed)

# REMOVED: Joystick Analog Inputs (JA1, JA2) are no longer needed.
