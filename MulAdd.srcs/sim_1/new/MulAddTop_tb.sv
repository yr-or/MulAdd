`timescale 1ns / 1ps

module MulAddTop_tb();

logic signed [3:0] data_in [0:3] = '{1, -3, 5, -6};
logic signed [3:0] W_L2 [0:1] [0:3] = '{ '{3,-2,5,6}, '{0,-4,7,2} };
logic signed [3:0] W_L3 [0:1] = '{5,7};

logic signed [3:0] W_N0 [0:3] = W_L2[0];
logic signed [3:0] W_N1 [0:3] = W_L2[1];

logic signed [16:0] result;
reg clk = 1'b0;

MulAdd_top NN(
    .clk            (clk),
    .data_in        (data_in),
    .weights_L2     (W_L2),
    .weights_L3     (W_L3),
    .result         (result)
);

always begin
    #10;
    clk = ~clk;
end

endmodule
