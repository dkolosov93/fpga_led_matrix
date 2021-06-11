# clocks
create_clock -name CLK12M -period 12mhz [get_ports CLK12M]

# Automatically apply a generate clock on the output of phase-locked loops (PLLs)
# This command can be safely left in the SDC even if no PLLs exist in the design
derive_pll_clocks

# false paths
set_false_path -from [get_ports {BTN RESET}]
set_false_path -to [get_ports {LED[0] LED[1] LED[2] LED[3] LED[4] LED[5] LED[6] LED[7]}]