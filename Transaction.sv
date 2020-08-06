`ifndef tran_DEFINE
`define tran_DEFINE
class Transaction;
 
	//  user defined Data types for request command and input data: 
	typedef logic [0:3] command;
	typedef logic [0:1] tag;
	typedef logic [0:31] data;
 
	// Randomize the request command: 
	rand command reqcmd_a;
	rand command reqcmd_b;
	rand command reqcmd_c;
	rand command reqcmd_d;
	
	// Randomize the request tag: 
	randc tag reqtag_a;
	randc tag reqtag_b;
	randc tag reqtag_c;
	randc tag reqtag_d;	
	
	// Request command can have any one of the values: 0,1,2,5,6:
	constraint reqcmd1 {reqcmd_a inside {0,3,4,7};}
	constraint reqcmd2 {reqcmd_b inside {1,2,5,6};}
	constraint reqcmd3 {reqcmd_c inside {1,2,5,6};}
	constraint reqcmd4 {reqcmd_d inside {1,2,5,6};}
	
	// Request tag can have any one of the values: 0,1,2,3:
	constraint reqtag_a_1 {reqtag_a inside {0,1,2,3};}
	constraint reqtag_b_2 {reqtag_b inside {0,1,2,3};}
	constraint reqtag_c_3 {reqtag_c inside {0,1,2,3};}
	constraint reqtag_d_4 {reqtag_d inside {0,1,2,3};}	
	
	// Randomize the Input Data_a and Input Data_b on all the ports  
	rand data reqa_dataa_in, reqa_datab_in;
	rand data reqb_dataa_in, reqb_datab_in;  
	rand data reqc_dataa_in, reqc_datab_in;
	rand data reqd_dataa_in, reqd_datab_in;

	// Reset 
	bit reset = 0;
 int ALU_count=0, Shift_count=0, nop_count=0;
	


	// Function to print the data genarated and randomized
	function void print_trans(string name);
   		$display ($time," : %s PORTA operation is : %d  dataa : %h datab : %h	tag: %h ALU_count: %d Shift_count: %d nop_count: %d",name, this.reqcmd_a, this.reqa_dataa_in, this.reqa_datab_in, this.reqtag_a, this.ALU_count, this.Shift_count, this.nop_count);
		$display ($time," : %s PORTB operation is : %d  dataa : %h datab : %h	tag: %h ALU_count: %d Shift_count: %d nop_count: %d",name, this.reqcmd_b, this.reqb_dataa_in, this.reqb_datab_in, this.reqtag_b, this.ALU_count, this.Shift_count, this.nop_count);
		$display ($time," : %s PORTC operation is : %d  dataa : %h datab : %h	tag: %h ALU_count: %d Shift_count: %d nop_count: %d",name, this.reqcmd_c, this.reqc_dataa_in, this.reqc_datab_in, this.reqtag_c, this.ALU_count, this.Shift_count, this.nop_count);
		$display ($time," : %s PORTD operation is : %d  dataa : %h datab : %h	tag: %h ALU_count: %d Shift_count: %d nop_count: %d",name, this.reqcmd_d, this.reqd_dataa_in, this.reqd_datab_in, this.reqtag_d, this.ALU_count, this.Shift_count, this.nop_count);
	endfunction: print_trans
 
	//function to count alu and shift operation
	function void counting_operations(reqcmd_a,reqcmd_b,reqcmd_c,reqcmd_d);		
		if (this.reqcmd_a == 1 || this.reqcmd_a == 2)
			this.ALU_count++;
		if (this.reqcmd_b == 1 || this.reqcmd_b == 2)
			this.ALU_count++;
		if (this.reqcmd_c == 1 || this.reqcmd_c == 2)
			this.ALU_count++;
		if (this.reqcmd_d == 1 || this.reqcmd_d == 2)
			this.ALU_count++;			
		if (this.reqcmd_a == 5 || this.reqcmd_a == 6)
			this.Shift_count++;
		if (this.reqcmd_b == 5 || this.reqcmd_b == 6)
			this.Shift_count++;
		if (this.reqcmd_c == 5 || this.reqcmd_c == 6)
			this.Shift_count++;
		if (this.reqcmd_d == 5 || this.reqcmd_d == 6)
			this.Shift_count++;
		if (this.reqcmd_a == 0)
			this.nop_count++;
		if (this.reqcmd_b == 0)
			this.nop_count++;
		if (this.reqcmd_c == 0)
			this.nop_count++;
		if (this.reqcmd_d == 0)
			this.nop_count++;
	$display ($time," dataa : %h datab : %h	tag: %h ALU_count: %d Shift_count: %d nop_count: %d",this.reqcmd_a, this.reqa_dataa_in, this.reqa_datab_in, this.reqtag_a, this.ALU_count, this.Shift_count, this.nop_count);
endfunction
endclass: Transaction
`endif 


