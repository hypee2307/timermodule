module counter(
input wire clk,
input wire rst_n,
input wire cnt_en,
input wire cnt_clr,
input wire tdr0_wr_sel,
input wire tdr1_wr_sel,
input wire [63:0] tdr,
output reg [63:0] cnt
);

// counter + 1 logic
always@(posedge clk or negedge rst_n) begin
  if(!rst_n || cnt_clr) begin
    cnt <= 1'b0;
  end else if (cnt_en && (!tdr0_wr_sel) && (!tdr1_wr_sel)) begin
    cnt <= cnt + 1;
  end else begin
    cnt <= cnt;
  end
end

// load tdr logic
always @* begin
  if (tdr0_wr_sel) begin
    cnt[31:0] <= tdr[31:0];
  end else if (tdr1_wr_sel) begin
    cnt[63:32] <= tdr[63:32];
  end else begin
    cnt <= cnt;
  end
end

endmodule
