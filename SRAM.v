`timescale 1ns/1ns
module SRAM(clk, rst,SRAM_WE_N, SRAM_Addr, SRAM_DQ);
  input clk, rst, SRAM_WE_N;
  input[18:0] SRAM_Addr;
  inout[31:0] SRAM_DQ;
  
  reg[31:0] memory[0:511];
  
 always@(posedge clk)begin
    if(~SRAM_WE_N) begin
     memory[SRAM_Addr] <= SRAM_DQ;
   end
 end
  
 assign #30 SRAM_DQ = SRAM_WE_N? memory[SRAM_Addr]: 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
  
endmodule

