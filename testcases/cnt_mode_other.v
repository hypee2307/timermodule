task run_test();
  begin
  //check default value
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0000, DATA_32BIT1);
    apb_rd(ADDR_TDR1, tb_rdata);
    cmp_data(ADDR_TDR1, tb_rdata, 32'h0000_0000, DATA_32BIT1);

    apb_wr(ADDR_TCR, 32'h0000_0001); //enable counter and disable div_en
    repeat (5 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0000); //disable timer_en to reset counter, must keep the value of div_val and div_en to avoid

    apb_wr(ADDR_TCR, 32'h0000_0003); //enable timer_en and div_en and write div_val = 4'b0000
    repeat (5 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0002); //disable timer_en to reset counter, must keep the value of div_val and div_en to avoid

    apb_wr(ADDR_TCR, 32'h0000_0103); //enable timer_en and div_en and write div_val = 4'b0001
    repeat (5*2 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0102); //disable timer_en to reset counter, must keep the value of div_val and div_en to avoid/

    apb_wr(ADDR_TCR, 32'h0000_0203); //enable timer_en and div_en and write div_val = 4'b0010
    repeat (5*4 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0202); //disable timer_en to reset counter, must keep the value of div_val and div_en to avoid

    apb_wr(ADDR_TCR, 32'h0000_0303); //enable timer_en and div_en and write div_val = 4'b0011
    repeat (5*8 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0302); //disable timer_en to reset counter, must keep the value of div_val and div_en to avoid error
    
    apb_wr(ADDR_TCR, 32'h0000_0403); //enable timer en and div en and write div_val = 4'b0100
    repeat(5*16 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0402); //disable timer_en to reset counter, must keep the value of div_val and div_en to avoid error
    
    apb_wr(ADDR_TCR, 32'h0000_0503); //enable timer en and div en and write div_val = 4’b0101
    repeat (5*32 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0502); //disable timer en to reset counter, must keep the value of div_val and div_en to avoid error

    apb_wr(ADDR_TCR, 32'h0000_0603); //enable timer en and div en and write div_val = 4’b0110
    repeat (5*64 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0602); //disable timer en to reset counter, must keep the value of div_val and div_en to avoid error

    apb_wr(ADDR_TCR, 32'h0000_0703); //enable timer en and div en and write div_val = 4’b0111
    repeat (5*128 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0702); //disable timer en to reset counter, must keep the value of div_val and div_en to avoid error

    apb_wr(ADDR_TCR, 32'h0000_0803); //enable timer en and div en and write div_val = 4’b1000
    repeat (5*256 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
    apb_wr(ADDR_TCR, 32'h0000_0802); //disable timer en to reset counter, must keep the value of div_val and div_en to avoid error

    apb_wr(ADDR_TCR, 32'h0000_0003); //enable timer en and div en and write div_val = 4’b0000
    repeat (5 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
    apb_rd(ADDR_TDR0, tb_rdata);
    cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);

    err_tb_check();
  end

endtask


