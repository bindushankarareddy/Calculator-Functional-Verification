// Define the Calc Driver interface: 
`define inter_driv_poin interfhandl.driver_cb

// Include the transaction and interface files:
`include "hdl/Transaction.sv"
`include "hdl/IF.sv"

// Class Driver: 
class Driver;
	
	virtual calc_inter.driver interfhandl;
    Transaction trans; // Create handle for the class transaction.
    mailbox #(Transaction) gen2drv; // Mailbox to receive data from generator and pass the same to scoreboard.
  
	bit start_signa;	  
	
	// Constructor:
	function new (virtual calc_inter.driver interfhandl, mailbox #(Transaction) gen2drv, bit start_signa = 0);
		this.interfhandl = interfhandl;
		this.gen2drv = gen2drv;
		this.start_signa = start_signa;
	endfunction: new

	// Main Task: 
	task main();  

		if (start_signa)
		$display($time," : ------------starting calculator_driver's operation----------\n");
  
		forever begin
    
		gen2drv.get(trans); // Use mailbox and receive the data that was sent from the generator. 
    
		if (start_signa)
			trans.print_trans("Driver");  
   
		if (trans.reset == 0) begin
			cmd_data_send();
			#1000;
		end  
		else begin
			reset();
		end
		end 
  
		if (start_signa)
			$display($time," : ending driver transaction \n"); 

	endtask : main

task reset();
  `inter_driv_poin.reset <= 1'b1;
  `inter_driv_poin.reqcmd_a <= 4'b0000;
  `inter_driv_poin.reqa_dataa_in <= 32'h00000000;
  `inter_driv_poin.reqtag_a <= 2'b00;
 
  
  `inter_driv_poin.reqcmd_b <= 4'b0000;
  `inter_driv_poin.reqb_dataa_in <= 32'h00000000;
  `inter_driv_poin.reqtag_b <= 2'b00;
  
  
  `inter_driv_poin.reqcmd_c <= 4'b0000;
  `inter_driv_poin.reqc_dataa_in <= 32'h00000000;
  `inter_driv_poin.reqtag_c <= 2'b00;
  
  
  `inter_driv_poin.reqcmd_d <= 4'b0000;
  `inter_driv_poin.reqd_dataa_in <= 32'h00000000;
  `inter_driv_poin.reqtag_d <= 2'b00;
   
  @`inter_driv_poin; ///// to given reset complete 7 cycles we introduce 3 cycles delay here after clearing out the ports.
  @`inter_driv_poin;
  @`inter_driv_poin;
  `inter_driv_poin.reset <= 1'b0;
  $display ($time, " : reset complete \n");
  endtask : reset   

	// Task to send command and data: 
	task cmd_data_send();
	begin
	
		@`inter_driv_poin;
   
		$display("\n",$time," : ------------Sending data-1 to all ports of device under test DUT----------");
    
		// PORT-A:
		`inter_driv_poin.reqcmd_a <= trans.reqcmd_a;
		`inter_driv_poin.reqa_dataa_in <= trans.reqa_dataa_in;
		`inter_driv_poin.reqtag_a <= trans.reqtag_a;
		$display("\n",$time,": 1 trans.my_cmda %h",trans.reqcmd_a);
		$display($time,": 1 trans.my_dataa %h",trans.reqa_dataa_in);
		$display($time,": 1 trans.reqtag_a %h",trans.reqtag_a);
		// PORT-B:
		`inter_driv_poin.reqcmd_b <= trans.reqcmd_b;
		`inter_driv_poin.reqb_dataa_in <= trans.reqb_dataa_in;
		`inter_driv_poin.reqtag_b <= trans.reqtag_b;
		$display($time,": 2 trans.my_cmdb %h",trans.reqcmd_b);
		$display($time,": 2 trans.my_datab %h",trans.reqb_dataa_in);
		$display($time,": 2 trans.reqtag_b %h",trans.reqtag_b);
		// PORT-C:
		`inter_driv_poin.reqcmd_c <= trans.reqcmd_c;
		`inter_driv_poin.reqc_dataa_in <= trans.reqc_dataa_in;
		`inter_driv_poin.reqtag_c <= trans.reqtag_c;
		$display($time,": 3 trans.my_cmdc %h",trans.reqcmd_c);
		$display($time,": 3 trans.my_datac %h",trans.reqc_dataa_in);
		$display($time,": 3 trans.reqtag_c %h",trans.reqtag_c);
		// PORT-D:
		`inter_driv_poin.reqcmd_d <= trans.reqcmd_d;
		`inter_driv_poin.reqd_dataa_in <= trans.reqd_dataa_in;
		`inter_driv_poin.reqtag_d <= trans.reqtag_d;
		$display($time,": 4 trans.my_cmdd %h",trans.reqcmd_d);
		$display($time,": 4 trans.my_datad %h",trans.reqd_dataa_in);
		$display($time,": 4 trans.reqtag_d %h\n",trans.reqtag_d);

		//------------------------------------------------now data2 is passed after data1 in same channel--------------------------------------------	
		@`inter_driv_poin;
	   
		$display("\n",$time," : ------------Sending data-2 on all port of dut----------");
		// PORT-A:
		`inter_driv_poin.reqcmd_a <= 4'b0000;
		`inter_driv_poin.reqa_dataa_in <= trans.reqa_datab_in;
		// `inter_driv_poin.reqtag_a <= 2'b00;
		$display("\n",$time,": 1 trans.my_cmda %h",trans.reqcmd_a);
		// $display($time,": 1 trans.my_dataa %h",trans.reqtag_a);
		$display($time," : 1 trans.my_datab %h",trans.reqa_datab_in);
		// PORT-B: 
		`inter_driv_poin.reqcmd_b <= 4'b0000;
		`inter_driv_poin.reqb_dataa_in <= trans.reqb_datab_in;
		// `inter_driv_poin.reqtag_b <= 2'b00;
		$display($time,": 2 trans.my_cmdb %h",trans.reqcmd_b);
		// $display($time,": 2 trans.reqtag_b %h",trans.reqtag_b);
		$display($time," : 2 trans.my_datab %h",trans.reqb_datab_in);
		// PORT-C: 
		`inter_driv_poin.reqcmd_c <= 4'b0000;
		`inter_driv_poin.reqc_dataa_in <= trans.reqc_datab_in;
		// `inter_driv_poin.reqtag_c <= 2'b00;
		$display($time,": 3 trans.my_cmdc %h",trans.reqcmd_c);
		// $display($time,": 3 trans.reqtag_c %h",trans.reqtag_c);
		$display($time," : 3 trans.my_datab %h",trans.reqc_datab_in);
		// PORT-D:
		`inter_driv_poin.reqcmd_d <= 4'b0000;
		`inter_driv_poin.reqd_dataa_in <= trans.reqd_datab_in;
		// `inter_driv_poin.reqtag_d <= 2'b00;
		$display($time,": 4 trans.my_cmdd %h",trans.reqcmd_d);
		// $display($time,": 4 trans.reqtag_d %h\n",trans.reqtag_d);
		$display($time," : 4 trans.my_datab %h\n",trans.reqd_datab_in);
	  
	end
	endtask : cmd_data_send

endclass : Driver
