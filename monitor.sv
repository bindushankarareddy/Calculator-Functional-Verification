// Define the Monitor interface: 
`define CALC_MONITOR_IF	calc_monitor_if.monitor_cb

// Include the transaction, dut_out and interface units
`include "hdl/Transaction.sv"
`include "hdl/DUTA.sv"
`include "hdl/IF.sv"

class monitor;
		bit start_signa;
	int trans_cnt = 0;
	int total_ALU_count=0, total_shift_count=0,total_nop_count=0;
	
	int ALU_count 	=0; 
	int Shift_count 	=0; 
	int nop_count	=0; 
	
	// Handle for the class dut_out
	Transaction to_dut_count;
	dut_out_ALL obj_to_DUT_ALL;

	
	virtual calc_inter.monitor calc_monitor_if;	// Virtual interface for calc_monitor
	mailbox #(Transaction) gen2mon;				  	// mailbox to send data from gen to monitor.
    mailbox #(dut_out_ALL) mon2scb_ALL;					// mailbox to send the data from the monitor to scoreboard.
  
  
	// Constructor Function: 
	function new(virtual calc_inter.monitor calc_monitor_if,mailbox #(dut_out_ALL) mon2scb_ALL,mailbox #(Transaction) gen2mon, bit start_signa = 0); 
		this.calc_monitor_if = calc_monitor_if;
		this.mon2scb_ALL = mon2scb_ALL;
		this.gen2mon   = gen2mon;
		this.start_signa = start_signa;
	endfunction : new
  
	// Main Task:
	task main(); 
		to_dut_count = new();
		obj_to_DUT_ALL= new();
		gen2mon.get(to_dut_count);
		
		total_ALU_count= to_dut_count.ALU_count;/// to keep a count on alu and shift operations
		total_shift_count= to_dut_count.Shift_count ;
		total_nop_count= to_dut_count.nop_count;
		
		this.ALU_count 	=to_dut_count.ALU_count;         ///noting down the ALU and Shift operations
		
		this.Shift_count 	=to_dut_count.Shift_count;
		
		this.nop_count	=to_dut_count.nop_count;
	
		forever begin
		
		if (total_ALU_count > 0 || total_shift_count > 0 || total_nop_count > 0)     ///indicating that there is an operation to be done
		//if(to_dut_count.reqcmd_a>=0 || to_dut_count.reqcmd_b>=0 || to_dut_count.reqcmd_c>=0 || to_dut_count.reqcmd_d>=0 )
		begin 
		fork
			begin
			@(`CALC_MONITOR_IF.out_dataa or `CALC_MONITOR_IF.out_respa == 0 or `CALC_MONITOR_IF.out_respa == 1 or `CALC_MONITOR_IF.out_respa == 2 or `CALC_MONITOR_IF.out_respa == 3);
			$display("\n",$time, "Monitor Recieving data from Dut Port -A");
			obj_to_DUT_ALL.out_respa = `CALC_MONITOR_IF.out_respa;
			obj_to_DUT_ALL.out_dataa = `CALC_MONITOR_IF.out_dataa;
			obj_to_DUT_ALL.out_tag_a = `CALC_MONITOR_IF.out_tag_a;
			$display($time," out_respa %h",obj_to_DUT_ALL.out_respa);
			$display($time," out_dataa %h",obj_to_DUT_ALL.out_dataa);
			$display($time," out_tag_a %h",obj_to_DUT_ALL.out_tag_a);
			//mon2scb_ALL.put(obj_to_DUT_ALL);  
			end
			
			begin
			@(`CALC_MONITOR_IF.out_datab or `CALC_MONITOR_IF.out_respb == 0 or `CALC_MONITOR_IF.out_respb == 1 or `CALC_MONITOR_IF.out_respb == 2 or `CALC_MONITOR_IF.out_respb == 3);
			$display("\n",$time, " Monitor Recieving data from Dut Port -B"); 
			obj_to_DUT_ALL.out_respb = `CALC_MONITOR_IF.out_respb;
			obj_to_DUT_ALL.out_datab = `CALC_MONITOR_IF.out_datab;
			obj_to_DUT_ALL.out_tag_b = `CALC_MONITOR_IF.out_tag_b;
			$display($time," out_respb %h",obj_to_DUT_ALL.out_respb);
			$display($time," out_datab %h",obj_to_DUT_ALL.out_datab);
			$display($time," out_tag_b %h",obj_to_DUT_ALL.out_tag_b);
			//mon2scb_ALL.put(obj_to_DUT_ALL); 
			end
			
			begin
			@(`CALC_MONITOR_IF.out_datac or `CALC_MONITOR_IF.out_respc == 0 or `CALC_MONITOR_IF.out_respc == 1 or `CALC_MONITOR_IF.out_respc == 2 or `CALC_MONITOR_IF.out_respc == 3);
			$display("\n",$time, "Monitor Recieving data from Dut Port-C");	
			obj_to_DUT_ALL.out_respc = `CALC_MONITOR_IF.out_respc;
			obj_to_DUT_ALL.out_datac = `CALC_MONITOR_IF.out_datac;
			obj_to_DUT_ALL.out_tag_c = `CALC_MONITOR_IF.out_tag_c;
			$display($time," out_respc %h",obj_to_DUT_ALL.out_respc);
			$display($time," out_datac %h",obj_to_DUT_ALL.out_datac);
			$display($time," out_tag_c %h",obj_to_DUT_ALL.out_tag_c);
			//mon2scb_ALL.put(obj_to_DUT_ALL);  
			end
			
			begin
			@(`CALC_MONITOR_IF.out_datad or `CALC_MONITOR_IF.out_respd == 0 or `CALC_MONITOR_IF.out_respd == 1 or `CALC_MONITOR_IF.out_respd == 2 or `CALC_MONITOR_IF.out_respd == 3);
			$display("\n",$time, "Monitor Recieving data from Dut Port-D");
			obj_to_DUT_ALL.out_respd = `CALC_MONITOR_IF.out_respd;
			obj_to_DUT_ALL.out_datad = `CALC_MONITOR_IF.out_datad;
			obj_to_DUT_ALL.out_tag_d = `CALC_MONITOR_IF.out_tag_d;
			$display($time," out_respd %h",obj_to_DUT_ALL.out_respd);
			$display($time," out_datad %h\n",obj_to_DUT_ALL.out_datad);
			$display($time," out_tag_d %h\n",obj_to_DUT_ALL.out_tag_d);
			mon2scb_ALL.put(obj_to_DUT_ALL);
			end
			join
		end
					#120;			
		if (start_signa)
		  begin
			obj_to_DUT_ALL.print_responseA("monitor");
			end
		end
	endtask

endclass 
