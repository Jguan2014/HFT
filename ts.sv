`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////



//circular buffer? 

module sequence_aligner(
	input logic clk,
	input logic rst,
	input logic [6:0] in_seq,
	input logic [2:0] in_num,	//determine how many of the 7btis are avalid 
	output logic [15:0] out_seq,	//send out sequence once collected 16bits 
	output logic out_valid
);
	
//Cycle 0: in_seq = 7'b0000000; in_num = 3'd0;   
//Cycle 1: in_seq = 7'b1111111; in_num = 3'd7;		temp = 1111111
//Cycle 2: in_seq = 7'b1000011; in_num = 3'd7;		temp = 1111111'1000011
//Cycle 3: in_seq = 7'bxxx0110; in_num = 3'd3;		out_seq = 1111111'1000011'11 //when 16-bits are collected send it out 
//Cycle 4: in_seq = 7'b0000000; in_num = 3'd0;
//Cycle 5: in_seq = 7'b0000000; in_num = 3'd0;


logic [4:0] counter ;   
logic [31:0] data_buf; //15+7 = 22
logic temp; 
    


    always @(posedge clk or posedge rst) begin
      //shift in useful stuff 
        if (rst) begin 
            counter <= '0;
            data_buf <= '0;
        end else begin 
        
            if (counter >= 16) begin //0 to 21
                counter <= counter -16; 
                out_valid <= 1;
                case(counter)
                    5'b10000: //16
                        out_seq <= data_buf[15:0]; 
                    5'b10001: //17
                        out_seq <= data_buf[16:1]; 
                    5'b10010: //18
                        out_seq <= data_buf[17:2]; 
                        
                    5'b10011: //19
                        out_seq <= data_buf[18:3]; 
                        
                    5'b10110: //20
                        out_seq <= data_buf[19:4]; 
                    5'b10111: //21
                        out_seq <= data_buf[20:5]; 
                    5'b11000: //22 
                        out_seq <= data_buf[21:6]; //16 bits 
                    
                endcase 
            end else begin 
                counter <= counter + in_num; //running sum 
            end 
            
            case (in_num)    
                3'b000:
                      data_buf <= data_buf;//no shift 
                3'b001: 
                      data_buf <= {data_buf[30:0],in_seq[0]}; //
                3'b010: 
                      data_buf <= {data_buf[29:0],in_seq[1:0]}; //
                3'b011: 
                      data_buf <= {data_buf[28:0],in_seq[2:0]}; //      
                3'b100: 
                      data_buf <= {data_buf[27:0],in_seq[3:0]}; //   
                3'b101: 
                      data_buf <= {data_buf[26:0],in_seq[4:0]}; //
                 3'b110: 
                      data_buf <= {data_buf[25:0],in_seq[5:0]}; //
                 3'b111: 
                      data_buf <= {data_buf[24:0],in_seq[6:0]}; //
                      
    
            endcase 
        end 

    end 


 
endmodule 
