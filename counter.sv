module counter (input logic [4:0] data,
                input logic rst, load_pc, enable, clk,
                output logic [4:0] count);
  
timeunit 1ns;
timeprecision 100ps;
  
  always@(posedge clk or negedge rst) 
    if (!rst)
      count <= 0;  
    else if (load_pc)
    count <= data; 
    else if (enable)
    count <= count + 1;

endmodule:counter