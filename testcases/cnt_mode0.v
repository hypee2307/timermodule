task run_test();
  begin
//check default value
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0000, DATA_32BIT1);
    apb_rd(ADDR_TDR1, tb_rdata);
    cmp_data(ADDR_TDR1, tb_rdata, 32'h0000_0000, DATA_32BIT1);

    apb_wr(ADDR_TCR, 32'h0000_0011); //enable timer_en and div_en and write div_val = 4'b0000 (mode 0)
    repeat (5 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
    err_tb_check();
  end
endtask
