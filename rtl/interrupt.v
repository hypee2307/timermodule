module interrupt (
input wire rst_n,
input wire clk,
input wire int_en, // connect to bit int_en from TIER register
input wire int_st, // connect to bit int_st from TISR register
output wire tim_int
);

//declare temp variable

assign tim_int = (int_en) ? int_st : (!int_en) ? 0 : 0;
endmodule
