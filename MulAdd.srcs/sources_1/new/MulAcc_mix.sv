
// 14 clock cycles of chunks of 14 input values of 8-bits wide each

module MulAcc_mix #(parameter BIT_WIDTH=8,
                    parameter NUM_VALS=14) (
    input clk,
    input reset,
    input logic signed [BIT_WIDTH-1:0] data_in [0:NUM_VALS-1],
    input logic signed [BIT_WIDTH-1:0] weights [0:NUM_VALS-1],
    output logic signed [19:0] result
    );
    
    // Wires
    logic signed [15:0] inp_mul [0:NUM_VALS-1];
    // Registers
    logic signed [19:0] result_ff;
    
    
    // Multiply values
    integer i;
    always @(*) begin
        for (i=0; i<NUM_VALS; i=i+1) begin
            inp_mul[i] = data_in[i] * weights[i];
        end
    end
    
    // First stage sums
    logic signed [16:0] sum1_1;
    logic signed [16:0] sum1_2;
    logic signed [16:0] sum1_3;
    logic signed [16:0] sum1_4;
    logic signed [16:0] sum1_5;
    logic signed [16:0] sum1_6;
    logic signed [16:0] sum1_7;
    // Second stage sums
    logic signed [17:0] sum2_1;
    logic signed [17:0] sum2_2;
    logic signed [17:0] sum2_3;
    // Third stage sums
    logic signed [18:0] sum3_1;
    logic signed [18:0] sum3_2;
    // Fourth stage sum
    logic signed [19:0] sum4_1;
    
    // Add up inp_mul array
    always @(*) begin
        sum1_1 = inp_mul[0] + inp_mul[1];
        sum1_2 = inp_mul[2] + inp_mul[3];
        sum2_1 = sum1_1 + sum1_2;
        sum3_1 = sum2_1 + inp_mul[4];
    end
    
    // Register output
    always @(posedge clk) begin
        if (reset) begin
            result_ff <= 20'd0;
            
        end else
            result_ff <= sum4_1;
    end
    
    assign result = result_ff;
    
endmodule
