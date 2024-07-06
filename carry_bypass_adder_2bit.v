`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 02:43:31
// Design Name: 
// Module Name: carry_bypass_adder_2bit
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


module carry_bypass_adder_2bit(
    input [1:0] A,
    input [1:0] B,
    input cin,
    output [1:0] sum,
    output cout
);

wire [1:0] c_out;
wire [1:0] s_wire;

assign c_out[0] = cin;
assign c_out[1] = (A[0] & B[0]) | (A[1] & B[0]) | (A[1] & B[1]);
assign sum[0] = A[0] ^ B[0] ^ cin;
assign sum[1] = A[1] ^ B[1] ^ c_out[0];

assign cout = c_out[1];

endmodule

