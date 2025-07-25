task run_test();
    begin
        //Write TCMP value
        apb_wr(ADDR_TCMP0, 32'h0000_00C8); //200 in decimal
        apb_wr(ADDR_TCMP1, 32'h0000_0000);
        apb_wr(ADDR_TIER, 32'h0000_0001); //enable timer_interrupt
        apb_wr(ADDR_TCR, 32'h0000_0001); //enable counter and disable div_en

        repeat (200 - 3) @(posedge sys_clk); //delay until counter reach 5 in decimal
        apb_rd(ADDR_TDR0, tb_rdata);
        cmp_tim_int(1);

        err_tb_check();
    end
endtask
