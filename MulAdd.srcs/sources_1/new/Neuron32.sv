
// 4 clock cycles, 8 combinational operations per cycle

module Neuron32 #(parameter BIT_WIDTH=8,
                  parameter NUM_INP=32
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
    
    // Register inputs and weights
    always @(posedge clk) begin
        // Inputs
        data_in_ff[0] <= data_in[0:7];
        data_in_ff[1] <= data_in[8:15];
        data_in_ff[2] <= data_in[16:23];
        data_in_ff[3] <= data_in[24:31];
        // Weights
        weights_ff[0] <= weights[0:7];
        weights_ff[1] <= weights[8:15];
        weights_ff[2] <= weights[16:23];
        weights_ff[3] <= weights[24:31];
    end
    
    // Instantiate MulAcc5 and connect to input regs
    macc8 mac(
        .clk        (clk),
        .reset      (reset),
        .data_in    (data_in_chunk),
        .weights    (weights_chunk),
        .result     (result_part)
    );
    
    reg [7:0] count_ff = 8'b0;
    reg done_ff = 1'b0;
    reg reset_ff = 1'b0;
    reg data_ready = 1'b0;
    
    always @(posedge clk) begin
        if (count_ff > 1)
            data_ready = 1'b1;
    end
    
    // Sequential logic to call MulAcc 5 times
    always @(posedge clk or posedge reset) begin
        // Asynchronous Reset logic
        if (reset) begin
            acc <= 19'd0;
            data_in_chunk <= '{0, 0, 0, 0, 0, 0, 0, 0};
            weights_chunk <= '{0, 0, 0, 0, 0, 0, 0, 0};
            data_ready = 1'b0;
            done_ff = 1'b0;
            count_ff = 1'b0;
        end else begin  // not in reset
            if (~done_ff) begin
                if (count_ff < 8'd4) begin
                    data_in_chunk <= data_in_ff[count_ff];
                    weights_chunk <= weights_ff[count_ff];
                    acc <= acc + result_part;
                    count_ff <= count_ff + 8'b1;
                end else begin
                    acc <= acc + result_part;
                    done_ff <= 1'b1;
                end
            end
        end
    end
    
    reg done_bias_ff = 1'b0;

    // Activation function and bias
    always @(posedge clk) begin
        if (done_ff & ~done_bias_ff) begin
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