import opcodes::*;
module alu (input logic clk,
            input logic [7:0] accum, 
            input logic [7:0] data,     
            input opcode_t opcode,
            output logic [7:0] out,
            output logic zero
            );
  
timeunit 1ns;
timeprecision 100ps;
  
  always_comb
  zero = (accum == 0) ? 1 : 0;

  always @(negedge clk)
    unique case (opcode)
      HLT: out <= accum;
      SKZ: out <= accum;
      ADD: out <= accum + data;   
      AND: out <= accum & data;
      XOR: out <= accum ^ data;
      LDA: out <= data;
      STO: out <= accum;
      JMP: out <= accum;
  endcase  
  
endmodule:alu


