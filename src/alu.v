module risc_alu (
    input wire [31:0] data1,
    input wire [31:0] data2,
    input wire [ 3:0] opert,
    output reg [31:0] result
    );

    always @(*) begin
        case(opert)
            // R-type I-type
            4'b0000 : result = $signed(data1) + $signed(data2);                   // ADD
            4'b0001 : result = $signed(data1) - $signed(data2);                   // SUB
            4'b0010 : result = data1  ^  data2;                                   // XOR
            4'b0011 : result = data1  |  data2;                                   // OR
            4'b0100 : result = data1  &  data2;                                   // AND
            4'b0101 : result = data1  << data2[4:0];                              // LEFT SHIFT
            4'b0110 : result = data1 >>  data2[4:0];                              // RIGHT SHIFT
            4'b0111 : result = $signed(data1) >>> data2[4:0];                     // ARITH RIGHT SHIFT
            // R-type I-type B-type
            4'b1000 : result = ($signed(data1) < $signed(data2)) ? 32'd1 : 32'd0; // LESS THAN SIGNED
            4'b1001 : result = (data1  <  data2) ? 32'd1 : 32'd0;                 // LESS THAN UNSIGNED
            // B-type
            4'b1010 : result = ($signed(data1) >= $signed(data2)) ? 32'd1 : 32'd0;// GREATER OR EQUAL SIGNED
            4'b1011 : result = (data1  >= data2) ? 32'd1 : 32'd0;                 // GREATER OR EQUAL UNSIGNED
          
            //4'b1100 : result = $signed(data1) * $signed(data2);                  // MUL -- 4 fact. program test
            //default : result = 32'd0;
        endcase
    end
    
endmodule
