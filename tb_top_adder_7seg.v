`timescale 1ns / 1ps

module tb_top_adder_7seg;

    reg        clk;
    reg  [3:0] sw_a;
    reg  [3:0] sw_b;
    reg  [3:0] sw_alt;
    reg        mux_sel;

    wire [6:0] seg;
    wire [3:0] an;
    wire       dp;

    top_adder_7seg dut (
        .clk(clk),
        .sw_a(sw_a),
        .sw_b(sw_b),
        .sw_alt(sw_alt),
        .mux_sel(mux_sel),
        .seg(seg),
        .an(an),
        .dp(dp)
    );

    always #5 clk = ~clk;

    initial begin
        clk     = 0;
        sw_a    = 4'd0;
        sw_b    = 4'd0;
        sw_alt  = 4'd0;
        mux_sel = 1'b0;

        #100;
        sw_a    = 4'd3;
        sw_b    = 4'd4;

        #100;
        sw_a    = 4'd6;
        sw_b    = 4'd2;

        #100;
        mux_sel = 1'b1;
        sw_alt  = 4'd9;

        #100;
        sw_alt  = 4'd5;

        #100;
        $finish;
    end

endmodule
