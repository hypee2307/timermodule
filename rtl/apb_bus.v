module apb_bus (
input wire clk,
input wire rst_n,

input wire psel,
input wire pwrite,
input wire penable,
input wire [31:0] addr,
input wire [31:0] pwdata,
output wire [31:0] prdata,
output wire pready,
output wire pslverr,

input wire [31:0] rdata,
input wire error,
output wire [11:0] reg_addr,
output wire wr_en,
output wire rd_en,
output wire [31:0] wdata
);

// declare temp variable

reg pready_reg;
reg pslverr_reg;
wire [19:0] base_addr;
// register address

assign base_addr = addr[31:12];
assign reg_addr = addr[11:0];

// write access

assign wr_en = psel & pwrite & penable & (base_addr == 20'h4_0001);
assign wdata = wr_en ? pwdata: 32'h0;

// read access
assign rd_en = psel & ~pwrite & penable & (base_addr == 20'h4_0001);
assign prdata = (rd_en) ? rdata: 32'h0;

// Ready
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    pready_reg <= 1'b0;
  end else begin
    pready_reg <= psel & penable;
  end
end

assign pready = pready_reg;

//Error
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    pslverr_reg <= 1'b0;
  end else begin
    pslverr_reg <= error;
  end
end

assign pslverr = pslverr_reg;

endmodule
