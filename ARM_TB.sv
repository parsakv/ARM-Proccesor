`timescale 1ns/1ns
module ARM_TB();
  reg clk_50, clk_25, rst, forward_hazard;
  wire[31:0] SRAM_DQ;
  reg[18:0] SRAM_Addr;
  reg SRAM_WE_N;

  ARM UUT (.clk(clk_50), .rst(rst), .forward_hazard(forward_hazard),
           .SRAM_WE_N(SRAM_WE_N), .SRAM_Addr(SRAM_Addr), .SRAM_DQ(SRAM_DQ));
  SRAM SRAM_inst0(.clk(clk_25), .rst(rst), .SRAM_WE_N(SRAM_WE_N), .SRAM_Addr(SRAM_Addr), 
                  .SRAM_DQ(SRAM_DQ));
  
  initial begin
	clk_25 = 1'b0;
  clk_50 = 1'b0;
	forward_hazard = 1'b1;
  end
  
  always #10 clk_50 = ~clk_50;
  always #20 clk_25 = ~clk_25;

  initial begin 
	 rst = 1'b1; 
   #15;
   rst = 1'b0;
   #30000;
   $stop;
  end  
  
endmodule     