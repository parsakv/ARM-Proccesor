module ID_Stage_Reg(clk, rst, Rn_in, Rm_in, Statusbits_in, flush, PC_in, Val_Rn_in, Val_Rm_in, Signed_imm24_in,
                    WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, S_in, B_in, Imm_in, 
                    shifter_operand_in, Dest_in, ALU_CMD_in, 
                    PC, Val_Rm, Val_Rn, Signed_imm24_out, WB_EN, MEM_R_EN, MEM_W_EN, S, B, Imm,
                    shifter_operand, Dest, ALU_CMD, Statusbits_out, Rn, Rm, freeze);
  input clk, rst, flush, freeze;
  input[3:0] Statusbits_in, Rm_in, Rn_in;
  input[31:0] PC_in;
  input[31:0] Val_Rn_in,Val_Rm_in;
  input[23:0] Signed_imm24_in;
  input[3:0] Dest_in, ALU_CMD_in;
  input[11:0] shifter_operand_in;
  input Imm_in, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, S_in, B_in;
  output reg[31:0] PC;
  output reg[31:0] Val_Rn,Val_Rm;
  output reg[23:0] Signed_imm24_out;
  output reg[3:0] Dest, ALU_CMD, Statusbits_out, Rn, Rm;
  output reg[11:0] shifter_operand;
  output reg Imm, WB_EN, MEM_R_EN, MEM_W_EN, S, B;
  
  
  
  always@(posedge clk, posedge rst)
    begin
      if(rst) begin
        PC <= 32'b0;
        {Val_Rn,Val_Rm} <= 64'b0;
        Dest <= 4'b0;
        ALU_CMD <= 4'b0;
        shifter_operand <= 12'b0;
        {Imm, WB_EN, MEM_R_EN, MEM_W_EN, S, B} <= 6'b0;
        Statusbits_out <= 4'b0;
        Signed_imm24_out <= 24'b0;
        Rn <= 4'b0;
        Rm <= 4'b0;
      end
      else if(flush) begin
        PC <= 32'b0;
        {Val_Rn,Val_Rm} <= 64'b0;
        Dest <= 4'b0;
        ALU_CMD <= 4'b0;
        shifter_operand <= 12'b0;
        {Imm, WB_EN, MEM_R_EN, MEM_W_EN, S, B} <= 6'b0;
        Statusbits_out <= 4'b0;
        Signed_imm24_out <= 24'b0;
        Rn <= 4'b0;
        Rm <= 4'b0;
      end
      else if(~freeze) begin
        PC <= PC_in;
        {Val_Rn,Val_Rm} <= {Val_Rn_in,Val_Rm_in};
        Dest <= Dest_in;
        ALU_CMD <= ALU_CMD_in;
        shifter_operand <= shifter_operand_in;
        {Imm, WB_EN, MEM_R_EN, MEM_W_EN, S, B} <= {Imm_in, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, S_in, B_in};
        Statusbits_out <= Statusbits_in;
        Signed_imm24_out <= Signed_imm24_in;
        Rn <= Rn_in;
        Rm <= Rm_in;
        end
    end
    
endmodule
