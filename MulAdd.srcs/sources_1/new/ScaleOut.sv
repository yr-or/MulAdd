
module ScaleOut #(parameter BIT_WIDTH_LARGE=20,
                  parameter BIT_WIDTH_SCALED=8,
                  parameter NUM_NEUR=32) (
    input logic signed [BIT_WIDTH_LARGE-1:0] layer_out [0:NUM_NEUR-1],
    output logic signed [BIT_WIDTH_SCALED-1:0] scaled_out [0:NUM_NEUR-1]
    );
    
localparam SHIFT_AMOUNT = 4;

logic signed [BIT_WIDTH_LARGE-1:0] shift_out;
logic signed [BIT_WIDTH_SCALED-1:0] trun_out [0:NUM_NEUR-1];

integer i;
always @(*) begin
    // Right shift so scale output and truncate
    for (i=0; i<NUM_NEUR; i=i+1) begin
        shift_out = layer_out[i] >> SHIFT_AMOUNT;
        trun_out[i] = shift_out;
    end
end

assign scaled_out = trun_out;

endmodule