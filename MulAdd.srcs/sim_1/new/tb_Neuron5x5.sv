`timescale 1ns / 1ps

module tb_Neuron5x5();

localparam signed [7:0] W_ARRAY [0:24] = '{25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1};
localparam signed [7:0] test_data [0:24] = '{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25};

localparam signed [7:0] W_ARRAY_RAND [0:24] = '{-39, 4, 97, 126, -58, -36, 20, 114, -27, -11, -78, 117, -127, -24, -18, -34, 29, 101, 88, 13, -88, -102, -100, 88, -100};
localparam signed [7:0] test_data_rand [0:24] = '{-128, 32, 9, -41, 8, -103, -126, -123, 66, 11, -109, -38, -57, -3, -64, -128, -27, -24, 42, -19, 63, -110, 21, 55, -2};



    logic signed [7:0] data_in_chunk_tb [0:4][0:4];
    logic signed [7:0] weights_chunk_tb [0:4][0:4];
    logic signed [18:0] result_tb;
    reg clk_tb = 1'b0;
    reg reset_tb = 1'b0;
    wire done_tb;

    // Instantiate DUT
    Neuron5x5 #(.BIT_WIDTH(8), .NUM_INP(25)) dut(
        .clk                (clk_tb),
        .reset              (reset_tb),
        .data_in            (data_in_chunk_tb),
        .weights            (weights_chunk_tb),
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
        // Input data
        data_in_chunk_tb[0] = test_data_rand[0:4];
        data_in_chunk_tb[1] = test_data_rand[5:9];
        data_in_chunk_tb[2] = test_data_rand[10:14];
        data_in_chunk_tb[3] = test_data_rand[15:19];
        data_in_chunk_tb[4] = test_data_rand[20:24];
        // Weights
        weights_chunk_tb[0] = W_ARRAY_RAND[0:4];
        weights_chunk_tb[1] = W_ARRAY_RAND[5:9];
        weights_chunk_tb[2] = W_ARRAY_RAND[10:14];
        weights_chunk_tb[3] = W_ARRAY_RAND[15:19];
        weights_chunk_tb[4] = W_ARRAY_RAND[20:24];
        #60;
        reset_tb = 1'b0;
        #200;
    end

endmodule
