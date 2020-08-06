`include "hdl/Transaction.sv"
`include "hdl/DUTA.sv"

class scoreboard;

	int max_trans_cnt;
	bit start_signa;
	event ended;
	bit [0:31] overflow_limit = 32'h FFFFFFFF; //here we have created a overflow limit for 32 bit
	Transaction to_dut;		// Handle for the class transaction 
	dut_out_ALL object_to_DUT_ALL;
		// Handle for the class dut_out 
	mailbox #(Transaction) gen2scb;	// mailbox to send data from driver to scoreboard
	mailbox #(dut_out_ALL)mon2scb_ALL;  // mailbox to send data from monitor to scoreboard
    
	bit [0:1] expected_response_a, expected_response_b, expected_response_c, expected_response_d;
	bit [0:1] expected_taga, expected_tagb, expected_tagc, expected_tagd;
	bit [0:31] expected_dataa, expected_datab, expected_datac, expected_datad;
	bit [0:35] overflow_output_a;
	bit [0:35] overflow_output_b;
	bit [0:35] overflow_output_c;
	bit [0:35] overflow_output_d;


	// Constructor function 
	function new (int max_trans_cnt, mailbox #(Transaction) gen2scb, mailbox #(dut_out_ALL) mon2scb_ALL, bit start_signa = 0);
	
		this.max_trans_cnt = max_trans_cnt;
		this.gen2scb = gen2scb;
		this.mon2scb_ALL = mon2scb_ALL;
		
		this.start_signa = start_signa;
	endfunction

	// Task to calculate the expected data and response: 
	task expected_output();
	
		//calculating the expected response for NO OPERATION COMMAND for port A
		if (to_dut.reqcmd_a== 4'b0000) 
		begin
			expected_response_a = 2'b00;	
		end
		
		//calculating the expected response for NO OPERATION COMMAND for port A
		if (to_dut.reqcmd_b== 4'b0000) 
		begin
			expected_response_b = 2'b00;
		end
		
		//calculating the expected response for NO OPERATION COMMAND for port A
		if (to_dut.reqcmd_c== 4'b0000) 
		begin
			expected_response_c = 2'b00;
		end
		
		//calculating the expected response for NO OPERATION COMMAND for port A
		if (to_dut.reqcmd_d== 4'b0000)
		begin
			expected_response_d = 2'b00;
		end

		//calculating the expected response for ADDITION COMMAND for port A
		if (to_dut.reqcmd_a== 4'b0001) 
		begin
		   expected_taga = to_dut.reqtag_a; 
			expected_dataa = to_dut.reqa_dataa_in + to_dut.reqa_datab_in;
		overflow_output_a = to_dut.reqa_dataa_in + to_dut.reqa_datab_in;
			if((expected_dataa< to_dut.reqa_dataa_in) && (expected_dataa< to_dut.reqa_datab_in) || overflow_limit < overflow_output_a)
				expected_response_a = 2'b10;		
			else 
				  expected_response_a = 2'b01;
			end
		
		//calculating the expected response for ADDITION COMMAND for port B
		if (to_dut.reqcmd_b== 4'b0001) 
		begin
			expected_tagb = to_dut.reqtag_b;
			expected_datab = to_dut.reqb_dataa_in + to_dut.reqb_datab_in;
		overflow_output_b = to_dut.reqb_dataa_in + to_dut.reqb_datab_in;
			if((expected_datab< to_dut.reqb_dataa_in) && (expected_datab< to_dut.reqb_datab_in) || overflow_limit < overflow_output_b)
				expected_response_b = 2'b10;		
			
				else
				expected_response_b = 2'b01;
		end
		
		//calculating the expected response for ADDITION COMMAND for port C
		if (to_dut.reqcmd_c== 4'b0001) 
		begin
		   expected_tagc = to_dut.reqtag_c;
			expected_datac = to_dut.reqc_dataa_in + to_dut.reqc_datab_in;
			overflow_output_c = to_dut.reqc_dataa_in + to_dut.reqc_datab_in;
			if((expected_datac< to_dut.reqc_dataa_in) && (expected_datac< to_dut.reqc_datab_in) || overflow_limit < overflow_output_c)
				expected_response_c = 2'b10;
				else
				expected_response_c = 2'b01;
		end
		
		//calculating the expected response for ADDITION COMMAND for port D
		if (to_dut.reqcmd_d== 4'b0001)
		begin
		   expected_tagd = to_dut.reqtag_d;
			expected_datad = to_dut.reqd_dataa_in + to_dut.reqd_datab_in;
			overflow_output_d = to_dut.reqd_dataa_in + to_dut.reqd_datab_in;
			if((expected_datad< to_dut.reqd_dataa_in) && (expected_datad< to_dut.reqd_datab_in) || overflow_limit < overflow_output_d)
				expected_response_d = 2'b10;
				else
				expected_response_d = 2'b01;
		end  
		
		//calculating the expected response for SUBTRACTION COMMAND for port A
		if (to_dut.reqcmd_a== 4'b0010) 
		begin
			expected_dataa = to_dut.reqa_dataa_in - to_dut.reqa_datab_in;
			expected_taga = to_dut.reqtag_a; 
			if(to_dut.reqa_dataa_in< to_dut.reqa_datab_in)
				expected_response_a = 2'b10;
				else
				expected_response_a = 2'b01;
		end		
		
		//calculating the expected response for SUBTRACTION COMMAND for port B
		if (to_dut.reqcmd_b== 4'b0010) 
		begin
			expected_datab = to_dut.reqb_dataa_in - to_dut.reqb_datab_in;
			expected_tagb = to_dut.reqtag_b; 
			if(to_dut.reqb_dataa_in< to_dut.reqb_datab_in)
				expected_response_b = 2'b10;  
            else	
			  expected_response_b = 2'b01;
		end
		
		//calculating the expected response for SUBTRACTION COMMAND for port C
		if (to_dut.reqcmd_c== 4'b0010) 
		begin
			expected_datac = to_dut.reqc_dataa_in - to_dut.reqc_datab_in;
			expected_tagc = to_dut.reqtag_c; 
			if(to_dut.reqc_dataa_in< to_dut.reqc_datab_in)
				expected_response_c = 2'b10; 
				else
				expected_response_c = 2'b01;
		end
		
		//calculating the expected response for SUBTRACTION COMMAND for port D
		if (to_dut.reqcmd_d== 4'b0010) 
		begin
			expected_datad = to_dut.reqd_dataa_in - to_dut.reqd_datab_in;
			expected_tagd = to_dut.reqtag_d; 
			if(to_dut.reqd_dataa_in< to_dut.reqd_datab_in)
				expected_response_d = 2'b10; 
				else
				expected_response_d = 2'b01;
		end 

		//calculating the expected response for LEFT SHIFT COMMAND for port D
		// PORT-A:
		if (to_dut.reqcmd_a== 4'b0101) 
		begin
			expected_dataa = (to_dut.reqa_dataa_in << (to_dut.reqa_datab_in & 31));
			expected_taga = to_dut.reqtag_a; 
			expected_response_a =2'b01;
		end		
		
		//calculating the expected response for LEFT SHIFT COMMAND for port B
		// PORT-B:
		if (to_dut.reqcmd_b== 4'b0101) 
		begin
			expected_datab = (to_dut.reqb_dataa_in << (to_dut.reqb_datab_in & 31));
			expected_tagb = to_dut.reqtag_b; 
			expected_response_b =2'b01;
		end  	
		
		//calculating the expected response for LEFT SHIFT COMMAND for port C
		// PORT-C:
		if (to_dut.reqcmd_c== 4'b0101) 
		begin
			expected_datac = (to_dut.reqc_dataa_in << (to_dut.reqc_datab_in & 31));
			expected_tagc = to_dut.reqtag_c; 
			expected_response_c =2'b01;
		end 
		
		//calculating the expected response for LEFT SHIFT COMMAND for port D
		// PORT-D:
		if (to_dut.reqcmd_d== 4'b0101) 
		begin
			expected_datad = (to_dut.reqd_dataa_in << (to_dut.reqd_datab_in & 31));
			expected_tagd = to_dut.reqtag_d; 
			expected_response_d =2'b01;
		end
		
		//calculating the expected response fot RIGHT SHIFT COMMAND for port A
		if (to_dut.reqcmd_a== 4'b0110) 
		begin 
			expected_dataa = (to_dut.reqa_dataa_in >> (to_dut.reqa_datab_in & 31));
			expected_taga = to_dut.reqtag_a; 
			expected_response_a =2'b01;
		end
		
		//calculating the expected response fot RIGHT SHIFT COMMAND for port B
		if (to_dut.reqcmd_b== 4'b0110) 
		begin
			expected_datab = (to_dut.reqb_dataa_in >> (to_dut.reqb_datab_in & 31));
			expected_tagb = to_dut.reqtag_b; 
			expected_response_b =2'b01;
		end
				
		//calculating the expected response fot RIGHT SHIFT COMMAND for port C
		if (to_dut.reqcmd_c== 4'b0110) 
		begin
			expected_datac = (to_dut.reqc_dataa_in >> (to_dut.reqc_datab_in & 31));
			expected_tagc = to_dut.reqtag_c; 
			expected_response_c =2'b01;
		end
		
		//calculating the expected response fot RIGHT SHIFT COMMAND for port D
		if (to_dut.reqcmd_d== 4'b0110) 
		begin
			expected_datad = (to_dut.reqd_dataa_in >> (to_dut.reqd_datab_in & 31));
			expected_tagd = to_dut.reqtag_d; 
			expected_response_d =2'b01;
		end
	
		//calculating the expected response for invalid command for port A
		if ((to_dut.reqcmd_a==3)||(to_dut.reqcmd_a==4)||(to_dut.reqcmd_a>6))
		begin 
			expected_response_a = 2'b10;
			expected_taga = to_dut.reqtag_a;		
		end 
		
		//calculating the expected response for invalid command for port B
		if ((to_dut.reqcmd_b==3)||(to_dut.reqcmd_b==4)||(to_dut.reqcmd_b>6))
		begin 
			expected_response_b = 2'b10;
			expected_tagb = to_dut.reqtag_b; 
		end 
		
		//calculating the expected response for invalid command for port C
		// PORT-C:
		if ((to_dut.reqcmd_c==3)||(to_dut.reqcmd_c==4)||(to_dut.reqcmd_c>6))
		begin 
			expected_response_c = 2'b10; 
			expected_tagc = to_dut.reqtag_c; 
		end 
		//calculating the expected response for invalid command for port D
		// PORT-D:
		if ((to_dut.reqcmd_d==3)||(to_dut.reqcmd_d==4)||(to_dut.reqcmd_d>6))
		begin 	
			expected_response_d = 2'b10;
			expected_tagd = to_dut.reqtag_d; 				
		end 
		
		// Checking if the actual and expected values are same for Port A
		if(object_to_DUT_ALL.out_respa==2'b00 && expected_response_a == 2'b00)
		begin
			$display ($time, " : No response operation works : PORT-A : expected dataa : %h  output_dataa : %h",expected_dataa,object_to_DUT_ALL.out_dataa);
			$display ($time, " : No response operation works : PORT-A : no response : expected responsea : %h  output_responsea : %h\n",expected_response_a, object_to_DUT_ALL.out_respa);
		end
		else if (object_to_DUT_ALL.out_respa==2'b11)
			$display ($time, " : ERROR! Needs attention : PORT-A unsued response %h\n",object_to_DUT_ALL.out_respa);
		else if (object_to_DUT_ALL.out_respa==2'b10 && expected_response_a==2'b10)
			$display ($time, " : Overflow and underflow(add/sub) or invalid operation giving correct response: PORT-A overflow/underflow or invalid command %h\n",object_to_DUT_ALL.out_respa);
		else if (object_to_DUT_ALL.out_respa != expected_response_a)
			$display ($time, " : ERROR! Response doesnot match!! : PORT-A  output_response : %h expected_response : %h\n",object_to_DUT_ALL.out_respa, expected_response_a);
		else 
		begin
		  if ((expected_dataa != object_to_DUT_ALL.out_dataa ) && (expected_taga != object_to_DUT_ALL.out_tag_a)) 
		 $display ($time, " : ERROR! Data and Tag doesnot match : PORT-A expected data : %h  output_data : %h expected tag : %h output_tag: %h\n",expected_dataa,object_to_DUT_ALL.out_dataa,expected_taga,object_to_DUT_ALL.out_tag_a);
      else	if ((expected_dataa != object_to_DUT_ALL.out_dataa ) && (expected_taga == object_to_DUT_ALL.out_tag_a)) 
			$display ($time, " : ERROR! Data doesnot match but Tag match: PORT-A expected data : %h  output_data : %h expected tag : %h output_tag: %h\n",expected_dataa,object_to_DUT_ALL.out_dataa,expected_taga,object_to_DUT_ALL.out_tag_a);
			else if ((expected_dataa == object_to_DUT_ALL.out_dataa ) && (expected_taga != object_to_DUT_ALL.out_tag_a)) 
			  $display ($time, " : ERROR! Data match but Tag doesnot match: PORT-A expected data : %h  output_data : %h expected tag : %h output_tag: %h\n",expected_dataa,object_to_DUT_ALL.out_dataa,expected_taga,object_to_DUT_ALL.out_tag_a);
	    else 
			begin
				$display ($time, " :  SUCCESS !! Both DATA and TAG : PORT-A expected data : %h  output_data : %h expected tag : %h output_tag: %h\n",expected_dataa,object_to_DUT_ALL.out_dataa,expected_taga,object_to_DUT_ALL.out_tag_a); 
			end
		end		
		
				// Checking if the actual and expected values of the output are same for port B
		if(object_to_DUT_ALL.out_respb==2'b00 && expected_response_b == 2'b00) 
		begin
			$display ($time, " : No response operation works : PORT-B : expected datab : %h  output_datab : %h",expected_datab,object_to_DUT_ALL.out_datab);
			$display ($time, " : No response operation works : PORT-B : no response : expected responseb : %h  output_responseb : %h\n",expected_response_b, object_to_DUT_ALL.out_respb);
		end
		else if (object_to_DUT_ALL.out_respb==2'b11)
			$display ($time, " : ERROR! Needs attention : PORT-B unsued response %h\n",object_to_DUT_ALL.out_respb);
		else if (object_to_DUT_ALL.out_respb==2'b10 && expected_response_b==2'b10)
			$display ($time, " : Overflow and underflow(add/sub)or invalid operation giving correct responsex: PORT-B overflow/underflow or invalid command %h\n",object_to_DUT_ALL.out_respb);
		else
		begin
		  if ((expected_datab != object_to_DUT_ALL.out_datab ) && (expected_tagb != object_to_DUT_ALL.out_tag_b)) 
		 $display ($time, " : ERROR!  Both Data and Tag doesnot match: PORT-B expected data : %h  output_data : %h expected tag : %h output_tag: %h\n",expected_datab,object_to_DUT_ALL.out_datab,expected_tagb,object_to_DUT_ALL.out_tag_b);
      else	if ((expected_datab != object_to_DUT_ALL.out_datab ) && (expected_tagb == object_to_DUT_ALL.out_tag_b)) 
			$display ($time, " : ERROR! Data doesnot match but Tag match: PORT-B expected data : %h  output_data : %h expected tag : %h output_tag: %h\n",expected_datab,object_to_DUT_ALL.out_datab,expected_tagb,object_to_DUT_ALL.out_tag_b);
			else if ((expected_datab == object_to_DUT_ALL.out_datab ) && (expected_tagb != object_to_DUT_ALL.out_tag_b)) 
			  $display ($time, " : ERROR! Data match but Tag doesnot match: PORT-B expected data : %h  output_data : %h expected tag : %h output_tag: %h\n",expected_datab,object_to_DUT_ALL.out_datab,expected_tagb,object_to_DUT_ALL.out_tag_b);
	    else 
			begin
				$display ($time, " :SUCCESS!! DATA and TAG match : PORT-B expected data : %h  output_data : %h expected tag : %h output_tag: %h\n",expected_datab,object_to_DUT_ALL.out_datab,expected_tagb,object_to_DUT_ALL.out_tag_b); 
			end
		end
		
				// Checking if the actual and expected values are same for port C
		if(object_to_DUT_ALL.out_respc==2'b00 && expected_response_c == 2'b00) 
		begin
			$display ($time, " : No response operation works : PORT-C : expected datac : %h  output_datac : %h",expected_datac,object_to_DUT_ALL.out_datac);
			$display ($time, " : No response operation works : PORT-C : no response : expected responsec : %h  output_responsec : %h\n",expected_response_c, object_to_DUT_ALL.out_respc);
		end
		else if (object_to_DUT_ALL.out_respc==2'b11)
			$display ($time, " : ERROR! Needs attention : PORT-C unsued response %h\n",object_to_DUT_ALL.out_respc);
		else if (object_to_DUT_ALL.out_respc==2'b10 && expected_response_c==2'b10)
			$display ($time, " : Overflow and underflow/ invalid operationgiving correct response : PORT-C overflow/underflow or invalid command %h\n",object_to_DUT_ALL.out_respc);
		else 
		begin
		  if ((expected_datac != object_to_DUT_ALL.out_datac ) && (expected_tagc != object_to_DUT_ALL.out_tag_c)) 
		 $display ($time, " : ERROR! Both Data and Tag doesnot match: PORT-C expected data : %h  output_data : %h expected tag : %h output_tag : %h\n",expected_datac,object_to_DUT_ALL.out_datac,expected_tagc,object_to_DUT_ALL.out_tag_c);
      else	if ((expected_datac != object_to_DUT_ALL.out_datac ) && (expected_tagc == object_to_DUT_ALL.out_tag_c)) 
			$display ($time, " : ERROR! Data doesnot match but Tag match: PORT-C expected data : %h  output_data : %h expected tag : %h output_tag : %h\n",expected_datac,object_to_DUT_ALL.out_datac,expected_tagc,object_to_DUT_ALL.out_tag_c);
			else if ((expected_datac == object_to_DUT_ALL.out_datac ) && (expected_tagc != object_to_DUT_ALL.out_tag_c)) 
			  $display ($time, " : ERROR! Data match but Tag doesnot match: PORT-C expected data : %h  output_data : %h expected tag : %h output_tag :%h\n",expected_datac,object_to_DUT_ALL.out_datac,expected_tagc,object_to_DUT_ALL.out_tag_c);
	    else 
			begin
				$display ($time, " :SUCCESS!! DATA and TAG match : PORT-C expected data : %h  output_data : %h expected tag : %h output_tag : %h\n",expected_datac,object_to_DUT_ALL.out_datac,expected_tagc,object_to_DUT_ALL.out_tag_c); 
			end
		end
		
				// Checking if the actual and expected values are same for Port D
		if(object_to_DUT_ALL.out_respd==2'b00  && expected_response_d == 2'b00) 
		begin
			$display ($time, " : No response operation works : PORT-D : expected datad : %h  output_datad : %h",expected_datad,object_to_DUT_ALL.out_datad);
			$display ($time, " : No response operation works : PORT-D : no response : expected responsed : %h  output_responsed : %h\n",expected_response_d, object_to_DUT_ALL.out_respd);
		end
		else if (object_to_DUT_ALL.out_respd==2'b11)
			$display ($time, " : ERROR! Needs attention : PORT-D unsued response %h\n",object_to_DUT_ALL.out_respd);
		else if (object_to_DUT_ALL.out_respd==2'b10 && expected_response_d==2'b10)
			$display ($time, " : Overflow and underflow=/ invalid operation giving correct response : PORT-D overflow/underflow or invalid command %h\n",object_to_DUT_ALL.out_respd);
		else  
		begin
		  if ((expected_datad != object_to_DUT_ALL.out_datad ) && (expected_tagd != object_to_DUT_ALL.out_tag_d)) 
		 $display ($time, " : ERROR! Both Data and Tag doesnot match: PORT-D expected data : %h  output_data : %h expected tag : %h output_tag : %h\n",expected_datad,object_to_DUT_ALL.out_datad,expected_tagd,object_to_DUT_ALL.out_tag_d);
      else	if ((expected_datad != object_to_DUT_ALL.out_datad ) && (expected_tagd == object_to_DUT_ALL.out_tag_d)) 
			$display ($time, " : ERROR! Data doesnot match but Tag match: PORT-D expected data : %h  output_data : %h expected tag : %h output_tag : %h\n",expected_datad,object_to_DUT_ALL.out_datad,expected_tagd,object_to_DUT_ALL.out_tag_d);
			else if ((expected_datad == object_to_DUT_ALL.out_datad ) && (expected_tagd != object_to_DUT_ALL.out_tag_d)) 
			  $display ($time, " : ERROR! Data match but Tag doesnot match: PORT-D expected data : %h  output_data : %h expected tag : %h output_tag : %h\n",expected_datad,object_to_DUT_ALL.out_datad,expected_tagd,object_to_DUT_ALL.out_tag_d);
	    else 
			begin
				$display ($time, " :SUCCESS!! DATA and TAG match : PORT-D expected data : %h  output_data : %h expected tag : %h output_tag : %h\n",expected_datad,object_to_DUT_ALL.out_datad,expected_tagd,object_to_DUT_ALL.out_tag_d); 
			end
		end
		
	endtask 
	 
	task main(); 
  
		$display("\n",$time," : scoreboard for %d transactions", max_trans_cnt);
 
	forever 
	begin
   
		gen2scb.get(to_dut);			 // getting values through mailbox from the driver 
		mon2scb_ALL.get(object_to_DUT_ALL);  // getting values through mailbox from the monitor
		to_dut.print_trans("Scoreboard vals from generator");
		object_to_DUT_ALL.print_responseA("Scoreboard vals from ");
			fork 
			expected_output();
		join
		#1000; 
	end
endtask: main

endclass: scoreboard

