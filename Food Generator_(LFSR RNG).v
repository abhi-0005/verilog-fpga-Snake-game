module food (
    input wire clk,
    input wire reset,
    output wire [15:0] food_x,
    output wire [15:0] food_y
);

    reg [15:0] lfsr = 16'hACE1;
    wire feedback;
    
    assign feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            lfsr <= 16'hACE1;
        else
            lfsr <= {lfsr[14:0], feedback};
    end
    
    assign food_x = {8'b0, lfsr[7:0]} * 16 + 16'h0020;
    assign food_y = {8'b0, lfsr[15:8]} * 16 + 16'h0020;

endmodule
