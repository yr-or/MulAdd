/*
    Call combinational MulAcc5 5 times to perform calculation
    Add bias and activation function
    To Do:
    - Hardcode weight values
*/

module Neuron14x14 #(parameter BIT_WIDTH=8,
                     parameter NUM_INP=196
    )(
        input clk,
        input reset,
        input logic signed [BIT_WIDTH-1:0] data_in [0:13][0:13],
        input logic signed [BIT_WIDTH-1:0] weights [0:13][0:13],
        output logic signed [19:0] result,
        output done
    );
    
    // Registers
    logic signed [19:0] acc = 19'd0;
    logic signed [BIT_WIDTH-1:0] data_in_ff [0:13][0:13];
    logic signed [BIT_WIDTH-1:0] weights_ff [0:13][0:13];
    logic signed [BIT_WIDTH-1:0] data_in_chunk [0:13];
    logic signed [BIT_WIDTH-1:0] weights_chunk [0:13];
    // Wires
    logic signed [19:0] result_part;
    
    // Register inputs
    always @(posedge clk) begin
        data_in_ff <= data_in;
        weights_ff <= weights;
    end
    
    // Instantiate MulAcc5 and connect to input regs
    MulAcc14 mac(
        .clk        (clk),
        .reset      (reset),
        .data_in    (data_in_chunk),
        .weights    (weights_chunk),
        .result     (result_part)
    );
    
    reg [7:0] count_ff = 8'b0;
    reg done_ff = 1'b0;
    reg reset_ff = 1'b0;
    reg data_ready = 1'b0;
    
    always @(posedge clk) begin
        if (count_ff > 1)
            data_ready = 1'b1;
    end
    
    // Sequential logic to call MulAcc 5 times
    always @(posedge clk or posedge reset) begin
        // Asynchronous Reset logic
        if (reset) begin
            acc <= 19'd0;
            data_in_chunk <= '{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
            weights_chunk <= '{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
            data_ready = 1'b0;
            done_ff = 1'b0;
            count_ff = 1'b0;
        end else begin  // not in reset
            if (~done_ff) begin
                if (count_ff < 8'd14) begin
                    data_in_chunk <= data_in_ff[count_ff];
                    weights_chunk <= weights_ff[count_ff];
                    acc <= acc + result_part;
                    count_ff <= count_ff + 8'b1;
                end else begin
                    acc <= acc + result_part;
                    done_ff <= 1'b1;
                end
            end
        end
    end
    
    assign done = done_ff;
    assign result = acc;

endmodule
