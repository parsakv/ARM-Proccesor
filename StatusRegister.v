module StatusReg(clk, rst, Cond_in, S, Cond_out);
  input clk, rst, S;
  input[3:0] Cond_in;
  output reg[3:0] Cond_out;
  
  always@(negedge clk, posedge rst) begin
    if(rst) Cond_out <= 4'b0;
    else begin
      if(S) Cond_out <= Cond_in;
      end
  end
endmodule