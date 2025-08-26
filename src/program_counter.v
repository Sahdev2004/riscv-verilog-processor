module program_counter (
  input clk, rst,
  input [31:0] pc_nxt,
  output reg [31:0] pc_now
);
   
  always @(posedge clk) begin
    if(rst)begin
      pc_now <= 0;
    end else begin
      pc_now <= pc_nxt;
    end
  end
  
endmodule