module register(
input wire clk,
input wire rst_n,
input wire dbg_mode,
input wire [3:0] pstrb,
output wire int_en,
output wire int_st,

input wire [11:0] addr,
input wire wr_en,
input wire rd_en,
input wire [31:0] wdata,
output wire [31:0] rdata,
output wire error,

output wire timer_en,
output wire div_en,
output wire [3:0] div_val,
output wire halt,

input wire [31:0] count_0,
input wire [31:0] count_1,
output reg [31:0] tdr0,
output reg [31:0] tdr1,

output wire tdr0_wr_sel,
output wire tdr1_wr_sel
);

//declare address
parameter ADDR_TCR = 12'h000;
parameter ADDR_TDR0 = 12'h004;
parameter ADDR_TDR1 = 12'h008;
parameter ADDR_TCMP0 = 12'h00c;
parameter ADDR_TCMP1 = 12'h010;
parameter ADDR_TIER = 12'h014;
parameter ADDR_TISR = 12'h018;
parameter ADDR_THCSR = 12'h01c;

//declare default value
parameter DEFAULT_TCR = 32'h0000_0100;
parameter DEFAULT_TDR0 = 32'h0000_0000;
parameter DEFAULT_TDR1 = 32'h0000_0000;
parameter DEFAULT_TCMP0 = 32'hffff_ffff;
parameter DEFAULT_TCMP1 = 32'hffff_ffff;
parameter DEFAULT_TIER = 32'h0000_0000;
parameter DEFAULT_TISR = 32'h0000_0000;
parameter DEFAULT_THCSR = 32'h0000_0000;
parameter DEFAULT_RDATA = 32'h0000_0000;

//declare temp variable
reg [31:0] tcr, tcmp0, tcmp1, tier, tisr, thcsr, rdata_reg;
wire tisr_tmp;
wire [31:0] tdr0_tmp, tdr1_tmp, tcmp0_tmp, tcmp1_tmp, tcr_tmp;
reg [7:0] sel;
reg error_reg, tcr_invalid_change, div_val_prohibit;
reg timer_en_d; //timer_en delay
//address decoder

always @* begin
  case (addr)
    ADDR_TCR: sel = 8'b0000_0001;
    ADDR_TDR0: sel = 8'b0000_0010;
    ADDR_TDR1: sel = 8'b0000_0100;
    ADDR_TCMP0: sel = 8'b0000_1000;
    ADDR_TCMP1: sel = 8'b0001_0000;
    ADDR_TIER: sel = 8'b0010_0000;
    ADDR_TISR: sel = 8'b0100_0000;
    ADDR_THCSR: sel = 8'b1000_0000;
    default: sel = 8'b0000_0000;
  endcase
end

//error detect

always @* begin
    div_val_prohibit = pstrb[1] & wdata[11] & (wdata[8] | wdata[9] | wdata[10]);
    tcr_invalid_change = tcr[0] & (pstrb[1] & (wdata[11:8] != tcr[11:8]) | (pstrb[0] & wdata[1] != tcr[1]));
      if (wr_en & sel[0]) begin
        error_reg = div_val_prohibit | tcr_invalid_change;
      end else begin
        error_reg = 1'b0;
      end
end

// TCR - write access
assign tcr_tmp[11:8] = (wr_en & sel[0] & ~error_reg & pstrb[1]) ? wdata[11:8] : tcr[11:8];
assign tcr_tmp[1:0] = (wr_en & sel[0] & ~error_reg & pstrb[0]) ? wdata[1:0] : tcr[1:0];
assign tcr_tmp[31:12] = 20'h0;
assign tcr_tmp[7:2] = 6'b0;
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    tcr <= DEFAULT_TCR;
  end else if (wr_en & sel[0]) begin
    tcr <= tcr_tmp;
  end else begin
    tcr <= tcr;
  end
end

// TDR0 - write access
assign tdr0_tmp[7:0] = !(wr_en & sel[1]) ? count_0[7:0] : (pstrb[0]) ? wdata[7:0] : tdr0[7:0];
assign tdr0_tmp[15:8] = !(wr_en & sel[1]) ? count_0[15:8] : (pstrb[1]) ? wdata[15:8] : tdr0[15:8];
assign tdr0_tmp[23:16] = !(wr_en & sel[1]) ? count_0[23:16] : (pstrb[2]) ? wdata[23:16] : tdr0[23:16];
assign tdr0_tmp[31:24] = !(wr_en & sel[1]) ? count_0[31:24] : (pstrb[3]) ? wdata[31:24] : tdr0[31:24];
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    tdr0 <= DEFAULT_TDR0;
  end else if ((timer_en_d == 1) && (tcr[0] == 0)) begin
    tdr0 <= DEFAULT_TDR0;
  end else begin
    tdr0 <= tdr0_tmp;
  end
    timer_en_d <= tcr[0];
end

// TDR1 - write access
assign tdr1_tmp[7:0] = !(wr_en & sel[2]) ? count_1[7:0] : (pstrb[0]) ? wdata[7:0] : tdr1[7:0];
assign tdr1_tmp[15:8] = !(wr_en & sel[2]) ? count_1[15:8] : (pstrb[1]) ? wdata[15:8] : tdr1[15:8];
assign tdr1_tmp[23:16] = !(wr_en & sel[2]) ? count_1[23:16] : (pstrb[2]) ? wdata[23:16] : tdr1[23:16];
assign tdr1_tmp[31:24] = !(wr_en & sel[2]) ? count_1[31:24] : (pstrb[3]) ? wdata[31:24] : tdr1[31:24];
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    tdr1 <= DEFAULT_TDR1;
  end else if ((timer_en_d == 1) && (tcr[0] == 0)) begin
    tdr1 <= DEFAULT_TDR1;
  end else begin
    tdr1 <= tdr1_tmp;
  end
    timer_en_d <= tcr[0];
end

//TCMP0 - write access
assign tcmp0_tmp[7:0] = (wr_en & sel[3] & pstrb[0]) ? wdata[7:0] : tcmp0[7:0];
assign tcmp0_tmp[15:8] = (wr_en & sel[3] & pstrb[1]) ? wdata[15:8] : tcmp0[15:8];
assign tcmp0_tmp[23:16] = (wr_en & sel[3] & pstrb[2]) ? wdata[23:16] : tcmp0[23:16];
assign tcmp0_tmp[31:24] = (wr_en & sel[3] & pstrb[3]) ? wdata[31:24] : tcmp0[31:24];
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    tcmp0 <= DEFAULT_TCMP0;
  end else begin
    tcmp0 <= tcmp0_tmp;
  end
end

assign tcmp1_tmp[7:0] = (wr_en & sel[4] & pstrb[0]) ? wdata[7:0] : tcmp1[7:0];
assign tcmp1_tmp[15:8] = (wr_en & sel[4] & pstrb[1]) ? wdata[15:8] : tcmp1[15:8];
assign tcmp1_tmp[23:16] = (wr_en & sel[4] & pstrb[2]) ? wdata[23:16] : tcmp1[23:16];
assign tcmp1_tmp[31:24] = (wr_en & sel[4] & pstrb[3]) ? wdata[31:24] : tcmp1[31:24];
//TCMP1 - write access
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    tcmp1 <= DEFAULT_TCMP1;
  end else begin
    tcmp1 <= tcmp1_tmp;
  end
end

// TIER - write access

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    tier <= DEFAULT_TIER;
  end else if (wr_en & sel[5] & pstrb[0]) begin
    tier <= wdata[0];
  end else begin
    tier <= tier;
  end
end

// TISR
assign tisr_tmp = (wr_en & sel[6] & wdata[0] & pstrb[0]) ? 0 : tisr[0];
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    tisr <= DEFAULT_TISR;
  end else if ((count_0 == tcmp0) && (count_1 == tcmp1)) begin
    tisr[0] <= 1'b1;
  end else begin
    tisr[0] <= tisr_tmp;
  end
end

//THCSR

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    thcsr <= DEFAULT_THCSR;
  end else if (wr_en & sel[7] & pstrb[0]) begin
    thcsr[0] <= wdata[0];
    thcsr[1] <= wdata[0] & dbg_mode;
  end else if (!dbg_mode) begin
    thcsr[1] = 0;
  end else begin
    thcsr <= thcsr;
  end
end

always @* begin
  if (rd_en) begin
    case (sel)
      8'b0000_0001: rdata_reg = tcr;
      8'b0000_0010: rdata_reg = tdr0;
      8'b0000_0100: rdata_reg = tdr1;
      8'b0000_1000: rdata_reg = tcmp0;
      8'b0001_0000: rdata_reg = tcmp1;
      8'b0010_0000: rdata_reg = tier;
      8'b0100_0000: rdata_reg = tisr;
      8'b1000_0000: rdata_reg = thcsr;
      default: rdata_reg = DEFAULT_RDATA;
    endcase
  end else begin
    rdata_reg = DEFAULT_RDATA;
  end
end

//assign data

assign rdata = rdata_reg;
assign error = error_reg;
assign timer_en = tcr[0];
assign div_en = tcr[1];
assign div_val = tcr[11:8];
assign halt = thcsr[1];
assign int_en = tier[0];
assign int_st = tisr[0];
assign tdr0_wr_sel = wr_en & sel[1];
assign tdr1_wr_sel = wr_en & sel[2];
endmodule















