module Condition_Check(Cond, N, Z, C, V, CondCheck);
  input[3:0] Cond;
  input N, Z, C, V;
  output reg CondCheck;
  
  wire[3:0] Conditions;
  
  always@(Cond, N, Z, C, V) begin
    case(Cond)
      4'b0000: CondCheck = Conditions[0];
      4'b0001: CondCheck = ~Conditions[0]; 
      4'b0010: CondCheck = Conditions[1];
      4'b0011: CondCheck = ~Conditions[1];
      4'b0100: CondCheck = Conditions[2];
      4'b0101: CondCheck = ~Conditions[2];
      4'b0110: CondCheck = Conditions[3];
      4'b0111: CondCheck = ~Conditions[3];
      4'b1000: CondCheck = ~Conditions[0] && Conditions[1];
      4'b1001: CondCheck = Conditions[0] || ~Conditions[1];
      4'b1010: CondCheck = Conditions[2] == Conditions[3];
      4'b1011: CondCheck = Conditions[2] != Conditions[3];
      4'b1100: CondCheck = ~Conditions[0] && (Conditions[2] == Conditions[3]);
      4'b1101: CondCheck = Conditions[0] && (Conditions[2] != Conditions[3]);
      4'b1110: CondCheck = 1'b1;
      default: CondCheck = 1'b0;
    endcase
  end
  
  assign Conditions = {V, N, C, Z};
  
endmodule
       
  
  
  
  
  
