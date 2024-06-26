`timescale 1ns / 1ps

// Used to test Layer2 outputs against Colab data

module tb_Layer2();

    // Input data
    // a: zero, b: four, c: three
    logic signed [7:0] test_data_a [0:195] = '{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 42, 115, 88, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 42, 123, 118, 103, 55, 0, 0, 0, 0, 0, 0, 0, 0, 57, 127, 101, 123, 52, 106, 0, 0, 0, 0, 0, 0, 0, 31, 122, 91, 11, 18, 0, 125, 27, 0, 0, 0, 0, 0, 8, 117, 47, 6, 0, 0, 0, 127, 49, 0, 0, 0, 0, 0, 65, 101, 0, 0, 0, 0, 0, 127, 43, 0, 0, 0, 0, 0, 84, 60, 0, 0, 0, 1, 66, 92, 2, 0, 0, 0, 0, 0, 85, 46, 0, 0, 14, 88, 74, 0, 0, 0, 0, 0, 0, 0, 84, 113, 65, 96, 116, 65, 7, 0, 0, 0, 0, 0, 0, 0, 32, 111, 127, 83, 18, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    logic signed [7:0] test_data_b [0:195] = '{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 39, 5, 0, 0, 0, 0, 56, 0, 0, 0, 0, 0, 0, 0, 86, 10, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 27, 103, 0, 0, 0, 0, 22, 107, 0, 0, 0, 0, 0, 0, 59, 77, 0, 0, 0, 0, 41, 90, 0, 0, 0, 0, 2, 34, 120, 42, 0, 0, 0, 0, 40, 108, 54, 66, 87, 95, 93, 58, 127, 5, 0, 0, 0, 0, 0, 39, 46, 46, 20, 0, 0, 35, 113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 44, 81, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 44, 91, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 44, 106, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12, 53, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    logic signed [7:0] test_data_c [0:195] = '{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 19, 64, 63, 63, 23, 0, 0, 0, 0, 0, 0, 0, 28, 109, 123, 127, 126, 126, 115, 9, 0, 0, 0, 0, 0, 0, 14, 70, 48, 33, 42, 123, 116, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 45, 125, 83, 0, 0, 0, 0, 0, 0, 0, 4, 40, 48, 101, 126, 106, 30, 0, 0, 0, 0, 0, 0, 0, 67, 127, 127, 127, 127, 63, 0, 0, 0, 0, 0, 0, 0, 0, 4, 22, 11, 11, 83, 82, 0, 0, 0, 0, 0, 0, 0, 10, 1, 0, 0, 12, 104, 82, 0, 0, 0, 0, 0, 0, 34, 118, 39, 34, 45, 105, 118, 49, 0, 0, 0, 0, 0, 0, 32, 114, 126, 126, 116, 84, 20, 0, 0, 0, 0, 0, 0, 0, 0, 14, 61, 34, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

    logic signed [15:0] data_out_scaled_tb [0:31];
    logic signed [19:0] data_out_unscaled_tb [0:31];
    reg clk_tb = 1'b0;
    reg reset_tb = 1'b0;
    
    // Instantiate DUT
    Layer2 dut (
        .clk                (clk_tb),
        .reset              (reset_tb),
        .data_in            (test_data_a),
        .data_out_scaled    (data_out_scaled_tb),
        .data_out_unscaled  (data_out_unscaled_tb)
    );

    always begin
        clk_tb = ~clk_tb;
        #10;
    end

    // Correct data to check against (unscaled, integer weights, biases)
    int out_test_data_a [0:31] = '{-10679, 39525, -6776, 14117, 5940, 5011, -19904, 19314, -3302, 19477, -11845, -10092, -11871, 43560, -1831, 28472, 15435, -1388, 29725, 33543, -19563, 34523, 22479, -14341, -16071, -9508, 18812, 22011, 19071, -654, -3667, 2213};
    int out_test_data_b [0:31] = '{444, -11529, 28987, -13277, 19188, -23329, 5867, -8754, 9875, 13837, -18653, -16363, -14722, 17097, -10465, 8525, 15652, -11486, 2295, 24747, 8991, 8543, 12739, -14201, -4499, 4360, -11194, 9838, -7115, -1177, -1892, 8327};
    int out_test_data_c [0:31] = '{29649, 2971, 23746, 31057, 4615, -4391, 4069, 6102, 10922, 34262, -7996, 30851, 12163, 27440, -4536, -4266, 45107, 3977, 36791, 42826, -12046, 30351, 30757, 10959, 744, -12275, 21319, 30483, 25251, 30881, 2838, 7340};


    initial begin
        // Initial reset
        reset_tb = 1'b1;
        #60;
        reset_tb = 1'b0;
        #600;

        // Check outputs are correct
        for (int i=0; i<32; i++) begin
            // check negative values become 0
            if (out_test_data_a[i] < 0) begin
                if (data_out_unscaled_tb[i] != 0)
                    $display("Incorrect output i: %d, tb_val: %d, act_val: %d", i, data_out_unscaled_tb[i], out_test_data_a[i]);
            end else begin
                // check positive values equal
                if (data_out_unscaled_tb[i] != out_test_data_a[i])
                    $display("Incorrect output i: %d, tb_val: %d, act_val: %d", i, data_out_unscaled_tb[i], out_test_data_a[i]);
            end
        end

        $display("Test passed");
    end

endmodule
