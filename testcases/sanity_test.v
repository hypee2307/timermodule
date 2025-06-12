task run_test();
    begin
        $display ("-----------------------------------------");
        $display ("------       Sanity Test         --------");
        $display ("-----------------------------------------");

        sys_rst_n = 0;
        #50 sys_rst_n = 1;
        //Step 1: Write and read on TDR0 Register
        apb_wr(ADDR_TDR0, 32'hFFFF_FFFF);
        apb_rd(ADDR_TDR0, tb_rdata);
        cmp_data(ADDR_TDR0, tb_rdata, 32'hFFFF_FFFF, DATA_32BIT);

        //Step 2: Enable Interrupt
        apb_wr(ADDR_TIER, 32'h0000_0001);
        apb_wr(ADDR_TDR0, 32'h0000_0000);
        //Step 3: Start Timer
        apb_wr(ADDR_TCMP0, 32'h0000_0064); //64 in hex = 100 in dec
        apb_wr(ADDR_TCMP1, 32'h0);
        apb_wr(ADDR_TCR, 32'h0000_0001);
        //Step 4: Check if interrupt can be asserted
        repeat (100 - 3) @(posedge sys_clk);
        apb_rd(ADDR_TDR0, tb_rdata);

        cmp_tim_int(1);
        err_tb_check();
    end
endtask
