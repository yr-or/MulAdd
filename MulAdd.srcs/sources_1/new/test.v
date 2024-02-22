`timescale 1ns / 1ps

module test(
    input clk,
    input A,
    output C
    );

    reg a, b;

    always @(posedge clk) begin
        a <= A;
        b <= a;
    end

    assign C = b;

endmodule
