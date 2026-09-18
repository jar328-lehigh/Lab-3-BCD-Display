`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 08:28:06 PM
// Design Name: 
// Module Name: BCD_tb
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


module BCD_tb;

reg[3:0] bcd;
wire [6:0] seg;

BCD uut (.bcd(bcd), .seg(seg));

integer i;

initial begin

    for (i= 0; i<16; i=i+1) begin
    bcd= i[3:0];
    #10
    $display("t=%0t  bcd=%d (%b)  seg=%b", $time, bcd, bcd, seg);
    end
    $finish;
end
endmodule
