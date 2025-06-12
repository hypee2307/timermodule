task run_test();
    begin
        $display("-----------------------------------------");
        $display("*           Default Value Check          *");
        $display("-----------------------------------------");

        //check TCR
        apb_rd(ADDR_TCR, tb_rdata);
        cmp_data(ADDR_TCR, tb_rdata, 32'h0000_0100, DATA_32BIT1);

        //check TDR0
        apb_rd(ADDR_TDR0, tb_rdata);
        cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0000, DATA_32BIT1);

        //check TDR1
        apb_rd(ADDR_TDR1, tb_rdata);
        cmp_data(ADDR_TDR1, tb_rdata, 32'h0000_0000, DATA_32BIT1);

        //check TCMP0
        apb_rd(ADDR_TCMP0, tb_rdata);
        cmp_data(ADDR_TCMP0, tb_rdata, DATA_32BIT1, DATA_32BIT1);

        //check TCMP1
        apb_rd(ADDR_TCMP1, tb_rdata);
        cmp_data(ADDR_TCMP1, tb_rdata, DATA_32BIT1, DATA_32BIT1);

        //check TIER
        apb_rd(ADDR_TIER, tb_rdata);
        cmp_data(ADDR_TIER, tb_rdata, 32'h0000_0000, DATA_32BIT1);

        //check TISR
        apb_rd(ADDR_TISR, tb_rdata);
        cmp_data(ADDR_TISR, tb_rdata, 32'h0000_0000, DATA_32BIT1);

        //check THCSR
        apb_rd(ADDR_THCSR, tb_rdata);
        cmp_data(ADDR_THCSR, tb_rdata, 32'h0000_0000, DATA_32BIT1);

        err_tb_check();
    end
endtask
