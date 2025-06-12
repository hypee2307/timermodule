task run_test();
    begin
        //TCR Register Check
        //Default check
        apb_rd(ADDR_TCR, tb_rdata);
        cmp_data(ADDR_TCR, tb_rdata, 32'h0000_0100, DATA_32BIT1);

        wrcmp_byte(ADDR_TCR, 32'hffff_f5ff, 4'b0010, 32'h0000_0500);
        wrcmp_byte(ADDR_TCR, 32'hffff_f5ff, 4'b0001, 32'h0000_0503);

        wrcmp_byte(ADDR_TCR, 32'hffff_f0ff, 4'b0100, 32'h0000_0503);
        wrcmp_byte(ADDR_TCR, 32'hffff_f0ff, 4'b1000, 32'h0000_0503);

        wrcmp_byte(ADDR_TCR, 32'h2, 4'b0001, 32'h0000_0502); //clear timer_en
        wrcmp_byte(ADDR_TCR, 32'h0, 4'b0011, 32'h0000_0000); //clear all

        wrcmp_byte(ADDR_TCR, 32'hffff_f6f3, 4'b0011, 32'h0000_0603);

        wrcmp_byte(ADDR_TCR, 32'hffff_0000, 4'b1010, 32'h0000_0603);

        wrcmp_byte(ADDR_TCR, 32'h2, 4'b0001, 32'h0000_0602); //clear timer_en
        wrcmp_byte(ADDR_TCR, 32'h0, 4'b0011, 32'h0000_0000); //clear all

        //TDR0 Register Check
        //Default check
        apb_rd(ADDR_TDR0, tb_rdata);
        cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0000, DATA_32BIT1);

        wrcmp_byte(ADDR_TDR0, 32'h1111_1111, 4'b0001, 32'h0000_0011);
        wrcmp_byte(ADDR_TDR0, 32'h2222_2222, 4'b0010, 32'h0000_2211);
        wrcmp_byte (ADDR_TDR0, 32'h3333_3333, 4'b0100, 32'h0033_2211);
        wrcmp_byte (ADDR_TDR0, 32'h4444_4444, 4'b1000, 32'h4433_2211);
        wrcmp_byte (ADDR_TDR0, 32'h5555_5555, 4'b0011, 32'h4433_5555);
        wrcmp_byte (ADDR_TDR0, 32'h6666_6666, 4'b1100, 32'h6666_5555);

        //TDR1 Register Check
        //Default check
        apb_rd(ADDR_TDR1, tb_rdata);
        cmp_data(ADDR_TDR1, tb_rdata, 32'h0000_0000, DATA_32BIT1);
      
        wrcmp_byte(ADDR_TDR1, 32'h1111_1111, 4'b0001, 32'h0000_0011);
        wrcmp_byte(ADDR_TDR1, 32'h2222_2222, 4'b0010, 32'h0000_2211);
        wrcmp_byte(ADDR_TDR1, 32'h3333_3333, 4'b0100, 32'h0033_2211);
        wrcmp_byte(ADDR_TDR1, 32'h4444_4444, 4'b1000, 32'h4433_2211);
        wrcmp_byte(ADDR_TDR1, 32'h5555_5555, 4'b0011, 32'h4433_5555);
        wrcmp_byte(ADDR_TDR1, 32'h6666_6666, 4'b1100, 32'h6666_5555);

        //TCMPO Register Check
        //Default check
        apb_rd(ADDR_TCMP0, tb_rdata);
        cmp_data(ADDR_TCMP0, tb_rdata, DATA_32BIT1, DATA_32BIT1);
      
        wrcmp_byte(ADDR_TCMP0, 32'h9999_9999, 4'b0001, 32'hFFFF_FF99);
        wrcmp_byte(ADDR_TCMP0, 32'h8888_8888, 4'b0010, 32'hFFFF_8899);
        wrcmp_byte(ADDR_TCMP0, 32'h7777_7777, 4'b0100, 32'hFF77_8899);
        wrcmp_byte(ADDR_TCMP0, 32'h6666_6666, 4'b1000, 32'h6677_8899);
        wrcmp_byte(ADDR_TCMP0, 32'hAAAA_AAAA, 4'b0011, 32'h6677_AAAA);
        wrcmp_byte(ADDR_TCMP0, 32'hBBBB_BBBB, 4'b1100, 32'hBBBB_AAAA);

        //TCMP1 Register Check
        //Default check
        apb_rd(ADDR_TCMP1, tb_rdata);
        cmp_data(ADDR_TCMP1, tb_rdata, DATA_32BIT1, DATA_32BIT1);
      
        wrcmp_byte(ADDR_TCMP1, 32'h9999_9999, 4'b0001, 32'hFFFF_FF99);
        wrcmp_byte(ADDR_TCMP1, 32'h8888_8888, 4'b0010, 32'hFFFF_8899);
        wrcmp_byte(ADDR_TCMP1, 32'h7777_7777, 4'b0100, 32'hFF77_8899);
        wrcmp_byte(ADDR_TCMP1, 32'h6666_6666, 4'b1000, 32'h6677_8899);
        wrcmp_byte(ADDR_TCMP1, 32'hAAAA_AAAA, 4'b0011, 32'h6677_AAAA);
        wrcmp_byte(ADDR_TCMP1, 32'hBBBB_BBBB, 4'b1100, 32'hBBBB_AAAA);

        //TIER Register Check
        wrcmp_byte(ADDR_TIER, 32'h1111_1111, 4'b0001, 32'h1);
        wrcmp_byte(ADDR_TIER, 32'h2222_2222, 4'b0010, 32'h1);
        wrcmp_byte(ADDR_TIER, 32'h3333_3333, 4'b0100, 32'h1);
        wrcmp_byte(ADDR_TIER, 32'h4444_4444, 4'b1000, 32'h1);
        wrcmp_byte(ADDR_TIER, 32'h0000_0000, 4'b0011, 32'h0);
        wrcmp_byte(ADDR_TIER, 32'hFFFF_FFFF, 4'b1100, 32'h0);

        //TISR Register Check
        //Default check
        apb_rd(ADDR_TISR, tb_rdata);
        cmp_data(ADDR_TISR, tb_rdata, DATA_32BIT0, DATA_32BIT1);

        //TCMP != TDR Cases
        wrcmp_byte(ADDR_TISR, 32'h1111_1111, 4'b0001, 32'h0);
        wrcmp_byte(ADDR_TISR, 32'h2222_2222, 4'b0010, 32'h0);
        wrcmp_byte(ADDR_TISR, 32'h3333_3333, 4'b0100, 32'h0);
        wrcmp_byte(ADDR_TISR, 32'h4444_4444, 4'b1000, 32'h0);
        wrcmp_byte(ADDR_TISR, 32'h0000_0000, 4'b0011, 32'h0);
        wrcmp_byte(ADDR_TISR, 32'hFFFF_FFFF, 4'b1100, 32'h0);

        //TCMP == TDR Cases
        tim_pstrb = 4'b1111;
        apb_wr(ADDR_TIER, 32'h1);
        apb_wr(ADDR_TDR0, 32'h1);
        apb_wr(ADDR_TDR1, 32'h1);
        apb_wr(ADDR_TCMP0, 32'h1);
        apb_wr(ADDR_TCMP1, 32'h1);

        wrcmp_byte(ADDR_TISR, 32'h2222_2222, 4'b0001, 32'h1);
        wrcmp_byte(ADDR_TISR, 32'h1111_1111, 4'b0010, 32'h1);
        wrcmp_byte(ADDR_TISR, 32'h3333_3333, 4'b0100, 32'h1);
        wrcmp_byte(ADDR_TISR, 32'h4444_4444, 4'b1000, 32'h1);
        wrcmp_byte(ADDR_TISR, 32'h0000_0000, 4'b0011, 32'h1);
        wrcmp_byte(ADDR_TISR, 32'hFFFF_FFFF, 4'b1100, 32'h1);

        //THCSR Register Check
        wrcmp_byte(ADDR_THCSR, 32'h1111_1111, 4'b0001, 32'h1);
        wrcmp_byte(ADDR_THCSR, 32'h2222_2222, 4'b0010, 32'h1);
        wrcmp_byte(ADDR_THCSR, 32'h3333_3333, 4'b0100, 32'h1);
        wrcmp_byte(ADDR_THCSR, 32'h4444_4444, 4'b1000, 32'h1);
        wrcmp_byte(ADDR_THCSR, 32'h0000_0000, 4'b0011, 32'h0);
        wrcmp_byte(ADDR_THCSR, 32'hFFFF_FFFF, 4'b1100, 32'h0);
        err_tb_check();
end
endtask
