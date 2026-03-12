// 100 MHz to 25 MHz Clock Divider for Basys 3
// Divides the onboard 100 MHz oscillator to generate
// the 25 MHz pixel clock needed for 640x480 @ 60Hz VGA
module clk_div_25mhz (
    input  wire clk_100mhz,    // 100 MHz system clock (Basys 3 W5 pin)
    input  wire reset,          // Active high reset
    output reg  clk_25mhz = 0  // 25 MHz pixel clock output
);

    reg [1:0] count = 2'b00;

    always @(posedge clk_100mhz or posedge reset) begin
        if (reset) begin
            count      <= 2'b00;
            clk_25mhz <= 1'b0;
        end else begin
            if (count == 2'b01) begin
                clk_25mhz <= ~clk_25mhz;
                count      <= 2'b00;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule
