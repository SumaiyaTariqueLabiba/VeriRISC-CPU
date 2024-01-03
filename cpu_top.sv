
module cpu (
    output logic halt, load_ir,  
    input  logic clk, rst, fetch, control_clk, alu_clk
    );

    timeunit 1ns;
    timeprecision 100ps;

import opcodes::*;
logic    [7:0]   data, alu_out, accum, ir_out;
logic    [4:0]   pc_out, ir_addr, mux_addr;
opcode_t   opcode;
logic load_ac, mem_rd, mem_wr, inc_pc, load_pc, zero;

//datapath connections

assign opcode = opcode_t'(ir_out[7:5]);
assign ir_addr = ir_out[4:0];

register accumulator (.out (accum),
                    .data_in (alu_out),
                    .clk,
                    .enable (load_ac),
                    .rst
                    );
        
controller controller1 (.load_ac,
                .mem_rd,
                .mem_wr,
                .inc_pc,
                .load_pc,
                .load_ir,
                .halt,
                .opcode,
                .zero,
                .clk(control_clk),
                .rst,
                );

register ins_reg (.out (ir_out),
                 .data,          
                 .clk,
                 .enable (load_ir),
                 .rst
                 ); 

counter  pc     (.count (pc_out),
                .data (ir_addr),
                .clk,
                .load_pc (load_pc),
                .enable (inc_pc),
                .rst
                );

alu  alu1      (.out (alu_out),
                .zero,
                .clk(alu_clk) ,
                .accum,
                .data(data), 
                .opcode
               );

mux mux1       ( .out (mux_addr),
                .in_a (pc_out),
                .in_b (ir_addr),
                .fetch 
               );

memory memory1  (.clk(~control_clk),
                .read (mem_rd),
                .write (mem_wr), 
                .addr(mux_addr)  ,
                .data_in(alu_out),
                .data_out(data)
                );                      

endmodule
