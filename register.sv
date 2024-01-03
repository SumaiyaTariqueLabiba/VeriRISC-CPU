
module register (input logic [7:0] data_in,    
                 input logic rst, clk, enable,
                 output logic [7:0] out);
  
 timeunit 1ns;
 timeprecision 100ps;
  
  always_ff @(posedge clk or negedge rst)
    if (!rst)
      out <= 0;
    else if (enable)   
      out <= data_in;  
  
endmodule:register