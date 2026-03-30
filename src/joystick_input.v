module snake_game_top (
    input wire CLK100MHZ,
    input wire BTNC,  // Center button for Reset
    input wire BTNU,  // Up
    input wire BTND,  // Down
    input wire BTNL,  // Left
    input wire BTNR,  // Right
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
    
    assign reset = BTNC; // Basys 3 buttons are active-high
    
    // Connect the new button controller
    button_controller control_inst (
        .clk(CLK100MHZ),
        .reset(reset),
        .btnU(BTNU),
        .btnD(BTND),
        .btnL(BTNL),
        .btnR(BTNR),
        .direction(direction)
    );
    
    vga_controller vga_inst (
        .pixel_clk(pixel_clk),
        .reset_n(~reset), // VGA usually expects active-low reset_n
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

    // Note: You will need to add your Score Display logic here 
    // to drive CA and CB if that is part of your project.

endmodule
