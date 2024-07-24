/*
instruction field
   ------------------------------------
    size    field       field name
   ------------------------------------
    3       [2:0]       opcode
    1       [3]         pop_prev_dep
    1       [4]         pop_next_dep
    1       [5]         push_prev_dep
    1       [6]         push_next_dep
    1       [7]         reset_reg
    13      [20:8]      uop_bgn
    14      [34:21]     uop_end
    14      [48:35]     iter_out
    14      [62:49]     iter_in
    11      [73:63]     dst_factor_out
    11      [84:74]     dst_factor_in
    11      [95:85]     src_factor_out
    11      [106:96]    src_factor_in
    10      [116:107]   wgt_factor_out
    10      [126:117]   wgt_factor_in
    1       [127]       *unused
   ------------------------------------
      
micro-op field
   ---------------------------------------
    size    field       field name
   ---------------------------------------
    11      [10:0]      accumulator index
    11      [21:11]     input index
    10      [31:22]     weight index
   ---------------------------------------
*/

module tb_gemm ();

parameter UOP_WIDTH     = 32
        , UPC_WIDTH     = 13
        , INS_WIDTH     = 128
        , INP_WIDTH     = 8
        , WGT_WIDTH     = 8
        , ACC_WIDTH     = 32
        , ACC_MEM_WIDTH = ACC_WIDTH*16
        , INP_MEM_WIDTH = INP_WIDTH*16
        , WGT_MEM_WIDTH = WGT_WIDTH*16*16
        , ACC_IDX_WIDTH = 12
        , INP_IDX_WIDTH = 12
        , WGT_IDX_WIDTH = 11
        , ACC_MEM_WREN  = 64
        , OUT_MEM_WREN  = 32;

///////////////////////////////////////////
reg clk, rst, en;
reg [INS_WIDTH-1:0] insn;
//---------------------------------------//
wire [UOP_WIDTH-1:0] uop;
wire [UPC_WIDTH-1:0] upc;
//---------------------------------------//
wire [ACC_MEM_WIDTH-1:0] acc_mem_rd_data;
wire [ACC_IDX_WIDTH-1:0] acc_mem_rd_addr;
//---------------------------------------//
wire [ACC_MEM_WIDTH-1:0] acc_mem_wr_data;
wire [ACC_IDX_WIDTH-1:0] acc_mem_wr_addr;
wire                     acc_mem_wr_we;
//---------------------------------------//
wire [INP_MEM_WIDTH-1:0] inp_mem_rd_data;
wire [INP_IDX_WIDTH-1:0] inp_mem_rd_addr;
//---------------------------------------//
wire [WGT_MEM_WIDTH-1:0] wgt_mem_rd_data;
wire [WGT_IDX_WIDTH-1:0] wgt_mem_rd_addr;
//---------------------------------------//
wire [INP_MEM_WIDTH-1:0] out_mem_wr_data;
wire [ACC_IDX_WIDTH-1:0] out_mem_wr_addr;
wire [OUT_MEM_WREN-1:0]  out_mem_wr_we;
///////////////////////////////////////////

gemm dut (
  .clk (clk),
  .rst (~rst),
  .insn(insn),
  .uop (uop),
  .upc (upc),
  .acc_mem_rd_data(acc_mem_rd_data),
  .acc_mem_rd_addr(acc_mem_rd_addr),
  .acc_mem_wr_data(acc_mem_wr_data),
  .acc_mem_wr_addr(acc_mem_wr_addr),
  .acc_mem_wr_we  (acc_mem_wr_we),
  .inp_mem_rd_data(inp_mem_rd_data),
  .inp_mem_rd_addr(inp_mem_rd_addr),
  .wgt_mem_rd_data(wgt_mem_rd_data),
  .wgt_mem_rd_addr(wgt_mem_rd_addr),
  .out_mem_wr_data(out_mem_wr_data),
  .out_mem_wr_addr(out_mem_wr_addr),
  .out_mem_wr_we  (out_mem_wr_we)
);

uop_mem uop_mem (
  .clka     (clk),              // input wire clka
  .rsta     (rst),              // input wire rsta
  .ena      (en),               // input wire ena
  .wea      (),                 // input wire [3 : 0] wea
  .addra    (upc),              // input wire [31 : 0] addra
  .dina     (),                 // input wire [31 : 0] dina
  .douta    (uop),              // output wire [31 : 0] douta
  .rsta_busy()                  //output wire rsta_busy
);

acc_mem acc_mem (
  .clka     (clk),              // input wire clka
  .rsta     (rst),              // input wire rsta
  .ena      (en),               // input wire ena
  .wea      (),                 // input wire [63 : 0] wea
  .addra    (acc_mem_rd_addr),  // input wire [31 : 0] addra
  .dina     (),                 // input wire [511 : 0] dina
  .douta    (acc_mem_rd_data),  // output wire [511 : 0] douta
  
  .clkb     (clk),              // input wire clkb
  .rstb     (rst),              // input wire rstb
  .enb      (en),               // input wire enb
  .web      (acc_mem_wr_we),    // input wire [63 : 0] web
  .addrb    (acc_mem_wr_addr),  // input wire [31 : 0] addrb
  .dinb     (acc_mem_wr_data),  // input wire [511 : 0] dinb
  .doutb    (),                 // output wire [511 : 0] doutb
  .rsta_busy(),                 // output wire rsta_busy
  .rstb_busy()                  // output wire rstb_busy
);

inp_mem inp_mem (
  .clka     (clk),              // input wire clka
  .rsta     (rst),              // input wire rsta
  .ena      (en),               // input wire ena
  .wea      (),                 // input wire [15 : 0] wea
  .addra    ({20'b0, inp_mem_rd_addr}),  // input wire [31 : 0] addra
  .dina     (),                 // input wire [127 : 0] dina
  .douta    (inp_mem_rd_data),  // output wire [127 : 0] douta
  .rsta_busy()                  // output wire rsta_busy
);

wgt_mem wgt_mem_0 (
  .clka     (clk),              // input wire clka
  .rsta     (rst),              // input wire rsta
  .ena      (en),               // input wire ena
  .wea      (),                 // input wire [127 : 0] wea
  .addra    ({21'b0, wgt_mem_rd_addr}),  // input wire [31 : 0] addra
  .dina     (),                 // input wire [1023 : 0] dina
  .douta    (wgt_mem_rd_data[1023:0]),  // output wire [1023 : 0] douta
  .rsta_busy()                  // output wire rsta_busy
);

wgt_mem wgt_mem_1 (
  .clka     (clk),              // input wire clka
  .rsta     (rst),              // input wire rsta
  .ena      (en),               // input wire ena
  .wea      (),                 // input wire [127 : 0] wea
  .addra    ({21'b0, wgt_mem_rd_addr}),  // input wire [31 : 0] addra
  .dina     (),                 // input wire [1023 : 0] dina
  .douta    (wgt_mem_rd_data[2047:1024]),  // output wire [1023 : 0] douta
  .rsta_busy()                  // output wire rsta_busy
);

always #5 clk <= ~clk;

initial begin
  #0
    clk = 0;
    rst = 1;
    insn = 0;
    en = 1;
  #5
    rst = 0;
    insn[2:0]     =  3'h2;
    insn[7:3]     =  5'h0;
    insn[20:8]    = 13'h1; // 13 // uop_bgn
    insn[34:21]   = 14'h10; // 14 // uop_end
    insn[48:35]   = 14'h4; // 14 // iter_out
    insn[62:49]   = 14'h4; // 14 // iter_in
    insn[73:63]   = 11'h1; // 11 // dst_factor_out
    insn[84:74]   = 11'h1; // 11 // dst_factor_in
    insn[95:85]   = 11'h4; // 11 // src_factor_out
    insn[106:96]  = 11'h4; // 11 // src_factor_in
    insn[116:107] = 10'h4; // 10 // wgt_factor_out
    insn[126:117] = 10'h4; // 10 // wgt_factor_in
    insn[127]     =  1'b0;     // 1  // *unused
  #1000
    $finish;
end

endmodule