module counter_control(
input wire clk,
input wire rst_n,
input wire div_en,
input wire [3:0] div_val,
input wire halt_req,
input wire timer_en,
input wire dbg_mode,
output wire cnt_en,
output wire cnt_clr
);

// declare variable temp

reg [8:0] div_divide_reg;
reg [7:0] div_cnt;
wire cnt_rst;
wire [7:0] cnt_tmp;
wire def_mode;
wire ctrl_mode0;
wire ctrl_mode_other;
wire timer_en_d;
// logic for div_divide

always @* begin
  if (!div_en) begin
    div_divide_reg = 9'd1;
  end else begin
    case (div_val)
      4'b0000: div_divide_reg = 9'd1;
      4'b0001: div_divide_reg = 9'd2;
      4'b0010: div_divide_reg = 9'd4;
      4'b0011: div_divide_reg = 9'd8;
      4'b0100: div_divide_reg = 9'd16;
      4'b0101: div_divide_reg = 9'd32;
      4'b0110: div_divide_reg = 9'd64;
      4'b0111: div_divide_reg = 9'd128;
      4'b1000: div_divide_reg = 9'd256;
      default: div_divide_reg = 9'd1;
    endcase
  end
end

// logic for cnt_rst
assign cnt_rst = (div_cnt == (div_divide_reg - 1)) | (timer_en == 0);

//logic for cnt_tmp
assign cnt_tmp = (halt_req) ? div_cnt : (cnt_rst) ? 0 : div_cnt + 1;

//logic for div_cnt
always@(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    div_cnt <= 0;
  end else begin
    div_cnt <= cnt_tmp;
  end
end

always@(posedge clk or negedge rst_n) begin
  timer_en_d <= timer_en;
end

//logic for cnt_en
assign def_mode = timer_en & (!div_en);
assign cnt_clr = timer_en_d && (!timer_en);
assign ctrl_mode0 = timer_en & div_en & (div_val == 0);
assign ctrl_mode_other = timer_en & div_en & (div_cnt == (div_divide_reg - 1));
assign cnt_en = (halt_req) ? 0 : (def_mode) ? 1 : (ctrl_mode0) ? 1 : (ctrl_mode_other) ? 1 : 0;
endmodule






