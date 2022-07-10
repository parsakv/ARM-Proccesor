module ControlUnit(Op_Code, Mode, Sin, ALU_CMD, WB_EN, MEM_R_EN, MEM_W_EN, B, S, No_src);
  input[3:0] Op_Code;
  input[1:0] Mode;
  input Sin;
  output reg[3:0] ALU_CMD;
  output reg WB_EN, MEM_R_EN, MEM_W_EN, S;
  output B, No_src;
  
  reg no_src;
  
  wire Sout;
  
   always@(Mode, Op_Code, Sin)begin
        case(Op_Code)
          4'b1101: begin ALU_CMD = 4'b0001; WB_EN = 1'b1; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = Sout; no_src = 1'b1; end
          4'b1111: begin ALU_CMD = 4'b1001; WB_EN = 1'b1; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = Sout; no_src = 1'b1; end
          4'b0100: begin ALU_CMD = 4'b0010; WB_EN = (Mode == 2'b00)?1'b1:((Sin)?1'b1:1'b0);
                         MEM_W_EN = (Mode == 2'b00)?1'b0:((Sin)?1'b0:1'b1);
                         MEM_R_EN = (Mode == 2'b00)?1'b0:((Sin)?1'b1:1'b0);
                         S = Sout; no_src = 1'b0; end
          4'b0101: begin ALU_CMD = 4'b0011; WB_EN = 1'b1; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = Sout; no_src = 1'b0; end
          4'b0010: begin ALU_CMD = 4'b0100; WB_EN = 1'b1; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = Sout; no_src = 1'b0; end
          4'b0110: begin ALU_CMD = 4'b0101; WB_EN = 1'b1; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = Sout; no_src = 1'b0; end
          4'b0000: begin ALU_CMD = 4'b0110; WB_EN = 1'b1; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = Sout; no_src = 1'b0; end
          4'b1100: begin ALU_CMD = 4'b0111; WB_EN = 1'b1; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = Sout; no_src = 1'b0; end
          4'b0001: begin ALU_CMD = 4'b1000; WB_EN = 1'b1; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = Sout; no_src = 1'b0; end
          4'b1010: begin ALU_CMD = 4'b0100; WB_EN = 1'b0; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = 1'b1; no_src = 1'b0; end
          4'b1000: begin ALU_CMD = 4'b0110; WB_EN = 1'b0; MEM_R_EN = 1'b0;
                         MEM_W_EN = 1'b0; S = 1'b1; no_src = 1'b0; end
          default {ALU_CMD, WB_EN, MEM_R_EN, MEM_W_EN, S, no_src} = 9'b0;  
        endcase
  end
  
  assign Sout = Sin;
  assign B = (Mode == 2'b10)? 1'b1: 1'b0;
  assign No_src = (Mode == 2'b10)? 1'b1: no_src;
endmodule