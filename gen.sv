// Include the transaction file 
`include "hdl/Transaction.sv"
import PA::coverage;
class gen;
	
	// Handle for the class transaction: 
	rand Transaction trans,trans1,trans2; 
	int trans_cnt1 = 0;
	bit start_signa;
	int max_trans_cnt;
	event ended;

	mailbox #(Transaction) gen2drv,gen2scb,gen2mon; // Mailbox to send data from generator to driver,monitor and the scoreboard. 
coverage cove;
	// Constructor: 
	function new(mailbox #(Transaction) gen2drv,mailbox #(Transaction) gen2scb,mailbox #(Transaction) gen2mon, int max_trans_cnt,
	bit start_signa = 0, int trans_cnt1 = 0);
	trans2 = new();
	cove=new();
		//.reqcmd_a, .reqtag_a, .reqa_dataa_in, .reqa_datab_in, .reqcmd_b, .reqtag_b, .reqb_dataa_in ,.reqb_datab_in ,.reqcmd_c, .reqtag_c, .reqc_dataa_in, .reqc_datab_in, .reqcmd_d, .reqtag_d,	.reqd_dataa_in, .reqd_datab_in );
		this.gen2drv = gen2drv;
        this.gen2scb = gen2scb;
		this.gen2mon = gen2mon;
		this.start_signa = start_signa;
		this.max_trans_cnt = max_trans_cnt;

	endfunction

	// Main Task:
	 task main();
     while(!end_test())    
     begin
     trans=re_fun();
    // cove.funcov ( trans1.reqcmd_a,trans1.reqcmd_b,trans1.reqcmd_c,trans1.reqcmd_d, trans1.reqa_dataa_in, trans1.reqa_datab_in, trans1.reqb_dataa_in, trans1.reqb_datab_in,trans1.reqc_dataa_in, trans1.reqc_datab_in,trans1.reqd_dataa_in, trans1.reqd_datab_in);
       
      //if( !trans.randomize() ) $fatal("Generator transaction randomization failed");
			if (start_signa)
				$display($time," : generator transaction count no. %d", trans_cnt1);
			gen2drv.put(trans); 			 
      gen2scb.put(trans);     	
			gen2mon.put(trans);				
      trans.print_trans("generator to scoreboard"); 
			trans.counting_operations(trans.reqcmd_a,trans.reqcmd_b,trans.reqcmd_c,trans.reqcmd_d);
			trans_cnt1++;	
			trans.print_trans("generator");  		
    end
	-> ended;
		$display ($time," maximum transcation is %d",trans_cnt1 );
  endtask
  
  virtual function bit end_test();
		end_test = trans_cnt1>=max_trans_cnt;
	endfunction
virtual function Transaction re_fun();        ////here it is important we create a copy of the transaction function to fill it in coerage bins so that it accumulates at the same time pass the newly randomized data generated 
 Transaction trans1=new();
 if( !trans1.randomize() ) $fatal("Generator transaction randomization failed");
    trans2.reqcmd_a   = trans1.reqcmd_a;
		trans2.reqa_dataa_in = trans1.reqa_dataa_in;
		trans2.reqa_datab_in = trans1.reqa_datab_in;
		trans2.reqtag_a    = trans1.reqtag_a;
		// PORT-B:
		trans2.reqcmd_b = trans1.reqcmd_b;
		trans2.reqb_dataa_in = trans1.reqb_dataa_in;
		trans2.reqb_datab_in = trans1.reqb_datab_in;
		trans2.reqtag_b = trans1.reqtag_b;
		// PORT-C:
		trans2.reqcmd_c = trans1.reqcmd_c;
		trans2.reqc_dataa_in = trans1.reqc_dataa_in;
		trans2.reqc_datab_in = trans1.reqc_datab_in;
		trans2.reqtag_c = trans1.reqtag_c;
		// PORT-D:
		trans2.reqcmd_d = trans1.reqcmd_d;
		trans2.reqd_dataa_in = trans1.reqd_dataa_in;
		trans2.reqd_datab_in = trans1.reqd_datab_in;
		trans2.reqtag_d = trans1.reqtag_d;
cove.funcov ( trans2.reqcmd_a,trans2.reqcmd_b,trans2.reqcmd_c,trans2.reqcmd_d, trans2.reqa_dataa_in, trans2.reqa_datab_in, trans2.reqb_dataa_in, trans2.reqb_datab_in,trans2.reqc_dataa_in, trans2.reqc_datab_in,trans2.reqd_dataa_in, trans2.reqd_datab_in);
 return trans1;
	endfunction
endclass

 