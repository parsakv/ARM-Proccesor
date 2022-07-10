`timescale 1ns/1ns
module SRAM_Controller(clk, rst, write_en, read_en, address, writeData, readData, ready,
                       SRAM_DQ, SRAM_Addr, SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N,
                       SRAM_OE_N);
  input clk, rst, write_en, read_en;
  input[31:0] address, writeData;
  output[63:0] readData;
  output ready;
  inout[31:0] SRAM_DQ;
  output[18:0] SRAM_Addr;
  output SRAM_UB_N, SRAM_LB_N, SRAM_WE_N, SRAM_CE_N, SRAM_OE_N;
  
  wire[31:0] addr_tmp;
  wire Ready;
  reg[2:0] counter;
  reg[31:0] rdata_up, rdata_down;
  
  always@(posedge clk, posedge rst) begin
    if(rst) begin
      counter = 3'b0;
      {rdata_up, rdata_down} = 64'b0;
    end
    else begin
      if(Ready) counter = 3'b0;
      else if(write_en || read_en) counter = counter + 1;
      if(counter == 3'b010 && read_en) rdata_up = SRAM_DQ;
      else if(counter == 3'b100 && read_en) rdata_down = SRAM_DQ;
    end
  end
  
  assign Ready = (counter == 3'b110);
  assign ready = ~(write_en || read_en) || Ready;
  assign addr_tmp = (address - 32'd1024)>>2;
  assign SRAM_Addr = (read_en && (counter > 3'b001))? addr_tmp[18:0] + 32'd1: addr_tmp[18:0];
  assign readData = (read_en)? {rdata_up, rdata_down}: 64'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
  assign SRAM_DQ = (write_en)? writeData: 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
  assign SRAM_WE_N = (write_en)? 1'b0: ((read_en)? 1'b1: 1'b1);
  assign {SRAM_UB_N, SRAM_LB_N, SRAM_CE_N, SRAM_OE_N} = 4'b0;

endmodule