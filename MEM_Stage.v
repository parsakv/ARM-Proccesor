module MEM_Stage(clk, rst, MEM_W_EN, MEM_R_EN, ALU_Res, Val_Rm, MemData_out, MEM_WB_Value,
                 ready, SRAM_DQ, SRAM_Addr, SRAM_WE_N);
  input clk, rst, MEM_W_EN, MEM_R_EN;
  input[31:0] ALU_Res, Val_Rm;
  output ready;
  output[31:0] MemData_out,  MEM_WB_Value;
  output[18:0] SRAM_Addr;
  output SRAM_WE_N;
  inout[31:0] SRAM_DQ;
  
  wire sram_ready, hit;
  wire SRAM_UB_N, SRAM_LB_N, RAM_CE_N, SRAM_OE_N;
  wire[63:0] sram_rdata;
  wire[31:0] sram_wdata;
  wire[31:0] sram_address;
  wire write_en, read_en;
  
  SRAM_Controller SRAM_Controller_inst0(.clk(clk), .rst(rst), .read_en(read_en), 
                              .write_en(write_en), .address(sram_address), .writeData(sram_wdata), 
                              .readData(sram_rdata), .ready(sram_ready), .SRAM_DQ(SRAM_DQ),
                              .SRAM_Addr(SRAM_Addr),
                              .SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), 
                              .SRAM_WE_N(SRAM_WE_N), .SRAM_CE_N(SRAM_CE_N), 
                              .SRAM_OE_N(SRAM_OE_N));
  Cache_Controller Cache_Controller_inst0(.clk(clk), .rst(rst), 
                                          .address(ALU_Res), .wdata(Val_Rm), 
                                          .MEM_R_EN(MEM_R_EN), .MEM_W_EN(MEM_W_EN), 
                                          .rdata(MemData_out), .ready(ready), 
                                          .sram_address(sram_address),
                                          .sram_wdata(sram_wdata), 
                                          .write_en(write_en), .read_en(read_en) ,
                                          .sram_rdata(sram_rdata), .sram_ready(sram_ready));                      
  assign  MEM_WB_Value = (MEM_R_EN)? MemData_out: ALU_Res;
endmodule

  
  


  
