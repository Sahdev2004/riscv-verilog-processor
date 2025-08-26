module registers(
	input wire clk, rst, wr_en,
	input wire [4:0] rs1_addr,
	input wire [4:0] rs2_addr,
	input wire [4:0] rd_addr,
	input wire [31:0] rd_data,
	
	output [31:0] rs1_data,
	output [31:0] rs2_data
	);
	
	// registers
	reg [31:0] register [31:0];
  
	// read
	assign rs1_data = register[rs1_addr];
	assign rs2_data = register[rs2_addr];
	
	// write
  always @(posedge clk) begin
		if(rst)begin
            for(int i=0;i<32;i=i+1)begin
				register[i]=0;
			end
		end
    else if(wr_en) begin
        register[rd_addr] = rd_data;
		end
	end
	
endmodule
