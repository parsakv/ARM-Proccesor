module Hazard_Detection_Unit(forward_hazard, No_src, Two_src, src1, src2, Exe_Dest, Exe_WB_EN, Mem_Dest, Mem_WB_EN,
                             hazard_Detected);
  input forward_hazard, Two_src, No_src;
  input[3:0] src1, src2, Exe_Dest, Mem_Dest;
  input Exe_WB_EN, Mem_WB_EN;
  output hazard_Detected;
  
  wire hazard;

  assign hazard =
  ((~No_src)&&((Exe_WB_EN)&&((src1==Exe_Dest)||((Two_src)&&(src2==Exe_Dest)))))?1'b1:((~No_src)&&((Mem_WB_EN)&&((src1==Mem_Dest)||((Two_src)&&(src2==Mem_Dest)))))? 1'b1: 1'b0;

  assign hazard_Detected = (~forward_hazard)? hazard: 1'b0;
  
endmodule
