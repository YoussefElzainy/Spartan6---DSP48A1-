# ================================
# DSP48A1 Constraint File for xc7a200tffg1156-3
# Clock frequency: 100 MHz
# ================================

# Clock constraint
create_clock -period 10.0 [get_ports clk]
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Reset signals (active high)
set_property PACKAGE_PIN <pin_RSTA> [get_ports RSTA]
set_property IOSTANDARD LVCMOS33 [get_ports RSTA]

set_property PACKAGE_PIN <pin_RSTB> [get_ports RSTB]
set_property IOSTANDARD LVCMOS33 [get_ports RSTB]

set_property PACKAGE_PIN <pin_RSTC> [get_ports RSTC]
set_property IOSTANDARD LVCMOS33 [get_ports RSTC]

set_property PACKAGE_PIN <pin_RSTCARRYIN> [get_ports RSTCARRYIN]
set_property IOSTANDARD LVCMOS33 [get_ports RSTCARRYIN]

set_property PACKAGE_PIN <pin_RSTD> [get_ports RSTD]
set_property IOSTANDARD LVCMOS33 [get_ports RSTD]

set_property PACKAGE_PIN <pin_RSTM> [get_ports RSTM]
set_property IOSTANDARD LVCMOS33 [get_ports RSTM]

set_property PACKAGE_PIN <pin_RSTOPMODE> [get_ports RSTOPMODE]
set_property IOSTANDARD LVCMOS33 [get_ports RSTOPMODE]

set_property PACKAGE_PIN <pin_RSTP> [get_ports RSTP]
set_property IOSTANDARD LVCMOS33 [get_ports RSTP]

# Clock enable signals
set_property PACKAGE_PIN <pin_CEA> [get_ports CEA]
set_property IOSTANDARD LVCMOS33 [get_ports CEA]

set_property PACKAGE_PIN <pin_CEB> [get_ports CEB]
set_property IOSTANDARD LVCMOS33 [get_ports CEB]

set_property PACKAGE_PIN <pin_CEC> [get_ports CEC]
set_property IOSTANDARD LVCMOS33 [get_ports CEC]

set_property PACKAGE_PIN <pin_CECARRYIN> [get_ports CECARRYIN]
set_property IOSTANDARD LVCMOS33 [get_ports CECARRYIN]

set_property PACKAGE_PIN <pin_CED> [get_ports CED]
set_property IOSTANDARD LVCMOS33 [get_ports CED]

set_property PACKAGE_PIN <pin_CEM> [get_ports CEM]
set_property IOSTANDARD LVCMOS33 [get_ports CEM]

set_property PACKAGE_PIN <pin_CEOPMODE> [get_ports CEOPMODE]
set_property IOSTANDARD LVCMOS33 [get_ports CEOPMODE]

set_property PACKAGE_PIN <pin_CEP> [get_ports CEP]
set_property IOSTANDARD LVCMOS33 [get_ports CEP]

# DSP Inputs
# A[17:0]
set_property PACKAGE_PIN <pin_A0> [get_ports {A[0]}]
set_property PACKAGE_PIN <pin_A1> [get_ports {A[1]}]
# Repeat for A[2] to A[17]

# B[17:0]
set_property PACKAGE_PIN <pin_B0> [get_ports {B[0]}]
set_property PACKAGE_PIN <pin_B1> [get_ports {B[1]}]
# Repeat for B[2] to B[17]

# C[47:0]
set_property PACKAGE_PIN <pin_C0> [get_ports {C[0]}]
# Repeat for C[1] to C[47]

# D[17:0]
set_property PACKAGE_PIN <pin_D0> [get_ports {D[0]}]
# Repeat for D[1] to D[17]

# Control & Cascade ports
set_property PACKAGE_PIN <pin_OPMODE> [get_ports OPMODE]
set_property IOSTANDARD LVCMOS33 [get_ports OPMODE]

set_property PACKAGE_PIN <pin_CARRYIN> [get_ports CARRYIN]
set_property IOSTANDARD LVCMOS33 [get_ports CARRYIN]

set_property PACKAGE_PIN <pin_BCIN> [get_ports BCIN]
set_property IOSTANDARD LVCMOS33 [get_ports BCIN]

set_property PACKAGE_PIN <pin_PCIN> [get_ports PCIN]
set_property IOSTANDARD LVCMOS33 [get_ports PCIN]

# DSP Outputs
# M[35:0]
set_property PACKAGE_PIN <pin_M0> [get_ports {M[0]}]
# Repeat for M[1] to M[35]

# P[47:0]
set_property PACKAGE_PIN <pin_P0> [get_ports {P[0]}]
# Repeat for P[1] to P[47]

set_property PACKAGE_PIN <pin_CARRYOUT> [get_ports CARRYOUT]
set_property IOSTANDARD LVCMOS33 [get_ports CARRYOUT]

set_property PACKAGE_PIN <pin_CARRYOUTF> [get_ports CARRYOUTF]
set_property IOSTANDARD LVCMOS33 [get_ports CARRYOUTF]

set_property PACKAGE_PIN <pin_BCOUT> [get_ports BCOUT]
set_property IOSTANDARD LVCMOS33 [get_ports BCOUT]

set_property PACKAGE_PIN <pin_PCOUT> [get_ports PCOUT]
set_property IOSTANDARD LVCMOS33 [get_ports PCOUT]