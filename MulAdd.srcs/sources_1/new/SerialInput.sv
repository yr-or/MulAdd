
module SerialInput(
    input clk,
    input reset,
    input logic signed data_in_bit [0:31],
    output logic signed [7:0] data_out [0:31]
    );

    reg shift_en = 1'b1;
    logic signed data_out_bit [0:31];
    logic signed [7:0] data_out_ff [0:31];

    // Instantiate 32 shift_regs
    genvar i;
    generate
        for (i=0; i<32; i=i+1) begin
            ShiftReg8 sh_reg(
                .clk                (clk),
                .reset              (reset),
                .shift_in           (data_in_bit[i]),
                .shift_en           (shift_en),
                .shift_out          (data_out_bit[i]),
                .parallel_out       (data_out_ff[i])
            );
        end
    endgenerate

    assign data_out = data_out_ff;

endmodule
