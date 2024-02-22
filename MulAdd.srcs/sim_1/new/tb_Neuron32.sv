`timescale 1ns / 1ps

module tb_Neuron32();

logic signed [7:0] test_data_c [0:31] = '{ -16,-15,-14,-13,-12,-11,-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };
logic signed [7:0] W_ARRAY_L2_0 [0:31] = '{ 15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11,-12,-13,-14,-15,-16 };
logic signed [7:0] B_ARRAY_L2 = 0;

    logic signed [19:0] result_tb;
    reg clk_tb = 1'b0;
    reg reset_tb = 1'b0;
    wire done_tb;

    // Instantiate DUT
    Neuron32 #(.BIT_WIDTH(8), .NUM_INP(32)) dut(
        .clk                (clk_tb),
        .reset              (reset_tb),
        .data_in            (test_data_c),
        .weights            (W_ARRAY_L2_0),
        .bias               (B_ARRAY_L2),
        .result             (result_tb),
        .done               (done_tb)
    );

    // Clock generation
    always begin
        #10;
        clk_tb = ~clk_tb;
    end

    initial begin
        // Initial reset
        reset_tb = 1'b1;
        #60;
        reset_tb = 1'b0;
        #400;
    end

endmodule
