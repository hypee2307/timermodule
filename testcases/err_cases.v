task run_test();
    begin
        $display("----------------------------------------------");
        $display("*------ Error - Div_val invalid value check ---*");
        $display("----------------------------------------------");

        apb_wr(ADDR_TCR, 32'h0000_0900);
        err_check();
      
        sys_rst_n = 0;
        @(posedge sys_clk);
        sys_rst_n = 1;
        apb_wr(ADDR_TCR, 32'h0000_0A00);
        err_check();

        sys_rst_n = 0;
        @(posedge sys_clk);
        sys_rst_n = 1;
        apb_wr(ADDR_TCR, 32'h0000_0B00);
        err_check();

        sys_rst_n = 0;
        @(posedge sys_clk);
        sys_rst_n = 1;
        apb_wr(ADDR_TCR, 32'h0000_0C00);
        err_check();

        sys_rst_n = 0;
        @(posedge sys_clk);
        sys_rst_n = 1;
        apb_wr(ADDR_TCR, 32'h0000_0D00);
        err_check();

        sys_rst_n = 0;
        @(posedge sys_clk);
        sys_rst_n = 1;
        apb_wr(ADDR_TCR, 32'h0000_0E00);
        err_check();

        sys_rst_n = 0;
        @(posedge sys_clk);
        sys_rst_n = 1;
        apb_wr(ADDR_TCR, 32'h0000_0F00);
        err_check();

        $display("----------------------------------------------");
        $display("*Error - Div_val change when timer_en HIGH check*");
        $display("----------------------------------------------");

        apb_wr(ADDR_TCR, 32'h0000_0001);
        apb_wr(ADDR_TCR, 32'h0000_0101);
        err_check();

        $display("----------------------------------------------");
        $display("*Error - Div_en change when timer_en HIGH check*");
        $display("----------------------------------------------");

        apb_wr(ADDR_TCR, 32'h0000_0001);
        apb_wr(ADDR_TCR, 32'h0000_0002);
        err_check();

    err_tb_check();
end
endtask

