module decoder(
    input wire [31:0] inst_data,
	output reg [6:0] opcode,
	output reg [4:0] rd,
	output reg [2:0] fun3,
	output reg [4:0] rs1,
	output reg [4:0] rs2,
	output reg [6:0] fun7,
	output reg [31:0] imm
	);
	
	// decoding logic
  always @ (*) begin
		opcode = inst_data[6:0];
		case(opcode)
		7'b0110011: begin  //------------------------------------- R-type
					rd = inst_data[11:7];
					fun3 = inst_data[14:12];
					rs1 = inst_data[19:15];
					rs2 = inst_data[24:20];
					fun7 = inst_data[31:25];
					end
		7'b0010011: begin  //------------------------------------- I-type
					rd = inst_data[11:7];
					fun3 = inst_data[14:12];
					rs1 = inst_data[19:15];
					imm = {{20{inst_data[31]}},inst_data[31:20]};
					end
		7'b0000011: begin  //------------------------------------- L-type
					rd = inst_data[11:7];
					fun3 = inst_data[14:12];
					rs1 = inst_data[19:15];
					imm = {{20{inst_data[31]}},inst_data[31:20]};
					end
		7'b0100011: begin  //------------------------------------- S-type
					fun3 = inst_data[14:12];
					rs1 = inst_data[19:15];
					rs2 = inst_data[24:20];
					imm={{20{inst_data[31]}},inst_data[31:25],inst_data[11:7]};
					end
		7'b1100011: begin  //------------------------------------- B-type
					fun3 = inst_data[14:12];
					rs1 = inst_data[19:15];
					rs2 = inst_data[24:20];
					imm={{19{inst_data[31]}},inst_data[31],inst_data[7],inst_data[30:25],inst_data[11:8],1'b0};
					end
		7'b1101111: begin  //---------------------------------------- JAL
					rd = inst_data[11:7];
                    imm={{11{inst_data[31]}},inst_data[31],inst_data[19:12],inst_data[20],inst_data[30:21],1'b0};
					end
		7'b1100111: begin  //--------------------------------------- JALR
					rd = inst_data[11:7];
					fun3 = inst_data[14:12];
					rs1 = inst_data[19:15];
					imm = {{20{inst_data[31]}},inst_data[31:20]};
					end
		7'b0110111: begin  //---------------------------------------- LUI
					rd = inst_data[11:7];
                    imm={inst_data[31:12],12'b0};
					end	
		7'b0010111: begin  //-------------------------------------- AUIPC
					rd = inst_data[11:7];
                    imm={inst_data[31:12],12'b0};
					end	
		default:    begin
					rd    = 0;
					fun3  = 0;
					rs1   = 0;
					rs2   = 0;
					fun7  = 0;
					imm = 0;
					end
		endcase
	end
	
endmodule
