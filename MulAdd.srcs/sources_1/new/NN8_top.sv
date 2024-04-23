
module NN8_top(
    input clk,
    input reset,
    input logic signed [7:0] data_in [0:7],
    output logic signed [15:0] data_out [0:4],
    output done
    );
    
    reg signed [7:0] L2_out_scaled [0:7];
    reg done_L2;
    reg signed  [15:0] L3_out_scaled [0:4];

    // Register inputs
    logic signed [7:0] inputs_ff [0:7];
    // Register outputs
    logic signed [15:0] outputs_ff [0:4];

    always @(posedge clk) begin
        if (reset) begin
            inputs_ff <= '{0,0,0,0,0,0,0,0};
            outputs_ff <= '{0,0,0,0,0};
        end else begin
            inputs_ff <= data_in;
            outputs_ff <= L3_out_scaled;
        end
    end

    Layer2_test L2(
        .clk                (clk),
        .reset              (reset),
        .data_in            (inputs_ff),
        .data_out_scaled    (L2_out_scaled),
        .done_L2            (done_L2)
    );

    Layer3 L3(
        .clk                (clk),
        .reset              (reset),
        .data_in            (L2_out_scaled),
        .data_out_scaled    (L3_out_scaled),
        .done_L2            (done)
    );

    assign data_out = outputs_ff;

endmodule
