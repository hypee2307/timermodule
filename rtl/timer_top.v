module timer_top (
input wire sys_clk,
input wire sys_rst_n,
input wire dbg_mode,
input wire tim_psel,
input wire tim_pwrite,
input wire tim_penable,
input wire [31:0] tim_paddr,
input wire [31:0] tim_pwdata,
input wire [3:0] tim_pstrb,
output wire [31:0] tim_prdata,
output wire tim_pready,
output wire tim_pslverr,
output wire tim_int
);
wire wr_en;
wire rd_en;
wire [31:0] wdata;
wire [11:0] reg_addr;
wire error;
wire int_en;
wire int_st;
wire [31:0] count_0;
wire [31:0] count_1;
wire [63:0] count;
wire [31:0] rdata;
wire timer_en;
wire div_en;
wire [3:0] div_val;
wire [31:0] tdr0;
wire [31:0] tdr1;
wire [63:0] tdr;
wire cnt_en;
wire cnt_clr;
wire tdr0_sel;
wire tdr1_sel;
wire halt;
//assign tmp variable
assign count_0 = count[31:0];
assign count_1 = count[63:32];
assign tdr[31:0] = tdr0;
assign tdr[63:32] = tdr1;
interrupt u_interrupt ( .clk(sys_clk),
.rst_n(sys_rst_n),
.int_en(int_en),
.int_st(int_st),
.tim_int(tim_int)
);
counter_control u_cnt_ctrl ( .clk(sys_clk),
.rst_n(sys_rst_n),
.div_en(div_en),
.div_val(div_val),
.halt_req(halt),
.timer_en(timer_en),
.dbg_mode(dbg_mode),
.cnt_en(cnt_en),
.cnt_clr(cnt_clr)
);
counter u_cnt ( .clk(sys_clk),
.rst_n(sys_rst_n),
.cnt_en(cnt_en),
.cnt_clr(cnt_clr),
.tdr0_wr_sel(tdr0_sel),
.tdr1_wr_sel(tdr1_sel),
.tdr(tdr),
.cnt(count)
);
register u_reg ( .clk(sys_clk),
.rst_n(sys_rst_n),
.dbg_mode(dbg_mode),
.addr(reg_addr),
.wr_en(wr_en),
.rd_en(rd_en),
.wdata(wdata),
.pstrb(tim_pstrb),
.count_0(count_0),
.count_1(count_1),
.int_en(int_en),
.int_st(int_st),
.rdata(rdata),
.error(error),
.timer_en(timer_en),
.div_en(div_en),
.div_val(div_val),
.halt(halt),
.tdr0(tdr0),
.tdr1(tdr1),
.tdr0_wr_sel(tdr0_sel),
.tdr1_wr_sel(tdr1_sel)
);

apb_bus u_apb ( .clk(sys_clk),
.rst_n(sys_rst_n),
.psel(tim_psel),
.pwrite(tim_pwrite),
.penable(tim_penable),
.addr(tim_paddr),
.pwdata(tim_pwdata),
.rdata(rdata),
.error(error),
.prdata(tim_prdata),
.pready(tim_pready),
.pslverr(tim_pslverr),
.reg_addr(reg_addr),
.wr_en(wr_en),
.rd_en(rd_en),
.wdata(wdata)
);
endmodule














