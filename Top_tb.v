`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/17/2026 08:34:25 PM
// Design Name: 
// Module Name: Top_tb
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


module Top_tb;

reg [3:0] A,B;
reg S, CIN;
wire [6:0] CA;

Top uut (.A(A), .B(B), .S(S), .CIN(CIN), .CA(CA));

task run_case;

    input [3:0] a_in, b_in;
    input cin_in, s_in;
    begin
    A= a_in; B= b_in; CIN=cin_in; S= s_in;
    #20;
    $display("A=%2d B=%2d CIN=%b S=%b -> CA=%b   (%s path)",
                      A, B, CIN, S, CA, s_in ? "COUT-CONCAT" : "SUM");

    end
    endtask
    
    initial begin
    
    run_case(4'd3, 4'd4, 1'b0, 1'b0);
    run_case(4'd9, 4'd4, 1'b0, 1'b0);
    run_case(4'd5, 4'd6, 1'b0, 1'b0);
    run_case(4'd2, 4'd4, 1'b0, 1'b0);
    run_case(4'd1, 4'd4, 1'b0, 1'b0);
    
    $finish;
    
    end

endmodule
