module vga_controller (
    input wire pixel_clk,       // 25 MHz for 640x480 @ 60Hz
    input wire reset_n,         // Active low reset
    output reg h_sync,
    output reg v_sync,
    output reg disp_ena,
    output reg [10:0] column,
    output reg [9:0] row
);

    // 640x480 @ 60Hz VGA standard timing
    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = 800;    // FIXED: was 1368

    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 10;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 33;
    localparam V_TOTAL   = 525;    // FIXED: was 768

    reg [10:0] h_count = 0;
    reg [9:0]  v_count = 0;

    // Pixel counters
    always @(posedge pixel_clk or negedge reset_n) begin
        if (!reset_n) begin
            h_count <= 0;
            v_count <= 0;
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
        end
    end

    // Sync pulses (active LOW for 640x480 standard)
    always @(*) begin
        h_sync   = ~(h_count >= (H_VISIBLE + H_FRONT) &&
                      h_count <  (H_VISIBLE + H_FRONT + H_SYNC));
        v_sync   = ~(v_count >= (V_VISIBLE + V_FRONT) &&
                      v_count <  (V_VISIBLE + V_FRONT + V_SYNC));
        disp_ena = (h_count < H_VISIBLE && v_count < V_VISIBLE);
    end

    // Output pixel coordinates
    always @(*) begin
        column = h_count;
        row    = v_count;
    end

endmodule
