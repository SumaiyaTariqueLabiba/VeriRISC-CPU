module mux
           (input logic [4:0] in_a, in_b,
            input logic fetch,
            output logic [4:0] out);
  
 timeunit 1ns;
 timeprecision 100ps;
  
  always_comb
    unique case (fetch)
      1'b1: out = in_a;
      1'b0: out = in_b;
      default: out = 'x;
    endcase 
  
endmodule:mux