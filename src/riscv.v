`include "mem.v"
`include "alu.v"
`include "control.v"
`include "decoder.v"
`include "registers.v"
`include "program_counter.v"


module processor (
  input clk,
  input rst
);

  // Program Counter
  wire [31:0] pc_now;
  wire [31:0] pc_nxt;

  program_counter PC (
    .clk(clk),
    .rst(rst),
    .pc_nxt(pc_nxt),
    .pc_now(pc_now)
  );

  // Instruction path
  wire [31:0] inst_addr;   // from control_unit
  wire [31:0] inst_data;   // to decoder

  // Instruction Memory (read-only usage)
  memory IMEM (
    .addr(inst_addr),
    .data_in(32'b0),
    .rd_en(1'b1),
    .wr_en(1'b0),
    .clk(clk),
    .rst(rst),
    .data_out(inst_data)
  );

  // Decoder
  wire [6:0]  opcode;
  wire [4:0]  rd;
  wire [2:0]  fun3;
  wire [4:0]  rs1;
  wire [4:0]  rs2;
  wire [6:0]  fun7;
  wire [31:0] imm;

  decoder DEC (
    .inst_data(inst_data),
    .opcode(opcode),
    .rd(rd),
    .fun3(fun3),
    .rs1(rs1),
    .rs2(rs2),
    .fun7(fun7),
    .imm(imm)
  );

  // Register File
  wire [4:0]  rs1_addr;
  wire [4:0]  rs2_addr;
  wire [4:0]  rd_addr;
  wire [31:0] rs1_data;
  wire [31:0] rs2_data;
  wire [31:0] rd_data;
  wire        reg_wr;

  registers REGFILE (
    .clk(clk),
    .rst(rst),
    .wr_en(reg_wr),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr),
    .rd_data(rd_data),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
  );
  
  // ALU
  wire [31:0] data1;
  wire [31:0] data2;
  wire [3:0]  opert;
  wire [31:0] result;

  risc_alu ALU (
    .data1(data1),
    .data2(data2),
    .opert(opert),
    .result(result)
  );

  // Data Memory
  wire [31:0] data_addr;
  wire [31:0] data_in;
  wire [31:0] data_out;
  wire        mem_wr;
  wire        data_rd;

  memory DMEM (
    .addr(data_addr),
    .data_in(data_in),
    .rd_en(data_rd),
    .wr_en(mem_wr),
    .clk(clk),
    .rst(rst),
    .data_out(data_out)
  );

  // Control Unit
  control_unit CTRL (
    // from decoder
    .opcode(opcode),
    .rd(rd),
    .fun3(fun3),
    .rs1(rs1),
    .rs2(rs2),
    .fun7(fun7),
    .imm(imm),

    
    // from alu
    .result(result),

    // from registers
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),

    // from data memory
    .data_out(data_out),

    // from program counter
    .pc_now(pc_now),

    // to alu
    .opert(opert),
    .data1(data1),
    .data2(data2),

    // to registers
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr),
    .rd_data(rd_data),
    .reg_wr(reg_wr),

    // to data memory
    .mem_wr(mem_wr),
    .data_rd(data_rd),
    .data_addr(data_addr),
    .data_in(data_in),

    // to inst memory
    .inst_addr(inst_addr),

    // to program counter
    .pc_nxt(pc_nxt)
  );

endmodule
