module snake_game_top (
    input wire CLK100MHZ,
    input wire BTNC,
    input wire BTNU,
    input wire BTND,
    input wire BTNL,
    input wire BTNR,
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire VGA_HS,
    output wire VGA_VS,
    output wire [6:0] CA,
    output wire [6:0] CB
);

    wire clk_25mhz;
    wire reset;
    reg [1:0] direction;

    reg  [15:0] food_x_reg, food_y_reg;
    wire [15:0] food_x, food_y;
    wire db_U, db_D, db_L, db_R;
    wire btn_any;
    wire disp_ena;
    wire [10:0] column;
    wire [9:0]  row;
    wire [3:0]  vga_r_int, vga_g_int, vga_b_int;
    wire [3199:0] snake_out;
    wire [9:0]  snake_len;
    wire game_over;
    wire food_eaten;

    assign food_x  = food_x_reg;
    assign food_y  = food_y_reg;
    assign reset   = BTNC;
    assign btn_any = db_U | db_D | db_L | db_R;

    // LFSR random number generator
    reg [15:0] lfsr = 16'hACE1;
    always @(posedge CLK100MHZ) begin
        if (reset)
            lfsr <= 16'hACE1;
        else
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
    end

    // Food position update
    always @(posedge CLK100MHZ) begin
        if (reset) begin
            food_x_reg <= 16'd192;
            food_y_reg <= 16'd160;
        end else if (food_eaten) begin
            food_x_reg <= (lfsr[5:0] * 16) % 624;
            food_y_reg <= (lfsr[11:6] * 16) % 464;
        end
    end

    // Clock divider
    clk_div_25mhz clk_inst (
        .clk_100mhz(CLK100MHZ),
        .reset(reset),
        .clk_25mhz(clk_25mhz)
    );

    // Debouncers
    debouncer dU (.clk(CLK100MHZ), .btn_in(BTNU), .btn_out(db_U));
    debouncer dD (.clk(CLK100MHZ), .btn_in(BTND), .btn_out(db_D));
    debouncer dL (.clk(CLK100MHZ), .btn_in(BTNL), .btn_out(db_L));
    debouncer dR (.clk(CLK100MHZ), .btn_in(BTNR), .btn_out(db_R));

    // Direction logic
    always @(posedge CLK100MHZ) begin
        if (reset)
            direction <= 2'b01;
        else begin
            if      (db_U) direction <= 2'b00;
            else if (db_R) direction <= 2'b01;
            else if (db_L) direction <= 2'b10;
            else if (db_D) direction <= 2'b11;
        end
    end

    // VGA Controller
    vga_controller vga_inst (
        .pixel_clk(clk_25mhz),
        .reset_n(~reset),
        .snake_out(snake_out),
        .snake_len(snake_len),
        .food_x(food_x),
        .food_y(food_y),
        .game_over(game_over),
        .h_sync(VGA_HS),
        .v_sync(VGA_VS),
        .disp_ena(disp_ena),
        .column(column),
        .row(row),
        .vga_r(vga_r_int),
        .vga_g(vga_g_int),
        .vga_b(vga_b_int)
    );

    // Snake Entity
    snake_entity snake_inst (
        .clk(CLK100MHZ),
        .reset(reset),
        .direction(direction),
        .btn_any(btn_any),
        .food_x(food_x),
        .food_y(food_y),
        .snake_out(snake_out),
        .snake_len(snake_len),
        .game_over(game_over),
        .food_eaten(food_eaten)
    );

    // VGA RGB output
    assign VGA_R = (disp_ena) ? vga_r_int : 4'b0000;
    assign VGA_G = (disp_ena) ? vga_g_int : 4'b0000;
    assign VGA_B = (disp_ena) ? vga_b_int : 4'b0000;

    // 7-Segment Display
    seg7_controller seg7_inst (
        .clk(CLK100MHZ),
        .reset(reset),
        .score(snake_len),
        .CA(CA),
        .CB(CB)
    );

endmodule
