`timescale 1ns / 1ps

module MulAccTemp_tb();

    // Parameters
   parameter SIZEIN = 16;
   parameter SIZEOUT = 40;
   
   // Signals
   reg clk;
   reg ce;
   reg sload;
   reg signed [SIZEIN-1:0] a, b;
   wire signed [SIZEOUT-1:0] accum_out;
   
   // Instantiate the module
   macc #(.SIZEIN(SIZEIN), .SIZEOUT(SIZEOUT))
      dut (.clk(clk), .ce(ce), .sload(sload), .a(a), .b(b), .accum_out(accum_out));
   
   // Clock generation clk cycle = 20ns
   always #5 clk = ~clk;
   
   // Test stimulus
   // Clock is starting on 0, so first posedge at 10ns
   // 20ns period
   initial begin
      // Initialize inputs
      clk = 0;
      ce = 1;
      sload = 1;  // Allow first value to be added with 0, needs to be 1 for at least two clock cycles.
      a = 5;
      b = 3;
      
      // Apply inputs and wait for the results
      #20;       // Neg edge 2
      sload = 0; // Set to 0 to allow accumulation (addition)
      #10;
      #5;
      a = 10;
      b = 2;
      #10;
      #40;
      
      // Add more test cases as needed...
      
   end

endmodule
