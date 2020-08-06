`include "hdl/Transaction.sv"
`include "hdl/IF.sv"
`include "hdl/driver.sv"
`include "hdl/monitor.sv"
`include "hdl/gen.sv"
`include "hdl/scoreboard.sv"
`include "hdl/DUTA.sv"

import PA::coverage; 
class setting_maxcount;  
	rand int trans_cnt;
	constraint count {(trans_cnt >0) && (trans_cnt <= 50);}
  
endclass: setting_maxcount

// Class Environment
class env;
  
	setting_maxcount obj_max_tran_count;	 
 	gen gen;		
	Driver drv;	 
	monitor mon;	
	scoreboard scb;
	coverage cove;		
  
	mailbox #(Transaction) gen2drv, gen2scb, gen2mon; 
	mailbox #(dut_out_ALL)mon2scb_ALL;              
	virtual calc_inter cif; // Virtual interface to calc.
	// Constructor:
	function new(virtual calc_inter cif);
    
		this.cif = cif;
		gen2drv = new();	
		gen2scb = new();    
		gen2mon = new();   
		mon2scb_ALL = new();    
		
		obj_max_tran_count = new();  
		
		if (!obj_max_tran_count.randomize()) 
		begin
			$display("obj_max_tran_count::randomize failed");
			$finish;
		end

		gen      = new(gen2drv,gen2scb,gen2mon, obj_max_tran_count.trans_cnt, 1);/// here 1 is nothing but we are sending a bit to kick start the operation on tranaction obeject 
		drv      = new(this.cif, gen2drv, 1);
		mon      = new(this.cif, mon2scb_ALL,gen2mon);
		scb      = new(obj_max_tran_count.trans_cnt, gen2scb, mon2scb_ALL);
    cove=new();

	endfunction: new
	
	virtual task before_start();	 
		
		fork
			drv.main();
			mon.main();
			scb.main();
		join_none
	endtask

	virtual task test();	// Virtual function to reset driver and perform the generation operation.
		drv.reset();
		fork
			gen.main();
		join_none
	endtask

	virtual task wait_until_finish();
		fork
			wait(gen.ended.triggered);
			wait(scb.ended.triggered);
		join
	endtask: wait_until_finish

	task run();
		before_start();
			test();
		wait_until_finish();
	endtask
endclass
