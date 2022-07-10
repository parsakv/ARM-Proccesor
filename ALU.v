module ALU(Val1, Val2, EXE_CMD, C, ALU_Res, Statusbits);
  
  input[31:0] Val1, Val2;
  input[3:0] EXE_CMD;
  input C;
  output reg[31:0] ALU_Res;
  output[3:0] Statusbits;
  
  reg[1:0] CV;
  
  
  always@(Val1, Val2, EXE_CMD, C)begin
    case(EXE_CMD)
      4'b0001: begin ALU_Res = Val2; end
      4'b1001: begin ALU_Res = ~Val2; end
      4'b0010: begin {CV[1], ALU_Res} = Val1 + Val2;
                      CV[0] = ((Val1[31] == Val2[31])&&(Val1[31] != ALU_Res[31]))? 1'b1: 1'b0;  end
      4'b0011: begin {CV[1], ALU_Res} = Val1 + Val2 + {31'b0, C};
                      CV[0] = ((Val1[31] == Val2[31])&&(Val1[31] != ALU_Res[31]))? 1'b1: 1'b0;  end
      4'b0100: begin {CV[1], ALU_Res} = Val1 - Val2;
                      CV[0] = ((Val1[31] != Val2[31])&&(Val1[31] != ALU_Res[31]))? 1'b1: 1'b0; end
      4'b0101: begin {CV[1], ALU_Res} = Val1 - Val2 - {31'b0, ~C};
                      CV[0] = ((Val1[31] != Val2[31])&&(Val1[31] != ALU_Res[31]))? 1'b1: 1'b0; end
      4'b0110: begin ALU_Res = Val1 & Val2; end
      4'b0111: begin ALU_Res = Val1 | Val2; end
      4'b1000: begin ALU_Res = Val1 ^ Val2; end
      default  begin ALU_Res = 32'b0;
                     CV = 2'b0; end
    endcase
  end
  assign Statusbits[2] = (ALU_Res == 32'b0)? 1'b1: 1'b0;
  assign Statusbits[3] = ALU_Res[31];
  assign Statusbits[1:0] = CV;
  
endmodule
  
