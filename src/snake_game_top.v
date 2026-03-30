module snake_game_top (
    input wire CLK100MHZ,
    input wire BTNC,       // Used for Reset
    input wire BTNU,       // Up
    input wire BTND,       // Down
    input wire BTNL,       // Left
    input wire BTNR,       // Right
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
    reg [1:0] direction; // Changed to reg so we can update it logic
    wire [15:0] food_x, food_y;
    
    // Internal wires for cleaned-up button signals
    wire db_U, db_D, db_L, db_R;
    
    assign reset = ~BTNC; // Assuming your logic uses active-low reset
    
    // --- BUTTON DIRECTION LOGIC ---
    // 00: Up, 01: Down, 10: Left, 11: Right (Verify these vs snake_entity.v)
    always @(posedge CLK100MHZ) begin
        if (reset) begin
            direction <= 2'b11; // Default starting direction (e.g., Right)
        end else begin
            if (db_U)      direction <= 2'b00;
            else if (db_D) direction <= 2'b01;
            else if (db_L) direction <= 2'b10;
            else if (db_R) direction <= 2'b11;
        end
    end

    // --- INSTANTIATE DEBOUNCERS ---
    debouncer dU (.clk(CLK100MHZ), .btn_in(BTNU), .btn_out(db_U));
    debouncer dD (.clk(CLK100MHZ), .btn_in(BTND), .btn_out(db_D));
    debouncer dL (.clk(CLK100MHZ), .btn_in(BTNL), .btn_out(db_L));
    debouncer dR (.clk(CLK100MHZ), .btn_in(BTNR), .btn_out(db_R));

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

// --- DEBOUNCER MODULE ---
module debouncer (
    input clk,
    input btn_in,
    output reg btn_out
);
    reg [19:0] count;
    always @(posedge clk) begin
        if (btn_in) begin
            if (count < 20'hFFFFF) count <= count + 1;
            else btn_out <= 1'b1;
        end else begin
            count <= 0;
            btn_out <= 1'b0;
        end
    end
endmodule
