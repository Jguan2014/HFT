

//circular buffer? 
module sequence_aligner(
	input clk,
	input rst,
	input [6:0] in_seq,
	input [2:0] in_num,	//determine how many of the 7btis are avalid 
	output [15:0] out_seq,	//send out sequence once collected 16bits 
	output out_valid
);
	
//Cycle 0: in_seq = 7'b0000000; in_num = 3'd0;   
//Cycle 1: in_seq = 7'b1111111; in_num = 3'd7;		temp = 1111111
//Cycle 2: in_seq = 7'b1000011; in_num = 3'd7;		temp = 1111111'1000011
//Cycle 3: in_seq = 7'bxxx0110; in_num = 3'd3;		out_seq = 1111111'1000011'11 //when 16-bits are collected send it out 
//Cycle 4: in_seq = 7'b0000000; in_num = 3'd0;
//Cycle 5: in_seq = 7'b0000000; in_num = 3'd0;
	
