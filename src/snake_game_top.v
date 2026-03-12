module snake_game_top (
    input wire CLK100MHZ,
    input wire BTNC,
    input wire [11:0] JA1,
    input wire [11:0] JA2,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire VGA_HS,
    output wire VGA_VS,
    output wire [6:0] CA,
    output wire [6:0] CB
);

    wire pixel_clk;
    wire reset;
    wire [1:0] direction;
    wire [15:0] food_x, food_y;
    
    assign reset = ~BTNC;
    
    vga_controller vga_inst (
        .pixel_clk(pixel_clk),
        .reset_n(BTNC),
        .h_sync(VGA_HS),
        .v_sync(VGA_VS)
    );
    
    snake_entity snake_inst (
        .clk(pixel_clk),
        .reset(reset),
        .direction(direction),
        .food_x(food_x),
        .food_y(food_y)
    );

endmodule
