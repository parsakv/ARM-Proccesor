module EXE_Stage_Reg(clk, rst, MEM_R_EN_in, MEM_W_EN_in, WB_EN_in, Dest_in, ALU_Res_in, Val_Rm_in, MEM_R_EN_out, MEM_W_EN_out, WB_EN_out, 
                     Dest_out, ALU_Res_out, Val_Rm_out, freeze);
  input clk, rst, MEM_R_EN_in, MEM_W_EN_in, WB_EN_in, freeze;
  input[3:0] Dest_in;
  input[31:0] ALU_Res_in, Val_Rm_in;
  output reg[31:0] ALU_Res_out, Val_Rm_out;
  output reg MEM_R_EN_out, MEM_W_EN_out, WB_EN_out;
  output reg[3:0] Dest_out;
  always@(posedge clk, posedge rst)
    begin
      if(rst) begin
        ALU_Res_out <= 32'b0;
        Val_Rm_out <= 32'b0;
        Dest_out <= 4'b0;
        {MEM_R_EN_out, MEM_W_EN_out, WB_EN_out} <= 3'b0;
        end
      else if(~freeze) begin
        ALU_Res_out <= ALU_Res_in;
        Val_Rm_out <= Val_Rm_in;
        Dest_out <= Dest_in;
        {MEM_R_EN_out, MEM_W_EN_out, WB_EN_out} <= {MEM_R_EN_in, MEM_W_EN_in, WB_EN_in};
        end
    end
    
endmodule
