module memory (input logic read, write, clk,
               input logic [4:0] addr,
               input logic [7:0] data_in,
               output logic [7:0] data_out);

 timeunit 1ns;
 timeprecision 100ps; 
 logic [7:0] memory [0:31]; 
  
  always @(posedge clk)
    if (write && !read)
      #1 memory[addr] <= data_in;
    
  always_ff @(posedge clk iff ((read == '1) && (write == '0)))
      data_out <= memory[addr];
       
endmodule:memory