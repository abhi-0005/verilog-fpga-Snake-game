// ======================================================
// Snake Game Parameters Header (game_params.vh)
// Basys 3 FPGA | Vivado | Verilog Project
// ======================================================

// Grid dimensions (matches VGA area)
`define GRID_WIDTH        32        // Number of columns (horizontal cells)
`define GRID_HEIGHT       20        // Number of rows (vertical cells)

// Snake settings
`define SNAKE_MAX_LENGTH  100       // Maximum snake segments

// Color definitions (RGB 12-bit: [11:8]=Red, [7:4]=Green, [3:0]=Blue)
`define COLOR_SNAKE       12'h0F0   // Green snake
`define COLOR_FOOD        12'hF00   // Red food
`define COLOR_BG          12'h333   // Dark gray background

// Timing: clock cycles per snake move (controls game speed)
// Adjust this for Basys 3 at 25MHz pixel clock, e.g. ~40 Hz snake
`define MOVE_PERIOD       24'd1000000

// Direction encoding (optional)
`define DIR_UP            2'b00
`define DIR_RIGHT         2'b01
`define DIR_LEFT          2'b10
`define DIR_DOWN          2'b11

// Starting parameters (optional)
//`define SNAKE_START_X     (`GRID_WIDTH/2)
//`define SNAKE_START_Y     (`GRID_HEIGHT/2)

// ======================================================
// Usage Example:
//   `include "game_params.vh"
//   Use parameters in Verilog modules: `GRID_WIDTH, etc.
// ======================================================
