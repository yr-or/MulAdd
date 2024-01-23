/*
    Call combinational MulAcc5 5 times to perform calculation
    Add bias and activation function
    To Do:
    - Hardcode weight values
*/

module Neuron14x14 #(parameter BIT_WIDTH=8,
                     parameter NUM_INP=196
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
    logic signed [BIT_WIDTH-1:0] data_in_ff [0:13][0:13];
    logic signed [BIT_WIDTH-1:0] weights_ff [0:13][0:13];
    logic signed [BIT_WIDTH-1:0] data_in_chunk [0:13];
    logic signed [BIT_WIDTH-1:0] weights_chunk [0:13];
    // Wires
    logic signed [19:0] result_part;

    // Register inputs and weights
    always @(posedge clk) begin
        // Inputs
        data_in_ff[0] <= data_in[0:13];
        data_in_ff[1] <= data_in[14:27];
        data_in_ff[2] <= data_in[28:41];
        data_in_ff[3] <= data_in[42:55];
        data_in_ff[4] <= data_in[56:69];
        data_in_ff[5] <= data_in[70:83];
        data_in_ff[6] <= data_in[84:97];
        data_in_ff[7] <= data_in[98:111];
        data_in_ff[8] <= data_in[112:125];
        data_in_ff[9] <= data_in[126:139];
        data_in_ff[10] <= data_in[140:153];
        data_in_ff[11] <= data_in[154:167];
        data_in_ff[12] <= data_in[168:181];
        data_in_ff[13] <= data_in[182:195];
        // Weights
        weights_ff[0] <= weights[0:13];
        weights_ff[1] <= weights[14:27];
        weights_ff[2] <= weights[28:41];
        weights_ff[3] <= weights[42:55];
        weights_ff[4] <= weights[56:69];
        weights_ff[5] <= weights[70:83];
        weights_ff[6] <= weights[84:97];
        weights_ff[7] <= weights[98:111];
        weights_ff[8] <= weights[112:125];
        weights_ff[9] <= weights[126:139];
        weights_ff[10] <= weights[140:153];
        weights_ff[11] <= weights[154:167];
        weights_ff[12] <= weights[168:181];
        weights_ff[13] <= weights[182:195];
    end
    
    // Instantiate MulAcc5 and connect to input regs
    MulAcc14 mac(
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
            data_in_chunk <= '{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
            weights_chunk <= '{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
            data_ready = 1'b0;
            done_ff = 1'b0;
            count_ff = 1'b0;
        end else begin  // not in reset
            if (~done_ff) begin
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
