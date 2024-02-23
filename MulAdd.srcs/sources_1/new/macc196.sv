

module macc196(
    input clk,
    input reset,
    input signed [7:0] data_in [0:195],
    input signed [7:0] weights [0:195],
    output [19:0] result,
    output done
    );

    reg [7:0] count_ff = 8'b0;
    reg done_ff = 1'b0;
    reg signed [7:0] input_n;
    reg signed [7:0] weight_n;
    reg sload = 1'b1;
    wire [19:0] accum_out;
    reg sload_fin_reg = 1'b0;
    
    // Sequential logic for counter
    always @(posedge clk) begin
        if (~reset) begin
            if (count_ff < 196) begin
                if (~sload_fin_reg) begin
                    sload <= 1;
                    sload_fin_reg <= 1;
                end else begin
                    sload <= 0;
                    count_ff <= count_ff + 1'b1;
                end
            end else
                done_ff <= 1;
        end
    end
    
    // Combinational logic for mux
    always @(*) begin
        input_n = data_in[count_ff];
        weight_n = weights[count_ff];
    end
    
    
    // Instantiate macc
    macc mac(
        .clk                (clk),
        .ce                 (~reset),
        .sload              (sload),
        .a                  (input_n),
        .b                  (weight_n),
        .accum_out          (accum_out)
    );
    
    assign result = accum_out;
    assign done = done_ff;
   
endmodule