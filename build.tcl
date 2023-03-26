create_project cdc ./ -part xc7a100tcsg324-1

add_files -norecurse ./ip/clocking_wizard.xcix
add_files -norecurse ./ip/fifo.xcix
add_files -norecurse ./cdc.sv
update_compile_order -fileset sources_1
add_files -fileset constrs_1 -norecurse ./cdc.xdc

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
puts "Implementation done!"

open_run impl_1

create_waiver -type CDC -id CDC-13 -description {Xilinx IP} \
-from [get_pins cdc_fifo/U0/inst_fifo_gen/gconvfifo.rf/gbi.bi/g7ser_birst.rstbt/rsync.ric.power_on_wr_rst_reg[0]/C] \
-to [get_pins cdc_fifo/U0/inst_fifo_gen/gconvfifo.rf/gbi.bi/v7_bi_fifo.fblk/gextw[1].gnll_fifo.inst_extd/gonep.inst_prim/gf18e1_inst.sngfifo18e1/RST]

report_cdc -details -file ./cdc_report.txt

