`timescale 1ns / 1ps
`default_nettype none

// Fully working testbench for macc model
// Need to set sload to 1 for at least two clock cycles
// Can set sload to 0 on postive clock edge
// CE = 1 for whole time, unset to disable.
// Subsequent values can be set each clock cycle on positive edge.


module macc_test_tb();

    logic signed [7:0] input_data [0:9] = '{0,1,2,3,4,5,6,7,8,9};
    logic signed [7:0] weights [0:9] = '{9,8,7,6,5,4,3,2,1,0};
    
    reg clk_tb = 1'b0;
    reg ce;
    reg sload;
    reg signed [7:0] input_n;
    reg signed [7:0] weight_n;
    wire signed [19:0] accum_out_tb;
    
    macc mac(
        .clk                (clk_tb),
        .ce                 (ce),
        .sload              (sload),
        .a                  (input_n),
        .b                  (weight_n),
        .accum_out          (accum_out_tb)
    );
    
    initial begin
        // Set initial values to load in first data pair
        input_n = input_data[0];
        weight_n = weights[0];
        sload = 1;
        ce = 1;
        #50;    // Brings us to 2nd rising clock edge
        
        // Give reset of data in each cycle
        sload = 0;
        for (int i=1; i<10; i=i+1) begin
            input_n = input_data[i];
            weight_n = weights[i];
            #20;
        end
    end
    
    always begin
        #10;
        clk_tb = ~clk_tb;
    end

endmodule
