`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 08:06:22 PM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
input [3:0] A, B, input S, CIN, output [6:0] CA);

wire [3:0] bcd_mux_out;
wire [3:0] sum_mux_A;
wire C;
wire [3:0] Cout_mux_B;
assign Cout_mux_B = {3'b0, C};
FA_Ripple_4 uut1(.A(A), .B(B), .CI(CIN), .SUM(sum_mux_A), .CO(C));
BCD uut2 (.bcd(bcd_mux_out), .seg(CA));
mux_2_to_1 uut3 (.A(sum_mux_A), .B(Cout_mux_B), .sel(S), .mux_out(bcd_mux_out));
endmodule
