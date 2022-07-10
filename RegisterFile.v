module RegisterFile(clk, rst, src1, src2, Dest_WB, Result_WB, writebackEn, reg1, reg2);
  input clk, rst;
  input[3:0] src1, src2, Dest_WB;
  input[31:0] Result_WB;
  input writebackEn;
  output[31:0] reg1, reg2;
  
  reg[31:0] REG[0:14];
  integer i;
  
  always@(negedge clk)
    if(writebackEn) REG[Dest_WB] <= Result_WB;
  
  assign reg1 = REG[src1];
  assign reg2 = REG[src2];
  
  
  initial begin
    REG[0] = 32'b0;
    for (i = 1; i < 15; i = i + 1) begin
      REG[i] = 32'b0;
    end
  end
  
endmodule