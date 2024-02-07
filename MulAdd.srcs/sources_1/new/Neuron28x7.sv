
// 28 clk cycles on 7 chunks of data

module Neuron28x7 #(parameter BIT_WIDTH=8,
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
    logic signed [BIT_WIDTH-1:0] data_in_ff [0:27][0:6];
    logic signed [BIT_WIDTH-1:0] weights_ff [0:27][0:6];
    logic signed [BIT_WIDTH-1:0] data_in_chunk [0:6];
    logic signed [BIT_WIDTH-1:0] weights_chunk [0:6];
    // Wires
    logic signed [19:0] result_part;

    // Register inputs and weights
    // Split into 28 chunks of 7 bits of data each
    always @(posedge clk) begin
        // Inputs
        data_in_ff[0] <= data_in[0:6];
        data_in_ff[1] <= data_in[7:13];
        data_in_ff[2] <= data_in[14:20];
        data_in_ff[3] <= data_in[21:27];
        data_in_ff[4] <= data_in[28:34];
        data_in_ff[5] <= data_in[35:41];
        data_in_ff[6] <= data_in[42:48];
        data_in_ff[7] <= data_in[49:55];
        data_in_ff[8] <= data_in[56:62];
        data_in_ff[9] <= data_in[63:69];
        data_in_ff[10] <= data_in[70:76];
        data_in_ff[11] <= data_in[77:83];
        data_in_ff[12] <= data_in[84:90];
        data_in_ff[13] <= data_in[91:97];
        data_in_ff[14] <= data_in[98:104];
        data_in_ff[15] <= data_in[105:111];
        data_in_ff[16] <= data_in[112:118];
        data_in_ff[17] <= data_in[119:125];
        data_in_ff[18] <= data_in[126:132];
        data_in_ff[19] <= data_in[133:139];
        data_in_ff[20] <= data_in[140:146];
        data_in_ff[21] <= data_in[147:153];
        data_in_ff[22] <= data_in[154:160];
        data_in_ff[23] <= data_in[161:167];
        data_in_ff[24] <= data_in[168:174];
        data_in_ff[25] <= data_in[175:181];
        data_in_ff[26] <= data_in[182:188];
        data_in_ff[27] <= data_in[189:195];
        // Weights
        weights_ff[0] <= weights[0:6];
        weights_ff[1] <= weights[7:13];
        weights_ff[2] <= weights[14:20];
        weights_ff[3] <= weights[21:27];
        weights_ff[4] <= weights[28:34];
        weights_ff[5] <= weights[35:41];
        weights_ff[6] <= weights[42:48];
        weights_ff[7] <= weights[49:55];
        weights_ff[8] <= weights[56:62];
        weights_ff[9] <= weights[63:69];
        weights_ff[10] <= weights[70:76];
        weights_ff[11] <= weights[77:83];
        weights_ff[12] <= weights[84:90];
        weights_ff[13] <= weights[91:97];
        weights_ff[14] <= weights[98:104];
        weights_ff[15] <= weights[105:111];
        weights_ff[16] <= weights[112:118];
        weights_ff[17] <= weights[119:125];
        weights_ff[18] <= weights[126:132];
        weights_ff[19] <= weights[133:139];
        weights_ff[20] <= weights[140:146];
        weights_ff[21] <= weights[147:153];
        weights_ff[22] <= weights[154:160];
        weights_ff[23] <= weights[161:167];
        weights_ff[24] <= weights[168:174];
        weights_ff[25] <= weights[175:181];
        weights_ff[26] <= weights[182:188];
        weights_ff[27] <= weights[189:195];
    end
    
    // Instantiate MulAcc5 and connect to input regs
    MulAcc7 mac(
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
            data_in_chunk <= '{0, 0, 0, 0, 0, 0, 0};
            weights_chunk <= '{0, 0, 0, 0, 0, 0, 0};
            data_ready = 1'b0;
            done_ff = 1'b0;
            count_ff = 1'b0;
        end else begin  // not in reset
            if (~done_ff) begin
                if (count_ff < 8'd28) begin
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
