task run_test();
    begin
        //test debug HIGH and halt LOW
        apb_wr(ADDR_TCR, 32'h0000_0001); //enable timer and disable div_en
        repeat (5 - 3) @(posedge sys_clk);
        apb_rd(ADDR_TDR0, tb_rdata);
        cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
        dbg_mode = 1;
        apb_wr(ADDR_THCSR, DATA_32BIT0);
        repeat (30) @(posedge sys_clk);
        apb_rd(ADDR_TDR0, tb_rdata);
        if (tb_rdata != 32'h0000_0005) begin
            $display("Time = %10d, PASSED: Counter still work normally because halt is not activated", $time);
        end else begin
            $display("Time = %10d, FAILED: Counter value remains unchanged even though halt is not activated", $time);
            tb_err = tb_err + 1;
        end

        dbg_mode = 0;
        apb_wr(ADDR_TCR, DATA_32BIT0);

        //test debug LOW and halt HIGH
        apb_wr(ADDR_TCR, 32'h0000_0001); //enable timer and disable div_en
        repeat (5 - 3) @(posedge sys_clk);
        apb_rd(ADDR_TDR0, tb_rdata);
        cmp_data(ADDR_TDR0, tb_rdata, 32'h0000_0005, DATA_32BIT1);
        apb_wr(ADDR_THCSR, 32'h0000_00001); //requested halt
        repeat (20) @(posedge sys_clk);
        apb_rd(ADDR_TDR0, tb_rdata);
        if (tb_rdata != 32'h0000_0005) begin
            $display("Time = %10d, PASSED: Counter still work normally because halt is not activated", $time);
        end else begin
            $display("Time = %10d, FAILED: Counter value remains unchanged even though halt is not activated", $time);
            tb_err = tb_err + 1;
        end
        apb_wr(ADDR_THCSR, DATA_32BIT0);
        apb_wr(ADDR_TCR, DATA_32BIT0);

        //test debug and halt HIGH
        apb_wr(ADDR_TCR, 32'h0000_0001); //enable timer and disable div_en
        repeat (5 - 4) @(posedge sys_clk);
        dbg_mode = 1;
        apb_wr(ADDR_THCSR, 32'h0000_0001); //requested halt
        apb_rd(ADDR_TDR0, tb_rdata); //read data after activate halt, expected = 32'h0000_0005
        $display("------------------------------------");
        $display("Halt is activated");
        $display("------------------------------------");
        repeat (50) @(posedge sys_clk);
        apb_rd(ADDR_TDR0, tb_rdata); //read data after 50 cycles in halt
        if (tb_rdata == 32'h0000_0005) begin
            $display("Time = %10d, PASSED: Counter value remains unchanged because halt is activated", $time);
        end else begin
            $display("Time = %10d, FAILED: Counter value changed even though halt is activated", $time);
            tb_err = tb_err + 1;
        end

        dbg_mode = 0;
        $display("------------------------------------");
        $display("Halt is not activated");
        $display("------------------------------------");
        repeat(30) @(posedge sys_clk);
        apb_rd(ADDR_TDR0, tb_rdata);
        if (tb_rdata != 32'h0000_0005) begin
            $display("Time = %10d, PASSED: Counter still work normally because halt is not activated", $time);
        end else begin
            $display("Time = %10d, FAILED: Counter value remains unchanged even though halt is not activated", $time);
            tb_err = tb_err + 1;
        end
        err_tb_check();
    end
endtask
