module FA_1 (input A, B, CI, output SUM, CO);
    assign SUM = A ^ B ^ CI;
    assign CO = (B & CI) | (A & CI) | (A & B);
endmodule

module FA_Ripple_4 (input [3:0] A, input [3:0] B, input CI, output [3:0] SUM, output CO);
    wire c1, c2, c3; 

    FA_1 uut0 (.A(A[0]), .B(B[0]), .CI(CI), .SUM(SUM[0]), .CO(c1));
    FA_1 uut1 (.A(A[1]), .B(B[1]), .CI(c1), .SUM(SUM[1]), .CO(c2));
    FA_1 uut2 (.A(A[2]), .B(B[2]), .CI(c2), .SUM(SUM[2]), .CO(c3));
    FA_1 uut3 (.A(A[3]), .B(B[3]), .CI(c3), .SUM(SUM[3]), .CO(CO));
endmodule

module mux_2to1_4bit (
    input  [3:0] in0,
    input  [3:0] in1,
    input        sel,
    output [3:0] out
);
    assign out[0] = (~sel & in0[0]) | (sel & in1[0]);
    assign out[1] = (~sel & in0[1]) | (sel & in1[1]);
    assign out[2] = (~sel & in0[2]) | (sel & in1[2]);
    assign out[3] = (~sel & in0[3]) | (sel & in1[3]);
endmodule

module bin2bcd (
    input      [11:0] bin_in,
    output reg [15:0] bcd_out
);
    integer i;

    always @(*) begin
        bcd_out = 16'b0;
        for (i = 11; i >= 0; i = i - 1) begin
            if (bcd_out[3:0]   >= 4'd5) bcd_out[3:0]   = bcd_out[3:0]   + 4'd3;
            if (bcd_out[7:4]   >= 4'd5) bcd_out[7:4]   = bcd_out[7:4]   + 4'd3;
            if (bcd_out[11:8]  >= 4'd5) bcd_out[11:8]  = bcd_out[11:8]  + 4'd3;
            if (bcd_out[15:12] >= 4'd5) bcd_out[15:12] = bcd_out[15:12] + 4'd3;
            bcd_out = {bcd_out[14:0], bin_in[i]};
        end
    end
endmodule

module seg_decoder (
    input      [3:0] bcd_digit,
    output reg [6:0] seg
);
    always @(*) begin
        case (bcd_digit)
            4'd0: seg = 7'b0000001;
            4'd1: seg = 7'b1001111;
            4'd2: seg = 7'b0010010;
            4'd3: seg = 7'b0000110;
            4'd4: seg = 7'b1001100;
            4'd5: seg = 7'b0100100;
            4'd6: seg = 7'b0100000;
            4'd7: seg = 7'b0001111;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0000100;
            default: seg = 7'b1111111;
        endcase
    end
endmodule

module Anode_Gen (
    output reg [3:0] anode_o,
    input            clk,
    input      [15:0] BCD_in,
    output reg [3:0] digit
);
    reg [9:0] g_count = 0;
    reg [3:0] anode;

    initial begin
        anode = 4'b1110;
    end

    always @(posedge clk) begin
        g_count <= g_count + 1'b1;
        if (g_count == 10'd1023) begin
            anode_o <= anode;
            case (anode)
                4'b1110: begin
                    digit <= BCD_in[3:0];
                    anode <= 4'b1101;
                end
                4'b1101: begin
                    digit <= BCD_in[7:4];
                    anode <= 4'b1011;
                end
                4'b1011: begin
                    digit <= BCD_in[11:8];
                    anode <= 4'b0111;
                end
                4'b0111: begin
                    digit <= BCD_in[15:12];
                    anode <= 4'b1110;
                end
                default: begin
                    digit <= 4'bxxxx;
                    anode <= 4'b1110;
                end
            endcase
        end
    end
endmodule

module multi_digit_driver (
    input         clk,
    input  [15:0] bcd_in,
    output [6:0]  seg,
    output [3:0]  an
);
    wire [3:0] digit;

    Anode_Gen u_anode_gen (
        .clk(clk),
        .BCD_in(bcd_in),
        .anode_o(an),
        .digit(digit)
    );

    seg_decoder u_seg_dec (
        .bcd_digit(digit),
        .seg(seg)
    );
endmodule

module top_adder_7seg (
    input        clk,
    input  [3:0] sw_a,
    input  [3:0] sw_b,
    input  [3:0] sw_alt,
    input        mux_sel,
    output [6:0] seg,
    output [3:0] an,
    output       dp
);
    wire [3:0]  sum;
    wire        cout;
    wire [3:0]  mux_out;
    wire [15:0] bcd;

    assign dp = 1'b1;

    FA_Ripple_4 u_add (
        .A(sw_a),
        .B(sw_b),
        .CI(1'b0),
        .SUM(sum),
        .CO(cout)
    );

    mux_2to1_4bit u_mux (
        .in0(sum),
        .in1(sw_alt),
        .sel(mux_sel),
        .out(mux_out)
    );

    bin2bcd u_b2b (
        .bin_in({8'b0, mux_out}),
        .bcd_out(bcd)
    );

    multi_digit_driver u_drv (
        .clk(clk),
        .bcd_in(bcd),
        .seg(seg),
        .an(an)
    );
endmodule
