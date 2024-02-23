`timescale 1ns / 1ps
`default_nettype none

module macc10_tb();

    logic signed [7:0] input_data [0:9] = '{0,1,2,3,4,5,6,7,8,9};
    logic signed [7:0] weights [0:9] = '{9,8,7,6,5,4,3,2,1,0};
    reg clk_tb = 1'b0;
    reg reset_tb = 1'b0;
    logic signed [19:0] result_tb;
    
    
    // Instantiate macc10
    macc10 dut(
        .clk            (clk_tb),
        .reset          (reset_tb),
        .data_in        (input_data),
        .weights        (weights),
        .result         (result_tb)
    );
    
    initial begin
        #500;
    end
    
    always begin
        #10;
        clk_tb = ~clk_tb;
    end

endmodule
