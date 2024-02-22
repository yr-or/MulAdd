
module ShiftReg8
    (
        input clk,
        input reset,
        input shift_in,
        input shift_en,
        output shift_out,
        output logic signed [7:0] parallel_out
    );

    logic signed [7:0] register;

    always @(posedge clk) begin
        if (reset) begin
            register <= 8'b0;
        end else if (shift_en) begin
            register <= {shift_in, register[7:1]};
        end
    end

    assign shift_out = register[0];
    assign parallel_out = register;

endmodule
