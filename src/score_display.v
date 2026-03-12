module score (
    input wire [9:0] point,
    output reg [6:0] display_r,
    output reg [6:0] display_l
);

    reg [6:0] segments [0:9];
    
    initial begin
        segments[0] = 7'b1000000;  // 0
        segments[1] = 7'b1111001;  // 1
        segments[2] = 7'b0100100;  // 2
        segments[3] = 7'b0110000;  // 3
        segments[4] = 7'b0011001;  // 4
        segments[5] = 7'b0010010;  // 5
        segments[6] = 7'b0000010;  // 6
        segments[7] = 7'b1111000;  // 7
        segments[8] = 7'b0000000;  // 8
        segments[9] = 7'b0010000;  // 9
    end
    
    always @(*) begin
        display_r = segments[point[3:0]];
        display_l = segments[point[9:4]];
    end

endmodule
