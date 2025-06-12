task run_test();
    begin
        $display ("--------------------------------------------");
        $display ("                TCR - R&W Check             ");
        $display ("--------------------------------------------");

        wrcmp (ADDR_TCR, 32'h0000_0000, ADDR_TCR, DATA_32BIT0);
        wrcmp (ADDR_TCR, 32'hFFFF_FFFF, ADDR_TCR, 32'h0000_0000); //div_val write an error value (4’b1111)=>div_val is 4’b0000 (previous div_val), not 4’b0100 (default div_val)
        wrcmp (ADDR_TCR, 32'hFFFF_F402, ADDR_TCR, 32'h0000_0402);
        wrcmp (ADDR_TCR, 32'h0000_07FE, ADDR_TCR, 32'h0000_0702);
        wrcmp (ADDR_TCR, 32'h0000_07FC, ADDR_TCR, 32'h0000_0700);

        $display ("--------------------------------------------");
        $display ("               TDR0 - R&W Check             ");
        $display ("--------------------------------------------");

        wrcmp (ADDR_TDR0, 32'h0000_0000, ADDR_TDR0, DATA_32BIT0);
        wrcmp (ADDR_TDR0, 32'hFFFF_FFFF, ADDR_TDR0, DATA_32BIT1);
        wrcmp (ADDR_TDR0, 32'h5555_5555, ADDR_TDR0, 32'h5555_5555);
        wrcmp (ADDR_TDR0, 32'hAAAA_AAAA, ADDR_TDR0, 32'hAAAA_AAAA);

        $display ("--------------------------------------------");
        $display ("               TDR1 - R&W Check             ");
        $display ("--------------------------------------------");

        wrcmp (ADDR_TDR1, 32'h0000_0000, ADDR_TDR1, DATA_32BIT0);
        wrcmp (ADDR_TDR1, 32'hFFFF_FFFF, ADDR_TDR1, DATA_32BIT1);
        wrcmp (ADDR_TDR1, 32'h5555_5555, ADDR_TDR1, 32'h5555_5555);
        wrcmp (ADDR_TDR1, 32'hAAAA_AAAA, ADDR_TDR1, 32'hAAAA_AAAA);

        $display ("--------------------------------------------");
        $display ("              TCMP0 - R&W Check             ");
        $display ("--------------------------------------------");
        wrcmp (ADDR_TCMP0, 32'h0000_0000, ADDR_TCMP0, DATA_32BIT0);
        wrcmp (ADDR_TCMP0, 32'hFFFF_FFFF, ADDR_TCMP0, DATA_32BIT1);
        wrcmp (ADDR_TCMP0, 32'h5555_5555, ADDR_TCMP0, 32'h5555_5555);
        wrcmp (ADDR_TCMP0, 32'hAAAA_AAAA, ADDR_TCMP0, 32'hAAAA_AAAA);

        $display ("--------------------------------------------");
        $display ("              TCMP1 - R&W Check             ");
        $display ("--------------------------------------------");

        wrcmp (ADDR_TCMP1, 32'h0000_0000, ADDR_TCMP1, DATA_32BIT0);
        wrcmp (ADDR_TCMP1, 32'hFFFF_FFFF, ADDR_TCMP1, DATA_32BIT1);
        wrcmp (ADDR_TCMP1, 32'h5555_5555, ADDR_TCMP1, 32'h5555_5555);
        wrcmp (ADDR_TCMP1, 32'hAAAA_AAAA, ADDR_TCMP1, 32'hAAAA_AAAA);

        $display ("--------------------------------------------");
        $display ("               TIER - R&W Check             ");
        $display ("--------------------------------------------");

        wrcmp (ADDR_TIER, 32'h0000_0000, ADDR_TIER, DATA_32BIT0);
        wrcmp (ADDR_TIER, 32'hFFFF_FFFF, ADDR_TIER, 32'h0000_0001);

        $display ("--------------------------------------------");
        $display ("               TISR - R&W Check             ");
        $display ("--------------------------------------------");

        apb_rd(ADDR_TISR, tb_rdata);
        cmp_data(ADDR_TISR, tb_rdata, 32'h1, DATA_32BIT1);  //Because TCMP0 == TDR0 == 32'hAAAA_AAAA, TCMP1 == TDR1 == 32'hAAAA_AAAA
        apb_wr(ADDR_TCMP0, 32'hABCD_ABCD);
        apb_wr(ADDR_TCMP1, 32'hABCD_ABCD);
        apb_wr(ADDR_TISR, 32'h1);
        apb_rd(ADDR_TISR, tb_rdata);
        cmp_data(ADDR_TISR, tb_rdata, 32'h0, DATA_32BIT1);
        wrcmp(ADDR_TISR, 32'h1, ADDR_TISR, DATA_32BIT0);

        $display ("--------------------------------------------");
        $display ("              THCSR - R&W Check             ");
        $display ("--------------------------------------------");

        wrcmp (ADDR_THCSR, 32'h0000_0000, ADDR_THCSR, DATA_32BIT0);
        wrcmp (ADDR_THCSR, 32'hFFFF_FFFF, ADDR_THCSR, 32'h0000_0001);
        wrcmp (ADDR_THCSR, 32'hFFFF_0000, ADDR_THCSR, DATA_32BIT0);

        $display ("--------------------------------------------");
        $display ("             W/R random address             ");
        $display ("--------------------------------------------");

        wrcmp(32'h0000_0000, 32'h1111_1111, 32'h0000_0000, 32'h0000_0000);
        wrcmp(32'hFFFF_FFFF, 32'h2222_2222, 32'hFFFF_FFFF, 32'h0000_0000);
        wrcmp(32'h1234_5678, 32'h3333_3333, 32'h1234_5678, 32'h0000_0000);
        wrcmp(32'h4000_1003, 32'h4444_4444, 32'h4000_1003, 32'h0000_0000);

        err_tb_check();
    end
endtask

