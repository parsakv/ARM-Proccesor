module MEM_Stage_Reg(clk, rst, MEM_R_EN_in, WB_EN_in, Dest_in, ALU_Res_in, Memory_Data_in, 
                     MEM_R_EN, WB_EN, Dest, ALU_Res, Memory_Data, freeze);
  input clk, rst, MEM_R_EN_in, WB_EN_in, freeze;
  input[3:0] Dest_in;
  input[31:0] ALU_Res_in, Memory_Data_in;
  output reg MEM_R_EN, WB_EN;
  output reg[3:0] Dest;
  output reg[31:0] ALU_Res, Memory_Data;
  
  always@(posedge clk, posedge rst)
    begin
      if(rst) begin
        ALU_Res <= 32'b0;
        Memory_Data <= 32'b0;
        Dest <= 4'b0;
        {MEM_R_EN, WB_EN} <= 2'b00;
        end
      else if(~freeze) begin
        ALU_Res <= ALU_Res_in;
        Memory_Data <= Memory_Data_in;
        Dest <= Dest_in;
        {MEM_R_EN, WB_EN} <= {MEM_R_EN_in, WB_EN_in};
        end
    end
    
endmodule
