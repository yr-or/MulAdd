`timescale 1ns / 1ps

module test_tb();

    reg A_reg_tb;
    wire C_reg_tb;
    reg clk_tb = 1'b0;

    // Instantiate DUT
    test dut(
        .clk(clk_tb),
        .A(A_reg_tb),
        .C(C_reg_tb)
    );

    // Clock
    always begin
        #10;
        clk_tb = ~clk_tb;
    end

    initial begin
        // Apply stimulus to input
        #10;
        A_reg_tb = 1'b1;
    end

endmodule
