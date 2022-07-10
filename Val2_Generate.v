module Val2_Generate(Val_Rm, shifter_operand, Imm, mem_RW, Val2);

input[31:0] Val_Rm;
input[11:0] shifter_operand;
input mem_RW, Imm;
output[31:0] Val2;

reg[31:0] Val_Rm_Shifted, Imm_Shifted; 
wire[31:0] offset;
wire[1:0] check;
integer shift_imm;

reg[63:0] temp1, temp2;

always@(shifter_operand,  Val_Rm, Imm, shift_imm) begin
  case(shifter_operand[11:8])
    4'b0000: Imm_Shifted = (shifter_operand[7])? {24'b111111111111111111111111,shifter_operand[7:0]}: {24'b0, shifter_operand[7:0]}; 
    4'b0001: Imm_Shifted = {shifter_operand[1:0], 24'b0, shifter_operand[7:2]};
    4'b0010: Imm_Shifted = {shifter_operand[3:0], 24'b0, shifter_operand[7:4]};
    4'b0011: Imm_Shifted = {shifter_operand[5:0], 24'b0, shifter_operand[7:6]};
    4'b0100: Imm_Shifted = {shifter_operand[7:0], 24'b0};
    4'b0101: Imm_Shifted = (shifter_operand[7])? {2'b11,shifter_operand[7:0],22'b0}: {2'b0, shifter_operand[7:0], 22'b0};
    4'b0110: Imm_Shifted = (shifter_operand[7])? {4'b1111,shifter_operand[7:0],20'b0}: {4'b0, shifter_operand[7:0], 20'b0};
    4'b0111: Imm_Shifted = (shifter_operand[7])? {6'b111111,shifter_operand[7:0],18'b0}: {6'b0, shifter_operand[7:0], 18'b0};
    4'b1000: Imm_Shifted = (shifter_operand[7])? {8'b11111111,shifter_operand[7:0],16'b0}: {8'b0, shifter_operand[7:0], 16'b0};
    4'b1001: Imm_Shifted = (shifter_operand[7])? {10'b1111111111,shifter_operand[7:0],14'b0}: {10'b0, shifter_operand[7:0], 14'b0};
    4'b1010: Imm_Shifted = (shifter_operand[7])? {12'b111111111111,shifter_operand[7:0],12'b0}: {12'b0, shifter_operand[7:0], 12'b0};
    4'b1011: Imm_Shifted = (shifter_operand[7])? {14'b11111111111111,shifter_operand[7:0],10'b0}: {14'b0, shifter_operand[7:0], 10'b0};
    4'b1100: Imm_Shifted = (shifter_operand[7])? {16'b1111111111111111,shifter_operand[7:0],8'b0}: {16'b0, shifter_operand[7:0], 8'b0};
    4'b1101: Imm_Shifted = (shifter_operand[7])? {18'b111111111111111111,shifter_operand[7:0],6'b0}: {18'b0, shifter_operand[7:0], 6'b0};
    4'b1110: Imm_Shifted = (shifter_operand[7])? {20'b11111111111111111111,shifter_operand[7:0],4'b0}: {20'b0, shifter_operand[7:0], 4'b0};
    4'b1111: Imm_Shifted = (shifter_operand[7])? {22'b1111111111111111111111,shifter_operand[7:0],2'b0}: {22'b0, shifter_operand[7:0], 2'b0};
  endcase
  case(shifter_operand[6:5])
    2'b00: begin 
            Val_Rm_Shifted = Val_Rm << shift_imm;
          end
    2'b01:begin 
            Val_Rm_Shifted = Val_Rm >> shift_imm;
          end 
    2'b10:begin 
            Val_Rm_Shifted = Val_Rm >>> shift_imm;
          end
    2'b11:begin 
            temp1 = {Val_Rm, Val_Rm};
            temp2 = temp1 >> shift_imm;
            Val_Rm_Shifted = temp2[31:0];
          end 
    default Val_Rm_Shifted = Val_Rm; 
  endcase
end

always@(shifter_operand) begin
  shift_imm = shifter_operand[11:7];
end
assign check = {mem_RW, Imm};
assign offset = (shifter_operand[11])?{20'b11111111111111111111, shifter_operand[11:0]}:{20'b0, shifter_operand[11:0]};
assign Val2 = (check == 2'b00)? Val_Rm_Shifted:(check == 2'b01)? Imm_Shifted:(check == 2'b10)? offset: (check == 2'b11)? offset: 32'b0;

endmodule