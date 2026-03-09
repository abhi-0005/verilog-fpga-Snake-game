module joystick (
    input wire clk,
    input wire reset,
    input wire [11:0] adc_x,
    input wire [11:0] adc_y,
    output reg [1:0] direction
);

    localparam CENTER_X = 12'd2008;
    localparam CENTER_Y = 12'd1978;
    localparam TOLERANCE = 12'd400;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            direction <= 2'b00;
        else begin
            if (adc_x > (CENTER_X + TOLERANCE))
                direction <= 2'b01;   // Right
            else if (adc_x < (CENTER_X - TOLERANCE))
                direction <= 2'b10;   // Left
            else if (adc_y > (CENTER_Y + TOLERANCE))
                direction <= 2'b11;   // Down
            else if (adc_y < (CENTER_Y - TOLERANCE))
                direction <= 2'b00;   // Up
        end
    end

endmodule
