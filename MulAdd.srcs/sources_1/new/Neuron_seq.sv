`timescale 1ns / 1ps

module Neuron_seq
    #(parameter BIT_WIDTH=8,  // bit-width
      parameter NUM_INP=196,  // number of inputs
      parameter W_LARGE=32
    )(
        input clk,
        input reset,
        input logic signed [BIT_WIDTH-1:0] data_in [0:13][0:13],
        input logic signed [BIT_WIDTH-1:0] weights [0:13][0:13],
        output logic signed [W_LARGE-1:0] result,
        output done
    );
    
    // Registers
    logic signed [31:0] acc = 32'd0;
    logic signed [BIT_WIDTH-1:0] data_in_ff [0:13][0:13];
    logic signed [BIT_WIDTH-1:0] weights_ff [0:13][0:13];
    logic signed [BIT_WIDTH-1:0] data_in_chunk [0:13];
    logic signed [BIT_WIDTH-1:0] weights_chunk [0:13];
    // Wires
    logic signed [19:0] result_part;
    
    
    // Register inputs
    always @(posedge clk) begin
        data_in_ff <= data_in;
        weights_ff <= weights;
    end
    
    // Instantiate mul_acc and connect to input regs
    MulAcc_mix mac(
        .clk        (clk),
        .reset      (reset),
        .data_in    (data_in_chunk),
        .weights    (weights_chunk),
        .result     (result_part)
    );
    
    reg [7:0] count_ff = 8'b0;
    reg done_ff = 1'b0;
    reg reset_ff = 1'b0;
    
    // Sequential logic to call MulAcc 14 times
    always @(posedge clk) begin
        if (reset) begin
            acc <= 32'd0;
            data_in_chunk <= data_in_ff[0];
            weights_chunk <= weights_ff[0];
        end else
        if (count_ff < 8'd14) begin
            data_in_chunk <= data_in_ff[count_ff];
            weights_chunk <= weights_ff[count_ff];
            acc <= acc + result_part;
            count_ff <= count_ff + 8'b1;
        end else begin
            acc <= acc + result_part;
            done_ff <= 1'b1;
        end
    end
    
    assign done = done_ff;
    assign result = acc;
    
endmodule
