`include "riscv.v"

module tb();
  reg clk=0;
  reg rst=1;
  
  processor riscv(.clk(clk),.rst(rst));
  
  always #5 clk=~clk;

  initial begin 
    #50 rst = 0; 
    riscv.DMEM.mem[3] = 32'd7; // Enter the number here for the factorial
  end
  
  initial begin
    
    // write a program for factorial of the no. at dmem[3] and store it to dmem[7] 
    
    riscv.IMEM.mem[0]  = 32'b0000000_00011_00000_010_00101_0000011;      // 0    lw x5, 3(x0)	 
    riscv.IMEM.mem[1]  = 32'b0000000_00101_00000_000_00111_0110011;      // 4    add  x7, x0, x5 
    riscv.IMEM.mem[2]  = 32'b0000000_00001_00000_000_00110_0010011;      // 8    addi x6, x0, 1  
    riscv.IMEM.mem[3]  = 32'b0000001_00110_00111_000_01000_1100011;      // 12   beq x7, x6, 40  
   
    // program for multiply replaces mul x5, x5, x6
    riscv.IMEM.mem[4]  = 32'b0000000_00000_00000_000_01000_0110011;      // 16   add x8, x0, x0  
    riscv.IMEM.mem[5]  = 32'b0000000_00000_00110_000_01001_0010011;      // 20   addi x9, x6, 0  
    riscv.IMEM.mem[6]  = 32'b0000000_01001_00000_000_10000_1100011;      // 24   beq x9, x0, 16  
    riscv.IMEM.mem[7]  = 32'b0000000_00101_01000_000_01000_0110011;      // 28   add x8, x8, x5  
    riscv.IMEM.mem[8]  = 32'b1111111_11111_01001_000_01001_0010011;      // 32   addi x9, x9, -1 
    riscv.IMEM.mem[9]  = 32'b1111111_1010_111111_111_00000_1101111;      // 36   jal x0, -12	 
    riscv.IMEM.mem[10] = 32'b0000000_01000_00000_000_00101_0110011;      // 40   add x5, x8, x0  
    
    riscv.IMEM.mem[11] = 32'b0000000_00001_00110_000_00110_0010011;      // 44   addi x6, x6, 1  
    riscv.IMEM.mem[12] = 32'b0000000_01100_00000_000_00000_1100111;      // 48   jalr x0, 12(x0) 
    riscv.IMEM.mem[13] = 32'b0000000_00101_00000_010_00111_0100011;      // 52   sw x5, 7(x0)    
    
  end

  always @(posedge clk)begin
    if(riscv.DMEM.mem[7]!=0)begin 
      @(negedge clk);
      @(negedge clk);
      $finish; 
    end
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
	#100000
    $finish;
  end
  
endmodule
