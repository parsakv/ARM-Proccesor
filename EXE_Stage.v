module EXE_Stage(clk, PC_in, WB_Val, MEM_Val, Val1, Val_Rm, Signed_imm_24, shifter_operand, EXE_CMD, Statusbits_in, Imm,
                 MEM_R_EN, MEM_W_EN, src1_sel, src2_sel, ALU_Res, Branch_Addr, Statusbits, Val_Rm_forwarded);
                 
  input clk, Imm, MEM_R_EN, MEM_W_EN;
  input[31:0] PC_in, Val1, Val_Rm, WB_Val, MEM_Val;
  input[23:0] Signed_imm_24;
  input[11:0] shifter_operand;
  input[3:0] EXE_CMD, Statusbits_in;
  input[1:0] src1_sel, src2_sel;
  output[31:0] ALU_Res, Branch_Addr, Val_Rm_forwarded;
  output[3:0] Statusbits;
  
  wire[31:0] Val2, Signed_imm_32, Val1_forwarded, Val_Rm_forward;
  wire mem_RW;

  ALU ALU_inst0(.Val1(Val1_forwarded), .Val2(Val2), .EXE_CMD(EXE_CMD), .C(Statusbits_in[1]), .ALU_Res(ALU_Res), 
                .Statusbits(Statusbits));
  Val2_Generate Val2_Generate_inst0(.Val_Rm(Val_Rm_forward), .shifter_operand(shifter_operand),
                                    .Imm(Imm), .mem_RW(mem_RW), .Val2(Val2));
                                      
  assign mem_RW = MEM_R_EN | MEM_W_EN;
  assign Signed_imm_32 = (Signed_imm_24[23])?{8'b11111111, Signed_imm_24}: {8'b0, Signed_imm_24};
  assign Branch_Addr = (Signed_imm_32 << 2) + PC_in;
  assign Val1_forwarded = (src1_sel == 2'b00)? Val1: ((src1_sel == 2'b01)? MEM_Val: ((src1_sel == 2'b10)? WB_Val: 32'b0));
  assign Val_Rm_forward = (src2_sel == 2'b00)? Val_Rm: ((src2_sel == 2'b01)? MEM_Val: ((src2_sel == 2'b10)? WB_Val: 32'b0));
  assign Val_Rm_forwarded = Val_Rm_forward;
endmodule
