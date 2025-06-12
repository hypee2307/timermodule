task run_test();
    begin
        //check default value
        apb_rd(ADDR_TCR, tb_rdata);
        cmp_data(ADDR_TCR, tb_rdata, 32'h0000_0100, DATA_32BIT1);
      
        apb_rd(ADDR_TIER, tb_rdata);
        cmp_data(ADDR_TIER, tb_rdata, 32'h0000_0000, DATA_32BIT1);
      
        apb_rd(ADDR_TDR0, tb_rdata);
        cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0000, DATA_32BIT1);
      
        apb_rd(ADDR_TDR1, tb_rdata);
        cmp_data(ADDR_TDR1, tb_rdata, 32'h0000_0000, DATA_32BIT1);
      
        apb_rd(ADDR_TCMP0, tb_rdata);
        cmp_data(ADDR_TCMP0, tb_rdata, DATA_32BIT1, DATA_32BIT1);
      
        apb_rd(ADDR_TCMP1, tb_rdata);
        cmp_data(ADDR_TCMP1, tb_rdata, DATA_32BIT1, DATA_32BIT1);

        apb_wr(ADDR_TCR, 32'h0000_0001); //enable counter
        repeat (200 - 3) @(posedge sys_clk); //delay until counter reach 200 in decimal
        apb_rd(ADDR_TDR0, tb_rdata);
        cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_00c8, DATA_32BIT1);

        err_tb_check();
    end
endtask
