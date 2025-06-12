task run_test();
  begin
    apb_wr(ADDR_TCR, 32'h0000_0001); //enable timer_en
    repeat (100 - 3) @(posedge sys_clk); //delay some sys_clk
    apb_rd(ADDR_TDR0, tb_rdata);
    apb_wr(ADDR_TCR, 32'h0000_0000); //disable timer_en
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0000, DATA_32BIT1);
    err_tb_check();
  end
endtask
