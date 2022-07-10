module WB_Stage(clk, rst, ALU_Res_in, Memory_Data_in, MEM_R_EN, WB_Value);
  input clk, rst, MEM_R_EN;
  input[31:0] ALU_Res_in, Memory_Data_in;
  output[31:0] WB_Value;
  
  assign WB_Value = (MEM_R_EN)? Memory_Data_in: ALU_Res_in;
endmodule
