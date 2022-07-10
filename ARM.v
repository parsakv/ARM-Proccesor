module ARM(clk, rst, forward_hazard, SRAM_DQ, SRAM_Addr, SRAM_WE_N);
  input clk, rst;
  input forward_hazard;
  output SRAM_WE_N;
  output[18:0] SRAM_Addr;
  inout[31:0] SRAM_DQ;
  
  
  wire[31:0] PC_IF, Instruction_IF;
  wire[31:0] PC_IF_Reg, Instruction_IF_Reg;
  wire[31:0] PC_ID_Reg, PC_EXE_Reg, PC_MEM_Reg, PC_WB_Reg;
  wire[31:0] Val_Rn_ID, Val_Rm_ID, Val_Rn_ID_Reg, Val_Rm_ID_Reg, Val_Rm_EXE_Reg;
  wire[31:0] ALU_Res_EXE, ALU_Res_EXE_Reg, ALU_Res_MEM_Reg, Branch_Addr;
  wire WB_EN_ID, MEM_R_EN_ID, MEM_W_EN_ID, S_ID, B_ID, Imm_ID;
  wire WB_EN_ID_Reg, MEM_R_EN_ID_Reg, MEM_W_EN_ID_Reg, S_ID_Reg, B_ID_Reg, Imm_ID_Reg;
  wire MEM_R_EN_EXE_Reg, MEM_W_EN_EXE_Reg, WB_EN_EXE_Reg;
  wire MEM_R_EN_MEM_Reg, WB_EN_MEM_Reg;
  wire[3:0] Dest_ID, ALU_CMD_ID, Dest_ID_Reg, ALU_CMD_ID_Reg, Statusbits_in, Statusbits_out, Statusbits_EXE;
  wire[3:0] Dest_EXE_Reg, Dest_MEM_Reg;
  wire[11:0] shift_ID,shift_ID_Reg;
  wire[23:0] Signed_imm24_ID, Signed_imm24_ID_Reg;
  wire[31:0] Memory_Data_MEM_Reg, WB_Value, MemData, Val_Rm_forwarded, MEM_WB_Value;
  wire[3:0] Rm, Rn, Rm_Reg, Rn_Reg;
  wire Two_src, hazard, No_src, ready;
  wire[1:0] src1_sel, src2_sel;
  StatusReg Status_Reg(.clk(clk), .rst(rst), .Cond_in(Statusbits_EXE), .S(S_ID_Reg), .Cond_out(Statusbits_in));
  IF_Stage IF_stage(.clk(clk), .rst(rst), .freeze(hazard || ~ready), 
                    .Branch_taken(B_ID_Reg), .BranchAddr(Branch_Addr),
                    .PC(PC_IF), .Instruction(Instruction_IF));
  IF_Stage_Reg IF_stage_reg(.clk(clk), .rst(rst), .freeze(hazard || ~ready),
									 .flush(B_ID_Reg), .PC_in(PC_IF), .Instruction_in(Instruction_IF),
									 .PC(PC_IF_Reg), .Instruction(Instruction_IF_Reg));
  ID_Stage ID_stage (.clk(clk), .rst(rst), .hazard(hazard), .writebackEn(WB_EN_MEM_Reg), 
                     .SR(Statusbits_in), .Instruction(Instruction_IF_Reg), 
                     .Dest_wb(Dest_MEM_Reg), .Result_WB(WB_Value),
                     .Val_Rn(Val_Rn_ID), .Val_Rm(Val_Rm_ID),
                     .WB_EN(WB_EN_ID), .MEM_R_EN(MEM_R_EN_ID), .MEM_W_EN(MEM_W_EN_ID),
                     .S(S_ID), .B(B_ID), .Signed_imm_24(Signed_imm24_ID),
                     .Imm(Imm_ID), .shifter_operand(shift_ID), .Dest(Dest_ID), .ALU_CMD(ALU_CMD_ID),
                     .Two_src(Two_src), .src1(Rn), .src2(Rm), .No_src(No_src));
  ID_Stage_Reg ID_stage_reg(.clk(clk), .rst(rst), .Statusbits_in(Statusbits_in),
                            .flush(B_ID_Reg), .PC_in(PC_IF_Reg), .Val_Rn_in(Val_Rn_ID), .Val_Rm_in(Val_Rm_ID),
                            .WB_EN_in(WB_EN_ID), .MEM_R_EN_in(MEM_R_EN_ID), .MEM_W_EN_in(MEM_W_EN_ID), 
                            .S_in(S_ID), .B_in(B_ID), .Imm_in(Imm_ID), 
                            .shifter_operand_in(shift_ID), .Dest_in(Dest_ID), .ALU_CMD_in(ALU_CMD_ID), .PC(PC_ID_Reg),
                            .Val_Rm(Val_Rm_ID_Reg), .Val_Rn(Val_Rn_ID_Reg), .WB_EN(WB_EN_ID_Reg),
                            .MEM_R_EN(MEM_R_EN_ID_Reg), .MEM_W_EN(MEM_W_EN_ID_Reg), .S(S_ID_Reg), .B(B_ID_Reg), 
                            .Imm(Imm_ID_Reg), .shifter_operand(shift_ID_Reg), .Dest(Dest_ID_Reg), .ALU_CMD(ALU_CMD_ID_Reg),
                            .Statusbits_out(Statusbits_out), .Signed_imm24_in(Signed_imm24_ID),
                            .Signed_imm24_out(Signed_imm24_ID_Reg), .Rn(Rn_Reg), .Rm(Rm_Reg), .Rn_in(Rn), .Rm_in(Rm),
                            .freeze(~ready));
  EXE_Stage EXE_stage(.clk(clk), .PC_in(PC_ID_Reg), .Val1(Val_Rn_ID_Reg), 
                      .Val_Rm(Val_Rm_ID_Reg), .Signed_imm_24(Signed_imm24_ID_Reg), 
                      .shifter_operand(shift_ID_Reg), .EXE_CMD(ALU_CMD_ID_Reg), .Statusbits_in(Statusbits_out),
                      .Imm(Imm_ID_Reg),.MEM_R_EN(MEM_R_EN_ID_Reg), .MEM_W_EN(MEM_W_EN_ID_Reg), 
                      .ALU_Res(ALU_Res_EXE), .Branch_Addr(Branch_Addr), .Statusbits(Statusbits_EXE),
                      .WB_Val(WB_Value), .MEM_Val(MEM_WB_Value), .src1_sel(src1_sel), .src2_sel(src2_sel),
                      .Val_Rm_forwarded(Val_Rm_forwarded));
  EXE_Stage_Reg EXE_stage_reg(.clk(clk), .rst(rst), .MEM_R_EN_in(MEM_R_EN_ID_Reg), .MEM_W_EN_in(MEM_W_EN_ID_Reg), 
                              .WB_EN_in(WB_EN_ID_Reg), .Dest_in(Dest_ID_Reg), .ALU_Res_in(ALU_Res_EXE), 
                              .Val_Rm_in(Val_Rm_forwarded), .MEM_R_EN_out(MEM_R_EN_EXE_Reg), .MEM_W_EN_out(MEM_W_EN_EXE_Reg),
                              .WB_EN_out(WB_EN_EXE_Reg), .Dest_out(Dest_EXE_Reg), 
                              .ALU_Res_out(ALU_Res_EXE_Reg), .Val_Rm_out(Val_Rm_EXE_Reg),
                              .freeze(~ready));
  MEM_Stage MEM_stage(.clk(clk), .rst(rst), .MEM_W_EN(MEM_W_EN_EXE_Reg), .MEM_R_EN(MEM_R_EN_EXE_Reg), 
                      .ALU_Res(ALU_Res_EXE_Reg), .Val_Rm(Val_Rm_EXE_Reg), 
                      .MemData_out(MemData), .MEM_WB_Value(MEM_WB_Value), .ready(ready),
                      .SRAM_DQ(SRAM_DQ), .SRAM_Addr(SRAM_Addr), .SRAM_WE_N(SRAM_WE_N));
  MEM_Stage_Reg MEM_stage_reg(.clk(clk), .rst(rst), .MEM_R_EN_in(MEM_R_EN_EXE_Reg), .WB_EN_in(WB_EN_EXE_Reg), 
                              .Dest_in(Dest_EXE_Reg), .ALU_Res_in(ALU_Res_EXE_Reg), .Memory_Data_in(MemData), 
                              .MEM_R_EN(MEM_R_EN_MEM_Reg), .WB_EN(WB_EN_MEM_Reg), 
                              .Dest(Dest_MEM_Reg), .ALU_Res(ALU_Res_MEM_Reg),
                              .Memory_Data(Memory_Data_MEM_Reg),
                              .freeze(~ready));
  WB_Stage WB_stage(.clk(clk), .rst(rst), .ALU_Res_in(ALU_Res_MEM_Reg), .Memory_Data_in(Memory_Data_MEM_Reg), 
                    .MEM_R_EN(MEM_R_EN_MEM_Reg), .WB_Value(WB_Value));
 Hazard_Detection_Unit Hazard_Detection_Unit_inst0(.forward_hazard(forward_hazard),.Two_src(Two_src), .src1(Rn), .src2(Rm), 
                                                   .Exe_Dest(Dest_ID_Reg), .Exe_WB_EN(WB_EN_ID_Reg),
                                                   .Mem_Dest(Dest_EXE_Reg), .Mem_WB_EN(WB_EN_EXE_Reg),
                                                   .hazard_Detected(hazard),.No_src(No_src)); 
  
Forwarding_Unit Forwarding_Unit_inst0(.forward_hazard(forward_hazard), .src1(Rn_Reg), .src2(Rm_Reg), .Dest_MEM(Dest_EXE_Reg), 
                                      .WB_MEM(WB_EN_EXE_Reg), .Dest_WB(Dest_MEM_Reg), .WB_WB(WB_EN_MEM_Reg), .src1_sel(src1_sel), 
                                      .src2_sel(src2_sel));
endmodule