`ifndef DUT_AA
`define DUT_AA
class dut_out_ALL; 
    bit [0:1] out_respa;
    bit [0:1] out_tag_a;
    bit [0:31] out_dataa;
	 
	 bit [0:1] out_respb;
    bit [0:1] out_tag_b;
    bit [0:31] out_datab;
	
	bit [0:1] out_respc;
    bit [0:1] out_tag_c;
    bit [0:31] out_datac;
	
	bit [0:1] out_respd;
    bit [0:1] out_tag_d;
    bit [0:31] out_datad;
     
	function void print_responseA(string DUT_A);
		$display ("\n",$time," : %s PORTA response : %h  out-data1 : %h out-tag1 : %h",DUT_A, this.out_respa, this.out_dataa, this.out_tag_a);
		$display ("\n",$time," : %s PORTB response : %h  out-data1 : %h out-tag1 : %h",DUT_A, this.out_respb, this.out_datab, this.out_tag_b);
		$display ("\n",$time," : %s PORTC response : %h  out-data1 : %h out-tag1 : %h",DUT_A, this.out_respc, this.out_datac, this.out_tag_c);
		$display ("\n",$time," : %s PORTD response : %h  out-data1 : %h out-tag1 : %h",DUT_A, this.out_respd, this.out_datad, this.out_tag_d);

endfunction 

 endclass
`endif 