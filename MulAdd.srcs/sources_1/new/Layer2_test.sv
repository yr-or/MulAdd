
module Layer2_test(
    input clk,
    input reset,
    input logic signed [7:0] data_in [0:7],
    output logic signed [7:0] data_out_scaled [0:7],
    output logic signed [19:0] data_out_unscaled [0:7],
    output done_L2
    );
    
    localparam NUM_NEUR = 8;
    localparam BIT_WIDTH = 8;
    localparam W_LARGE = 20;
    localparam NUM_INP = 8;

    // Weights for all layer 2 neurons
   logic signed [7:0] W_ARRAY_L2 [0:7] [0:7] = '{
    { -1, 6, -8, -8, -1, -9, 15, 28 },
    { 4, -3, 10, 25, 36, 69, 50, 22 },
    { 10, -6, -6, -14, -8, -35, -24, -22 },
    { 0, 3, 10, -2, -7, -20, 5, -1 },
    { 10, 6, -14, -17, -19, -14, -37, -32 },
    { 3, -6, -9, -9, 7, 27, 10, -2 },
    { 1, 8, 13, 28, 25, 64, 61, 39 },
    { 1, -3, 2, -3, -4, -7, -3, 22 }
    };


    logic signed [19:0] out_unscaled [0:7];
    logic signed [7:0] out_scaled [0:7];
    wire done_wire;
        
    // Instantiate 8 neurons for Layer 2
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin
            MulAcc8 N_L2 (
                .clk            (clk),
                .reset          (reset),
                .data_in        (data_in),
                .weights        (W_ARRAY_L2[i]),
                .result         (out_unscaled[i])
            );
        end
    endgenerate

    // Instantiate scaling modules
    ScaleOut #(.BIT_WIDTH_LARGE(20),
            .BIT_WIDTH_SCALED(8),
            .NUM_NEUR(8)) s_L2 (
        .layer_out      (out_unscaled),
        .scaled_out     (out_scaled)
    );

    assign done_L2 = done_wire;
    assign data_out_scaled = out_scaled;
    assign data_out_unscaled = out_unscaled;

endmodule