module test_cpu; 

timeunit 1ns;
timeprecision 100ps; 
    
    import opcodes::*;
    
    logic clk, alu_clk, control_clk, clk2, fetch, halt;
    logic rst, load_ir;
    opcode_t   topcode;
    logic [12*8:1] testfile;
    logic [31:0] test_number;
    logic [3:0] count;
    
`define PERIOD 10
    logic master_clk = 1'b1;
    always
        #(`PERIOD/2) master_clk = ~master_clk;

    always @(posedge master_clk or negedge rst)
       if (~rst)
         count <= 3'b0;
       else
         count <= count + 1;
    
    assign control_clk = ~count[0];
    assign clk  = count[1];
    assign fetch = ~count[3];
    assign alu_clk = ~(count == 4'hc);
 
    cpu     cpu_test (
                .halt,
                .load_ir,
                .clk,
                .alu_clk,    
                .control_clk,    
                .fetch,
                .rst
                );

 initial
    $timeformat ( -9, 1," ns", 12);

 initial  
    forever begin
        $display ( "Enter ' deposit test_number # ; run' \n" );
        $stop;
        if ( test_number > 3 )
          begin
            $display ( "Test number %d is invalid", test_number );
          end
        else
          begin
            case ( test_number )
              1: begin
                   $display ( "CPUtest1 - BASIC CPU DIAGNOSTIC PROGRAM \n" );
                   $display ( "THIS TEST SHOULD HALT WITH THE PC AT 17 hex\n" );
                 end
              2: begin
                   $display ( "CPUtest2 - ADVANCED CPU DIAGNOSTIC PROGRAM\n" );
                   $display ( "THIS TEST SHOULD HALT WITH THE PC AT 10 hex\n" );
                 end
              3: begin
                   $display ( "CPUtest3 - FIBONACCI NUMBERS to 144\n" );
                   $display ( "THIS TEST SHOULD HALT WITH THE PC AT 0C hex\n" );
                 end
            endcase
            testfile = { "CPUtest", 8'h30+test_number[7:0], ".dat" };
            $readmemb (testfile, cpu_test.memory1.memory);

            rst_ = 1;
            repeat (2) @(negedge master_clk);
            rst_ = 0;
            repeat (2) @(negedge master_clk);
            rst_ = 1;
            $display("     TIME       PC    INSTR    OP   ADR   DATA\n");
            $display("  ----------    --    -----    --   ---   ----\n");

            while (!halt)
              @( posedge clk )
              if (load_ir)
                begin
                  #(`PERIOD/2)
                  topcode =  cpu_test.opcode;
                  $display ( "%t    %h    %s      %h    %h     %h     %h",
                    $time,cpu_test.pc_out, topcode.name(), cpu_test.opcode,
                    cpu_test.mux_addr, cpu_test.alu_out, cpu_test.data);

                   if ((test_number == 3) && (topcode == JMP))
                   $display ( "Next Fibonacci number is %d",
                     cpu_test.memory1.memory[5'h1B] );
                end
              if ( test_number == 1 && cpu_test.pc_out !== 5'h17
              || test_number == 2 && cpu_test.pc_out !== 5'h10
              || test_number == 3 && cpu_test.pc_out !== 5'h0C
              || cpu_test.pc_out === 5'hXX )
               begin
                  $display ( "CPU TEST %0d FAILED with pc_out at %h",test_number , cpu_test.pc_out);
                  $finish;
               end
            $display ( "\nCPU TEST %0d PASSED",test_number);
          end
      end


endmodule    