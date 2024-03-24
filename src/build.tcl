set_device GW5A-LV25MG121NES

set_option -verilog_std sysv2017
set_option -top_module top
set_option -use_cpu_as_gpio 1
set_option -use_sspi_as_gpio 1

add_file dgprtl/latchingcounter.v
add_file bramwrapper.v
add_file dblcdintf.v
add_file hdmiintf.v
add_file framebuffer.v
add_file pixelgenerator.v
add_file top.v
add_file tang25k.cst
add_file tang25k.sdc


run all
