
// 4 clock cycles, 8 combinational operations per cycle

module Neuron8 #(parameter BIT_WIDTH=8,
                  parameter NUM_INP=8
    )(
        input clk,
        input reset,
        input logic signed [BIT_WIDTH-1:0] data_in [0:NUM_INP-1],
        input logic signed [BIT_WIDTH-1:0] weights [0:NUM_INP-1],
        input logic signed [BIT_WIDTH-1:0] bias,
        output logic signed [19:0] result,
        output done
    );
    
    // Registers
    logic signed [19:0] acc = 19'd0;
    logic signed [19:0] bias_out_ff = 19'd0;
    logic signed [BIT_WIDTH-1:0] data_in_ff [0:3][0:7];
    logic signed [BIT_WIDTH-1:0] weights_ff [0:3][0:7];
    logic signed [BIT_WIDTH-1:0] data_in_chunk [0:7];
    logic signed [BIT_WIDTH-1:0] weights_chunk [0:7];
    // Wires
    logic signed [19:0] result_part;
    
    // Instantiate MulAcc8 and connect to input regs
    macc8 macc(
        .clk        (clk),
        .reset      (reset),
        .data_in    (data_in_chunk),
        .weights    (weights_chunk),
        .result     (result_part)
    );
    
    reg done_bias_ff = 1'b0;

    // Activation function and bias
    always @(posedge clk) begin
        if (~done_bias_ff) begin
            if (acc > 0)
                bias_out_ff <= acc + bias;
            else
                bias_out_ff <= 0;
            done_bias_ff <= 1'b1;
        end
    end

    assign result = bias_out_ff;
    assign done = done_bias_ff;

endmodule