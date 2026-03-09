module snake_entity (
    input wire clk,
    input wire reset,
    input wire [1:0] direction,
    input wire [15:0] food_x,
    input wire [15:0] food_y,
    output reg [3199:0] snake_out,
    output reg [9:0] snake_len,
    output reg game_over
);

    reg [15:0] snake_x [0:99];
    reg [15:0] snake_y [0:99];
    reg [9:0] length = 10'b1;
    reg [31:0] speed_counter = 32'b0;
    
    localparam SPEED_DIVISOR = 32'h2FAF080;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            length <= 10'd1;
            snake_x[0] <= 16'h0100;
            snake_y[0] <= 16'h0100;
        end else begin
            if (speed_counter == SPEED_DIVISOR) begin
                speed_counter <= 32'b0;
                
                // Move snake based on direction
                case (direction)
                    2'b00: snake_y[0] <= snake_y[0] - 16;  // Up
                    2'b01: snake_x[0] <= snake_x[0] + 16;  // Right
                    2'b10: snake_x[0] <= snake_x[0] - 16;  // Left
                    2'b11: snake_y[0] <= snake_y[0] + 16;  // Down
                endcase
            end else begin
                speed_counter <= speed_counter + 1;
            end
        end
    end
    
    always @(*) begin
        snake_len = length;
    end

endmodule
