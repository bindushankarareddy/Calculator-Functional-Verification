module top;

	parameter clock_cycle = 100; 
    bit a_clk, b_clk, c_clk;
	// for every 50 time units toggle the clock. 
	always #(clock_cycle/2) 
	begin 
		a_clk = ~a_clk;	
		b_clk = ~b_clk;
		c_clk = ~c_clk;
	end
 
	calc_inter cacul_2(a_clk, b_clk, c_clk); 	// Handle for calc1 interface 
	test t1(cacul_2);  					// Testbench program
	calc2_top   c1( cacul_2.out_dataa, cacul_2.out_datab, cacul_2.out_datac, cacul_2.out_datad, cacul_2.out_respa, cacul_2.out_respb, cacul_2.out_respc, cacul_2.out_respd, cacul_2.out_tag_a, cacul_2.out_tag_b, cacul_2.out_tag_c, cacul_2.out_tag_d, cacul_2.scan_out, cacul_2.a_clk, cacul_2.b_clk, cacul_2.c_clk, cacul_2.reqcmd_a, cacul_2.reqa_dataa_in, cacul_2.reqtag_a, cacul_2.reqcmd_b, cacul_2.reqb_dataa_in, cacul_2.reqtag_b, cacul_2.reqcmd_c, cacul_2.reqc_dataa_in, cacul_2.reqtag_c, cacul_2.reqcmd_d, cacul_2.reqd_dataa_in, cacul_2.reqtag_d, cacul_2.reset, cacul_2.scan_in);
endmodule 
