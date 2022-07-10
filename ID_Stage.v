module ID_Stage(clk, rst, hazard, writebackEn, SR, 
                Instruction, Dest_wb, Result_WB, Val_Rn, Val_Rm, Signed_imm_24,
                WB_EN, MEM_R_EN, MEM_W_EN, S, B, Imm, Two_src, src2, src1,
                shifter_operand, Dest, ALU_CMD, No_src);
  input clk, rst, writebackEn, hazard;
  input[31:0] Instruction, Result_WB;
  input[3:0] Dest_wb, SR;
  output[31:0] Val_Rn,Val_Rm;
  output[23:0] Signed_imm_24;
  output[3:0] Dest, ALU_CMD, src2, src1;
  output[11:0] shifter_operand;
  output Imm, WB_EN, MEM_R_EN, MEM_W_EN, S, B;
  output Two_src, No_src; 
  wire[3:0] src2_gen, ALU_CMD_in;
  wire WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, B_in, S_in, CondCheck;
  wire freeze, no_src;
  
  RegisterFile RegisterFile_inst0(.clk(clk), .rst(rst), 
                                  .src1(Instruction[19:16]), .src2(src2_gen),
                                  .Dest_WB(Dest_wb), .Result_WB(Result_WB), 
                                  .writebackEn(writebackEn), .reg1(Val_Rn), 
                                  .reg2(Val_Rm));
  
  ControlUnit ControlUnit_inst0(.Op_Code(Instruction[24:21]), 
                                .Mode(Instruction[27:26]), 
                                .Sin(Instruction[20]), .ALU_CMD(ALU_CMD_in), 
                                .WB_EN(WB_EN_in), .MEM_R_EN(MEM_R_EN_in), 
                                .MEM_W_EN(MEM_W_EN_in), .B(B_in), .S(S_in), .No_src(no_src));
  
  Condition_Check Condition_Check_inst0(.Cond(Instruction[31:28]), .N(SR[3]), 
                                        .Z(SR[2]), .C(SR[1]), 
                                        .V(SR[0]), .CondCheck(CondCheck));
 
  assign {ALU_CMD, WB_EN, MEM_R_EN, MEM_W_EN, B, S} = (~freeze)?{ALU_CMD_in, WB_EN_in, MEM_R_EN_in, MEM_W_EN_in, B_in, S_in}:9'b0;
  assign src2_gen = (MEM_W_EN)?Instruction[15:12]:Instruction[3:0];
  assign Imm = Instruction[25];
  assign shifter_operand = Instruction[11:0];
  assign Dest = Instruction[15:12];
  assign Signed_imm_24 = Instruction[23:0];
  assign Two_src = MEM_W_EN || ~Imm;
  assign src1 = Instruction[19:16];
  assign src2 = src2_gen;
  assign freeze = ~CondCheck || hazard;
  assign No_src = no_src && Instruction[25];
  
endmodule

