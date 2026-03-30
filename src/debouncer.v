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
