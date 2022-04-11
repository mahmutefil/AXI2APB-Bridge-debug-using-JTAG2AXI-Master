
# reset jtag-axi debug core
reset_hw_axi [get_hw_axis hw_axi_1]

proc WriteReg {address data} {
#set address [format "0x%08X" $address];
#set data [format "0x%08X" $data];
create_hw_axi_txn wr_txn_lite [get_hw_axis hw_axi_1] -address $address -data $data -type write -force

run_hw_axi wr_txn_lite -queue
#set write_value "write value for address $address is " 
set write_value [lindex [report_hw_axi_txn wr_txn_lite] 1 ]; #0 addr 1 data verir
set wdata [lindex [report_hw_axi_txn wr_txn_lite] 1 ]
delete_hw_axi_txn wr_txn_lite
return $write_value 
}
proc ReadReg {address} {
#set address [format "0x%08X" $address];
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address $address -type read -force

run_hw_axi rd_txn_lite -queue
#set read_value "read value for address $address is " 
set read_value [lindex [report_hw_axi_txn rd_txn_lite] 1]; #0 addr 1 data verir

delete_hw_axi_txn rd_txn_lite 
return $read_value
}

set mismatch_cnt 0;
set match_cnt 0;



set file_name "C:/Users/mahmu/JTAG2AXI_revised/data.txt"; 
set fp [open $file_name w+]; 
set a 00000000
set hex 0
while {$a <= 10000} {
set data_list_w [WriteReg $a [ format 0x%08X [expr {$a + $hex}] ]]
puts $fp $data_list_w ; 

set data_list_r [ReadReg $a ]
puts $fp $data_list_r ; 		 		 

if {$data_list_r == $data_list_w } {
incr match_cnt 1;
} else {
incr mismatch_cnt 1;
}

incr a [ format 0x%08X [expr {00000001}] ];
set a [format 0x%08x $a]

incr hex [ format 0x%08X [expr {00000001}] ];
set hex [format 0x%08x $hex]

}
set a  "Match count is "
append a $match_cnt
set b  "Mismatch count is "
append b $mismatch_cnt
puts $fp $a
puts $fp $b

close $fp;



#set data_list_w [WriteReg 00000004 00000066][ WriteReg 00000008 12345678][ WriteReg 00000010 00000444];
#set data_list_r [ReadReg 00000004][ReadReg 00000008][ReadReg 00000010];


if 0 {
create_hw_axi_txn wr_txn_lite [get_hw_axis hw_axi_1] -address 000000fe -data 12345678 -type write -force; #254
create_hw_axi_txn wr_txn_lite1 [get_hw_axis hw_axi_1] -address 000000ff -data 12345678 -type write -force; #255
create_hw_axi_txn wr_txn_lite2 [get_hw_axis hw_axi_1] -address 00000100 -data 12345678 -type write -force; #256
create_hw_axi_txn wr_txn_lite3 [get_hw_axis hw_axi_1] -address 00000101 -data 12345678 -type write -force; #257
create_hw_axi_txn rd_txn_lite [get_hw_axis hw_axi_1] -address 000000fe -type read -force;
create_hw_axi_txn rd_txn_lite1 [get_hw_axis hw_axi_1] -address 000000ff -type read -force;
create_hw_axi_txn rd_txn_lite2 [get_hw_axis hw_axi_1] -address 00000100 -type read -force;
create_hw_axi_txn rd_txn_lite3 [get_hw_axis hw_axi_1] -address 00000101 -type read -force;

run_hw_axi wr_txn_lite wr_txn_lite1 wr_txn_lite2 wr_txn_lite3  -queue
run_hw_axi  rd_txn_lite rd_txn_lite1 rd_txn_lite2 rd_txn_lite3 -queue
}
