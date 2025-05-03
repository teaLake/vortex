###################################################################

# Created by write_sdc on Fri May  2 01:45:00 2025

###################################################################
set sdc_version 1.9

set_units -time ps -resistance kOhm -capacitance fF -voltage V -current uA
set_max_fanout 20 [get_ports clk]
set_max_fanout 20 [get_ports reset]
set_propagated_clock [get_ports clk]
create_clock [get_ports clk]  -period 2500  -waveform {0 1250}
set_false_path   -from [get_ports reset]
