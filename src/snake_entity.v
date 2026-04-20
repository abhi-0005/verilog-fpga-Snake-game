module snake_entity (
    input wire clk,
    input wire reset,
    input wire [1:0] direction,
    input wire btn_any,
    input wire [15:0] food_x,
    input wire [15:0] food_y,
    output reg [3199:0] snake_out,
    output reg [9:0] snake_len,
    output reg game_over,
    output reg food_eaten
);
    reg [15:0] snake_x [0:99];
    reg [15:0] snake_y [0:99];
    reg [9:0]  length          = 10'd1;
    reg [31:0] speed_counter   = 32'b0;
    reg [31:0] startup_counter = 32'b0;
    reg        started         = 0;
    reg        grow            = 0;
    reg        startup_done    = 0;

    localparam X_MIN          = 16'd0;
    localparam X_MAX          = 16'd624;
    localparam Y_MIN          = 16'd0;
    localparam Y_MAX          = 16'd464;
    localparam SPEED_DIVISOR  = 32'd50000000;
    localparam CELL           = 16'd16;
    localparam STARTUP_DELAY  = 32'd100000000;

    integer i, k;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            length          <= 10'd1;
            snake_x[0]      <= 16'd160;
            snake_y[0]      <= 16'd160;
            for (k = 1; k < 100; k = k + 1) begin
                snake_x[k] <= 16'd160;
                snake_y[k] <= 16'd160;
            end
            speed_counter   <= 32'b0;
            startup_counter <= 32'b0;
            game_over       <= 0;
            started         <= 0;
            grow            <= 0;
            startup_done    <= 0;
            food_eaten      <= 0;
        end else begin

            food_eaten <= 0;

            if (!startup_done) begin
                if (startup_counter == STARTUP_DELAY)
                    startup_done <= 1;
                else
                    startup_counter <= startup_counter + 1;
            end

            if (startup_done && btn_any)
                started <= 1;

            if (started && !game_over) begin
                if (speed_counter == SPEED_DIVISOR) begin
                    speed_counter <= 32'b0;

                    // Shift body
                    for (i = 99; i > 0; i = i - 1) begin
                        snake_x[i] <= snake_x[i-1];
                        snake_y[i] <= snake_y[i-1];
                    end

                    // Move head
                    case (direction)
                        2'b00: snake_y[0] <= snake_y[0] - CELL;
                        2'b01: snake_x[0] <= snake_x[0] + CELL;
                        2'b10: snake_x[0] <= snake_x[0] - CELL;
                        2'b11: snake_y[0] <= snake_y[0] + CELL;
                    endcase

                    // Increase length if growing
                    if (grow) begin
                        if (length < 100)
                            length <= length + 1;
                        grow <= 0;
                    end

                    // Border collision
                    case (direction)
                        2'b00: if (snake_y[0] == Y_MIN) game_over <= 1;
                        2'b01: if (snake_x[0] == X_MAX) game_over <= 1;
                        2'b10: if (snake_x[0] == X_MIN) game_over <= 1;
                        2'b11: if (snake_y[0] == Y_MAX) game_over <= 1;
                    endcase

                    // Food collision
                    if (snake_x[0] == food_x && snake_y[0] == food_y) begin
                        grow       <= 1;
                        food_eaten <= 1;
                    end

                    // Self collision
                    for (i = 1; i < 100; i = i + 1) begin
                        if (i < length) begin
                            if (snake_x[0] == snake_x[i] &&
                                snake_y[0] == snake_y[i])
                                game_over <= 1;
                        end
                    end

                end else begin
                    speed_counter <= speed_counter + 1;
                end
            end
        end
    end

    // Pack all segments - unused ones hidden at head position
    genvar g;
    generate
        for (g = 0; g < 100; g = g + 1) begin : pack_seg
            always @(*) begin
                if (g < length) begin
                    snake_out[(99-g)*32 + 31 : (99-g)*32 + 16] = snake_x[g];
                    snake_out[(99-g)*32 + 15 : (99-g)*32]      = snake_y[g];
                end else begin
                    snake_out[(99-g)*32 + 31 : (99-g)*32 + 16] = snake_x[0];
                    snake_out[(99-g)*32 + 15 : (99-g)*32]      = snake_y[0];
                end
            end
        end
    endgenerate

    always @(*) begin
        snake_len = length;
    end

endmodule
