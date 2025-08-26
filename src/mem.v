module memory (
  input [31:0] addr,
  input [31:0] data_in,
  input rd_en, wr_en, clk, rst,
  output reg [31:0] data_out
);
  reg [31:0] mem[255:0];
  integer i;
  
  always@(*)begin
          if (rd_en)
            data_out <= mem[addr[7:0]];
          else data_out <=0;
  end
  
  always @(posedge clk) begin
    if (rst && wr_en) begin
      for (i=0;i<256;i=i+1)
        mem[i] <= 32'b0;
    end else begin
      if (wr_en)
        mem[addr[7:0]] <= data_in;
    end
  end

endmodule

