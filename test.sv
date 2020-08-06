`include "hdl/IF.sv"

// Program to test: 
program automatic test(calc_inter calcif);

	`include "hdl/env.sv" 	// Top level environment
	env the_env;			// Handle for the environment: 

	initial 
	begin
		// Instanciate the top level
		the_env = new(calcif);

		// Kick off the test now
		the_env.run();

		$finish;
	end 
endprogram