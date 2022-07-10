module Cache_Controller(clk, rst, address, wdata, MEM_R_EN, MEM_W_EN, rdata, ready, sram_address,
                        sram_wdata, write_en, read_en, sram_rdata, sram_ready);
  input clk, rst;
  input[31:0] address, wdata;
  input MEM_R_EN, MEM_W_EN;
  output[31:0] rdata;
  output ready;
  
  output[31:0] sram_address;
  output[31:0] sram_wdata;
  output write_en, read_en;
  input[63:0] sram_rdata;
  input sram_ready;
  
  reg[31:0] way0_1[0:63];
  reg[31:0] way0_2[0:63];
  reg[31:0] way1_1[0:63];
  reg[31:0] way1_2[0:63];
  reg[9:0] way0_tag[0:63];
  reg[9:0] way1_tag[0:63];
  reg way0_valid[0:63];
  reg way1_valid[0:63];
  reg LRU[0:63];
  

  wire[5:0] index;
  wire[9:0] addr_tag;
  wire bit_2;
  wire way0_hit, way1_hit;
  wire hit;
  wire CHECK;
  integer i;
  
  always@(negedge clk, posedge rst)begin
    if(rst) begin
      for (i = 0; i < 64; i = i + 1)begin
        {way0_1[i], way0_2[i], way0_tag[i], way0_valid[i]} <= 75'b0;
        {way1_1[i], way1_2[i], way1_tag[i], way1_valid[i], LRU[i]} <= 76'b0;
      end
    end
    else begin
      LRU[index] = (MEM_R_EN && hit)? ~way0_hit: LRU[index];
      if(sram_ready && MEM_R_EN && ~hit)begin
        if(LRU[index] == 1'b0) begin
          if(bit_2 == 1'b0) begin
            way1_1[index] = sram_rdata[63:32];
            way1_2[index] = sram_rdata[31:0];
            way1_tag[index] = addr_tag;
            way1_valid[index] = 1'b1;
          end
          else begin
            way1_2[index] = sram_rdata[63:32];
            way1_1[index] = sram_rdata[31:0];
            way1_tag[index] = addr_tag;
            way1_valid[index] = 1'b1;
          end
        end
        else begin
          if(bit_2 == 1'b0) begin
            way0_1[index] = sram_rdata[63:32];
            way0_2[index] = sram_rdata[31:0];
            way0_tag[index] = addr_tag;
            way0_valid[index] = 1'b1;
          end
          else begin
            way0_2[index] = sram_rdata[63:32];
            way0_1[index] = sram_rdata[31:0];
            way0_tag[index] = addr_tag;
            way0_valid[index] = 1'b1;
          end
        end
      end
      way0_valid[index] = (MEM_W_EN && (way0_hit))? 1'b0: way0_valid[index]; 
      way1_valid[index] = (MEM_W_EN && (way1_hit))? 1'b0: way1_valid[index];
    end     
  end
  
  assign index = address[8:3];
  assign addr_tag = address[18:9];
  assign bit_2 = address[2];
  assign way0_hit = ((way0_tag[index] == addr_tag) && way0_valid[index]);
  assign way1_hit = ((way1_tag[index] == addr_tag) && way1_valid[index]);
  assign hit = way0_hit || way1_hit;
  assign rdata = (way0_hit)?((~bit_2)? way0_1[index]: way0_2[index]):
                    (way1_hit)?((~bit_2)? way1_1[index]: way1_2[index]):
                    32'b0;
  assign sram_address = address;
  assign sram_wdata = wdata;
  assign ready = hit || sram_ready;
  assign write_en = MEM_W_EN;
  assign read_en = (hit)? 1'b0: MEM_R_EN;
endmodule