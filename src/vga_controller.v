module vga_controller (
    input wire pixel_clk,
    input wire reset_n,
    input wire [3199:0] snake_out,
    input wire [9:0]    snake_len,
    input wire [15:0]   food_x,
    input wire [15:0]   food_y,
    input wire game_over,
    output reg h_sync,
    output reg v_sync,
    output reg disp_ena,
    output reg [10:0] column,
    output reg [9:0]  row,
    output reg [3:0]  vga_r,
    output reg [3:0]  vga_g,
    output reg [3:0]  vga_b
);
    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = 800;

    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 33;
    localparam V_TOTAL   = 525;

    localparam CELL      = 16;
    localparam BORDER    = 4;

    reg [10:0] h_count = 0;
    reg [9:0]  v_count = 0;
    reg [24:0] flash_counter = 0;
    reg        flash = 0;

    // Extract segment positions from snake_out
    wire [15:0] seg_x [0:99];
    wire [15:0] seg_y [0:99];

    genvar k;
    generate
        for (k = 0; k < 100; k = k + 1) begin : seg_extract
            assign seg_x[k] = snake_out[(99-k)*32 + 31 : (99-k)*32 + 16];
            assign seg_y[k] = snake_out[(99-k)*32 + 15 : (99-k)*32];
        end
    endgenerate

    // Check if current pixel is in any snake segment
    integer m;
    reg snake_pixel;
    reg head_pixel;

    always @(*) begin
        snake_pixel = 0;
        head_pixel  = 0;
        for (m = 0; m < 100; m = m + 1) begin
            if (m < snake_len) begin
                if (h_count >= seg_x[m] && h_count < seg_x[m] + CELL &&
                    v_count >= seg_y[m] && v_count < seg_y[m] + CELL) begin
                    snake_pixel = 1;
                    if (m == 0)
                        head_pixel = 1;
                end
            end
        end
    end

    // Counter logic
    always @(posedge pixel_clk or negedge reset_n) begin
        if (!reset_n) begin
            h_count       <= 0;
            v_count       <= 0;
            flash_counter <= 0;
            flash         <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end else begin
                h_count <= h_count + 1;
            end

            // Flash for game over
            if (game_over) begin
                if (flash_counter == 25'd12500000) begin
                    flash_counter <= 0;
                    flash <= ~flash;
                end else
                    flash_counter <= flash_counter + 1;
            end else begin
                flash_counter <= 0;
                flash         <= 0;
            end
        end
    end

    // Sync signals
    always @(*) begin
        h_sync   = ~(h_count >= (H_VISIBLE + H_FRONT) &&
                     h_count <  (H_VISIBLE + H_FRONT + H_SYNC));
        v_sync   = ~(v_count >= (V_VISIBLE + V_FRONT) &&
                     v_count <  (V_VISIBLE + V_FRONT + V_SYNC));
        disp_ena = (h_count < H_VISIBLE && v_count < V_VISIBLE);
        column   = h_count;
        row      = v_count;
    end

    // Color logic
    always @(*) begin
        if (!disp_ena) begin
            vga_r = 4'h0;
            vga_g = 4'h0;
            vga_b = 4'h0;

        end else if (game_over) begin
            // Flash red and black
            if (flash) begin
                vga_r = 4'hF;
                vga_g = 4'h0;
                vga_b = 4'h0;
            end else begin
                vga_r = 4'h0;
                vga_g = 4'h0;
                vga_b = 4'h0;
            end

        end else if (h_count < BORDER || h_count >= H_VISIBLE - BORDER ||
                     v_count < BORDER || v_count >= V_VISIBLE - BORDER) begin
            // White border
            vga_r = 4'hF;
            vga_g = 4'hF;
            vga_b = 4'hF;

        end else if (head_pixel) begin
            // Snake head - bright green
            vga_r = 4'h0;
            vga_g = 4'hF;
            vga_b = 4'h0;

        end else if (snake_pixel) begin
            // Snake body - dark green
            vga_r = 4'h0;
            vga_g = 4'h7;
            vga_b = 4'h0;

        end else if (h_count >= food_x && h_count < food_x + CELL &&
                     v_count >= food_y && v_count < food_y + CELL) begin
            // Food - red
            vga_r = 4'hF;
            vga_g = 4'h0;
            vga_b = 4'h0;

        end else begin
            // Background - black
            vga_r = 4'h0;
            vga_g = 4'h0;
            vga_b = 4'h0;
        end
    end

endmodule
