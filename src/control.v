module control_unit(
    // from decoder
    input wire [6:0] opcode,
    input wire [4:0] rd,
    input wire [2:0] fun3,
    input wire [4:0] rs1,
    input wire [4:0] rs2,
    input wire [6:0] fun7,
    input wire [31:0] imm,

    // from alu
    input wire [31:0] result,
  
    // from registers
    input wire [31:0] rs1_data,
    input wire [31:0] rs2_data,
  
    // from data memory
    input wire [31:0] data_out,
  
    // from program counter
  	input wire [31:0] pc_now,

    // to alu
    output reg [3:0] opert,
    output reg [31:0] data1,
    output reg [31:0] data2,

    // to registers
    output [4:0] rs1_addr,
    output [4:0] rs2_addr,
    output [4:0] rd_addr,
    output reg [31:0] rd_data,
    output reg reg_wr,

    // to data memory
    output reg mem_wr,data_rd,
    output reg [31:0] data_addr,
    output reg [31:0] data_in,

    // to inst memory
    output wire [31:0] inst_addr, // Assuming instruction memory is addressed by PC
  
    // to program counter
    output reg [31:0] pc_nxt
);
	reg branch;
  
    assign rs1_addr = rs1;
    assign rs2_addr = rs2;
  	assign rd_addr = rd;
    assign inst_addr = pc_now>>2; // Assuming instruction fetch uses current PC
  
  always @(*) begin
    // Default values
    data1    = 0;
    data2    = 0;
    opert    = 4'b1111;
    reg_wr   = 0;
    mem_wr   = 0;
    rd_data  = 0;
    data_addr = 0;
    data_in   = 0;
    branch   = 0;
    data_rd = 0;
    
    case (opcode)
        7'b0110011: begin //--------------------- R-type
            data1 = rs1_data;
            data2 = rs2_data;
            case ({fun3, fun7})
                10'b000_0000000: opert = 4'b0000; // ADD
              	//10'b000_0000001: opert = 4'b1100; // MUL
                10'b000_0100000: opert = 4'b0001; // SUB
                10'b100_0000000: opert = 4'b0010; // XOR
                10'b110_0000000: opert = 4'b0011; // OR
                10'b111_0000000: opert = 4'b0100; // AND
                10'b001_0000000: opert = 4'b0101; // SLL
                10'b101_0000000: opert = 4'b0110; // SRL
                10'b101_0100000: opert = 4'b0111; // SRA
                10'b010_0000000: opert = 4'b1000; // SLT
                10'b011_0000000: opert = 4'b1001; // SLTU
                default: opert = 4'b1111;
            endcase
            reg_wr = 1;
          	rd_data = (rd != 5'd0)?result:5'd0;
          	pc_nxt = pc_now + 4;
        end

        7'b0010011: begin //-------------------- I-type
            data1 = rs1_data;
            data2 = imm;
            case (fun3)
                3'b000: opert = 4'b0000; // ADDI
                3'b100: opert = 4'b0010; // XORI
                3'b110: opert = 4'b0011; // ORI
                3'b111: opert = 4'b0100; // ANDI
                3'b001: opert = 4'b0101; // SLLI
                3'b101: opert = (imm[11:5] != 7'h20) ? 4'b0110 : 4'b0111; // SRLI/SRAI
                3'b010: opert = 4'b1000; // SLTI
                3'b011: opert = 4'b1001; // SLTIU
                default: opert = 4'b1111;
            endcase
            reg_wr = 1;
            rd_data = (rd != 5'd0)?result:5'd0;
         	pc_nxt = pc_now + 4;
        end

        7'b0000011: begin //--------------------- Load
            data1 = rs1_data;
            data2 = imm;
            opert = 4'b0000;
            data_addr = result;
            data_rd = 1;
            reg_wr = 1;
            case (fun3)
                3'b000: rd_data = {{24{data_out[7]}}, data_out[7:0]};  // LB
                3'b001: rd_data = {{16{data_out[15]}}, data_out[15:0]}; // LH
                3'b010: rd_data = data_out;                             // LW
                3'b100: rd_data = {24'b0, data_out[7:0]};               // LBU
                3'b101: rd_data = {16'b0, data_out[15:0]};              // LHU
                default: rd_data = 0;
            endcase
          	pc_nxt = pc_now + 4;
        end

        7'b0100011: begin //-------------------- Store
            data1 = rs1_data;
            data2 = imm;
            opert = 4'b0000;
            data_addr = result;
            mem_wr = 1;
            case (fun3)
                3'b000: data_in = rs2_data[7:0];   // SB
                3'b001: data_in = rs2_data[15:0];  // SH
                3'b010: data_in = rs2_data;        // SW
                default: data_in = 0;
            endcase
          	pc_nxt = pc_now + 4;
        end

        7'b1100011: begin //------------------- Branch
            data1 = rs1_data;
            data2 = rs2_data;
            case (fun3)
                3'b000: begin opert = 4'b0001; branch = (result == 0); end // BEQ
                3'b001: begin opert = 4'b0001; branch = (result != 0); end // BNE
                3'b100: begin opert = 4'b1000; branch = (result == 1); end // BLT
                3'b101: begin opert = 4'b1010; branch = (result == 1); end // BGE
                3'b110: begin opert = 4'b1001; branch = (result == 1); end // BLTU
                3'b111: begin opert = 4'b1011; branch = (result == 1); end // BGEU
                default: opert = 4'b1111;
            endcase
          	pc_nxt = (branch) ? (pc_now + imm) : (pc_now + 4);
        end

        7'b1101111: begin //------------------- JAL
            rd_data = (rd!=0) ? pc_now + 4 : 32'b0;
            reg_wr = 1;
            pc_nxt = pc_now + imm;
        end

        7'b1100111: begin //------------------- JALR
            rd_data = (rd!=0) ? pc_now + 4 : 32'b0;
            data1 = rs1_data;
            data2 = imm;
            opert = 4'b0000;
            reg_wr = 1;
          	pc_nxt = result;
        end

        7'b0110111: begin //------------------- LUI
            rd_data = (rd != 5'd0)?imm << 12:5'd0;
            reg_wr = 1;
          	pc_nxt = pc_now + 4;
        end

        7'b0010111: begin //------------------- AUIPC
            data1 = pc_now;
			data2 = imm << 12;
			opert = 4'b0000;
			rd_data = (rd != 5'd0)?result:5'd0;
            reg_wr = 1;
          	pc_nxt = pc_now + 4;
        end

        default: begin
            // other default assignments are above
          	pc_nxt = pc_now + 4;
        end
    endcase
end

endmodule
