module seg7_controller (
    input wire clk,
    input wire reset,
    input wire [9:0] score,
    output reg [6:0] CA,
    output reg [6:0] CB
);

    // Clock divider for multiplexing (refresh ~1kHz)
    reg [16:0] refresh_counter = 0;
    reg [1:0] digit_select = 0;

    // BCD digits
    reg [3:0] digit0, digit1, digit2, digit3;

    // 7-segment encoding (active low)
    // Segments: CA[6:0] = gfedcba
    function [6:0] bcd_to_seg;
        input [3:0] bcd;
        case (bcd)
            4'd0: bcd_to_seg = 7'b1000000;
            4'd1: bcd_to_seg = 7'b1111001;
            4'd2: bcd_to_seg = 7'b0100100;
            4'd3: bcd_to_seg = 7'b0110000;
            4'd4: bcd_to_seg = 7'b0011001;
            4'd5: bcd_to_seg = 7'b0010010;
            4'd6: bcd_to_seg = 7'b0000010;
            4'd7: bcd_to_seg = 7'b1111000;
            4'd8: bcd_to_seg = 7'b0000000;
            4'd9: bcd_to_seg = 7'b0010000;
            default: bcd_to_seg = 7'b1111111;
        endcase
    endfunction

    // Split score into 4 BCD digits
    always @(*) begin
        digit0 = score % 10;         // Ones
        digit1 = (score / 10) % 10;  // Tens
        digit2 = (score / 100) % 10; // Hundreds
        digit3 = (score / 1000) % 10;// Thousands
    end

    // Refresh counter
    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end

    // Digit select from top 2 bits of counter
    always @(*) begin
        digit_select = refresh_counter[16:15];
    end

    // Output CA and CB based on selected digit
    always @(*) begin
        case (digit_select)
            2'b00: begin
                CA = bcd_to_seg(digit0);
                CB = 7'b1111110; // Digit 0 (rightmost)
            end
            2'b01: begin
                CA = bcd_to_seg(digit1);
                CB = 7'b1111101; // Digit 1
            end
            2'b10: begin
                CA = bcd_to_seg(digit2);
                CB = 7'b1111011; // Digit 2
            end
            2'b11: begin
                CA = bcd_to_seg(digit3);
                CB = 7'b0111111; // Digit 3 (leftmost)
            end
        endcase
    end

endmodule
