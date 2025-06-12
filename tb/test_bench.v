module test_bench
reg sys_clk, sys_rst_n;
reg dbg_mode, tim_psel, tim_pwrite;
reg tim_penable;
reg [31:0] tim_paddr;
reg [31:0] tim_pwdata;
reg [31:0] tim_pstrb;
wire [31:0] tim_prdata;
wire tim_pready, tim_pslverr, tim_int;

integer tb_err;
reg [31:0] tb_rdata;
parameter DATA_32BIT0 = 32'h0000_0000;
parameter DATA_32BIT1 = 32'hFFFF_FFFF;
parameter ADDR_TCR = 32'h4000_1000;
parameter ADDR_TDRO = 32'h4000_1004;
parameter ADDR_TDR1 = 32'h4000_1008;
parameter ADDR_TCMP0 = 32'h4000_100C;
parameter ADDR_TCMP1 = 32'h4000_1010;
parameter ADDR_TIER = 32'h4000_1014;
parameter ADDR_TISR = 32'h4000_1018;
parameter ADDR_THCSR = 32'h4000_101C;

timer_top dut(.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.dbg_mode(dbg_mode),
.tim_psel(tim_psel),
.tim_pwrite(tim_pwrite),
.tim_penable(tim_penable),
.tim_paddr(tim_paddr),
.tim_pwdata(tim_pwdata),
.tim_pstrb(tim_pstrb),
.tim_prdata(tim_prdata),
.tim_pready(tim_pready),
.tim_pslverr(tim_pslverr),
.tim_int(tim_int)
             );
`include "run_test.v"
initial begin
    sys_clk = 0;
    forever #2.5 sys_clk = ~sys_clk;
end

initial begin
    tim_paddr = 0;
    tim_pwdata = 0;
    tim_psel = 0;
    tim_pwrite = 0;
    tim_penable = 0;
    tim_pstrb = 4'b1111;
    dbg_mode = 0;
    tb_err = 0;
    sys_rst_n = 0;
    #50;
    sys_rst_n = 1;
end

task control_swe;
    input [1:0] sel_swe;
      begin
        if (sel_swe == 2'b00) begin //write_enable
        tim_pwrite = 1'b1;
        tim_psel = 1'b1;
        @(posedge sys_clk);
        #1;
        tim_penable = 1'b1;
        end else if (sel_swe == 2'b11) begin //read_enable
        tim_pwrite = 1'b0;
        tim_psel   = 1'b1;
        @(posedge sys_clk);
        #1;
        tim_penable = 1'b1;
        end else begin                                   //clear value
        @(posedge sys_clk);
        #1;
        tim_pwrite  = 1'b0;
        tim_psel    = 1'b0;
        tim_penable = 1'b0;
        end
      end
endtask

task apb_wr;
  input [31:0] in_addr;
  input [31:0] in_wdata;
    begin
      $display("Time = %d, Write data = %x at address %x", $time, in_wdata, in_addr);
      @(posedge sys_clk);
      #1;
      tim_paddr = in_addr;
      tim_pwdata = in_wdata;
      control_swe(2'b00);
      wait (tim_pready == 1);
      control_swe(2'b01);
      tim_paddr = 0;
      tim_pwdata = 0;
    end
endtask

task apb_rd;
  input [31:0] in_addr;
  output [31:0] out_rdata;
    begin
      @(posedge sys_clk);
      #1;
      tim_paddr = in_addr;
      control_swe(2'b11);
      wait (tim_pready == 1);
      #1;
      out_rdata = tim_prdata;
      control_swe(2'b01);
      tim_paddr = 0;
      tim_pwdata = 0;
      $display("Time = %d, Read data = %x at address %x", $time, out_rdata, in_addr);
    end
endtask

task cmp_data;
  input [31:0] in_addr;
  input [31:0] in_data;
  input [31:0] exp_data;
  input [31:0] mask;
    if ((in_data & mask) !== (exp_data & mask) ) begin
      $display("------------------------------------------------------------------");
      $display("t = %10d FAIL: rdata at addr %x is not correct.", $time, in_addr);
      $display("Exp: %x, Actual: %x",exp_data & mask, in_data & mask);
      $display("------------------------------------------------------------------");
      tb_err = tb_err + 1;
      #100;
      $finish;
    end
    end else begin
    $display("------------------------------------------------------------------");
    $display("t = %10d PASS: rdata = %x at addr %x is correct.", $time, in_data, in_addr);
    $display("------------------------------------------------------------------");
    end
  endtask

  task wrcmp;
    input [31:0] in_addr_w;
    input [31:0] in_wdata;
    input [31:0] in_addr_r;
    input [31:0] exp_data;
      begin
        apb_wr(in_addr_w, in_wdata);
        apb_rd(in_addr_r, tb_rdata);
        cmp_data(in_addr_r, tb_rdata, exp_data, DATA_32BIT1);
      end
  endtask
  task wrcmp_byte;
    input [31:0] in_addr;
    input [31:0] in_wdata;
    input [3:0] in_pstrb;
    input [31:0] exp_data;
      begin
        tim_pstrb = in_pstrb;
        $display ("Data write with pstrb = %x", in_pstrb);
        apb_wr(in_addr, in_wdata);
        apb_rd(in_addr, tb_rdata);
        cmp_data(in_addr, tb_rdata, exp_data, DATA_32BIT1);
      end
  endtask

task err_tb_check;
  begin
    if (!tb_err) begin
      $display ("------------------------------------------------------------------");
      $display ("---------------- ALL TEST PASSED -------------------------------");
      $display ("------------------------------------------------------------------");
    end else begin
      $display ("------------------------------------------------------------------");
      $display ("---------------- TEST FAILED -----------------------------------");
      $display ("------------------------------------------------------------------");
    end
endtask

task err_check;
  begin
    @(posedge sys_clk);
    if (tim_pslverr == 1) begin
      $display("PASSED: Error Detected");
    end else begin
      $display("FAILED: Error not detected");
      tb_err = tb_err + 1;
    end
  end
endtask
    
task cmp_tim_int;
  input sel_cmp;
    begin
      if (sel_cmp) begin
        if (tim_int == 1) begin
          $display("t = %10d, PASSED: Interrupt can be asserted",$time);
        end else begin
          $display("t = %10d, FAILED: Interrupt not asserted",$time);
          tb_err = tb_err + 1;
        end
      end else begin
        if (tim_int == 0) begin
          $display("t = %10d, PASSED: Interrupt not assert",$time);
        end else begin
          $display ("t = %10d, FAILED: Interrupt assert",$time);
          tb_err = tb_err + 1;
        end
      end
    end
endtask

initial begin
#100;
run_test();

#100;
$finish;
end
endmodule
