module Forwarding_Unit(forward_hazard, src1, src2, Dest_MEM, WB_MEM, Dest_WB, WB_WB, src1_sel, src2_sel);

input forward_hazard;
input[3:0] src1, src2, Dest_MEM, Dest_WB;
input WB_MEM, WB_WB;
output[1:0] src1_sel, src2_sel;

assign src1_sel = (~forward_hazard)? 2'b00: ((((WB_MEM)&&((src1==Dest_MEM))))? 2'b01: ((((WB_WB)&&((src1==Dest_WB))))? 2'b10: 2'b00));
assign src2_sel = (~forward_hazard)? 2'b00: ((((WB_MEM)&&((src2==Dest_MEM))))? 2'b01: ((((WB_WB)&&((src2==Dest_WB))))? 2'b10: 2'b00));

endmodule
