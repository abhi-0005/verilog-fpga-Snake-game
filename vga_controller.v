module vga_controller (
    input wire pixel_clk,
    input wire reset_n,
    output reg h_sync,
    output reg v_sync,
    output reg disp_ena,
    output reg [10:0] column,
    output reg [9:0] row
);

    reg [11:0] h_count = 12'b0;
    reg [10:0] v_count = 11'b0;
    
    localparam h_pixels = 640;
    localparam v_pixels = 480;
    
    always @(posedge pixel_clk or negedge reset_n) begin
        if (!reset_n) begin
            h_count <= 12'b0;
            v_count <= 11'b0;
        end else begin
            if (h_count == 1367) begin
                h_count <= 12'b0;
                if (v_count == 767)
                    v_count <= 11'b0;
                else
                    v_count <= v_count + 1;
            end else begin
                h_count <= h_count + 1;
            end
        end
    end
    
    always @(*) begin
        h_sync = (h_count >= 656 && h_count < 752) ? 1'b1 : 1'b0;
        v_sync = (v_count >= 490 && v_count < 492) ? 1'b1 : 1'b0;
        disp_ena = (h_count < h_pixels && v_count < v_pixels) ? 1'b1 : 1'b0;
    end
    
    always @(*) begin
        column = h_count[10:0];
        row = v_count[9:0];
    end

endmodule
