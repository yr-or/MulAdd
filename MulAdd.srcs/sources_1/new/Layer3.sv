
module Layer3(
    input clk,
    input reset,
    input logic signed [7:0] data_in [0:7],
    output logic signed [15:0] data_out_scaled [0:4],
    output logic signed [19:0] data_out_unscaled [0:4],
    output done_L2
    );
    
    localparam NUM_NEUR = 8;
    localparam BIT_WIDTH = 8;
    localparam W_LARGE = 20;
    localparam NUM_INP = 8;

    // Weights for all layer 2 neurons
   logic signed [7:0] W_ARRAY_L2 [0:4] [0:7] = '{
    { -1, 6, -8, -8, -1, -9, 15, 28 },
    { 4, -3, 10, 25, 36, 69, 50, 22 },
    { 10, -6, -6, -14, -8, -35, -24, -22 },
    { 0, 3, 10, -2, -7, -20, 5, -1 },
    { 10, 6, -14, -17, -19, -14, -37, -32 }
    };


    logic signed [19:0] out_unscaled [0:4];
    logic signed [15:0] out_scaled [0:4];
    wire done_wire;
        
    // Instantiate 8 neurons for Layer 2
    genvar i;
    generate
        for (i=0; i<5; i=i+1) begin
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
            .BIT_WIDTH_SCALED(16),
            .NUM_NEUR(5)) s_L2 (
        .layer_out      (out_unscaled),
        .scaled_out     (out_scaled)
    );

    assign done_L2 = done_wire;
    assign data_out_scaled = out_scaled;
    assign data_out_unscaled = out_unscaled;

endmodule