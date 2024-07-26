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

//////////////////////
//    parameters    //
//////////////////////

parameter UOP_WIDTH     = 32
        , UPC_WIDTH     = 13
        , INS_WIDTH     = 128
        , INP_WIDTH     = 8
        , WGT_WIDTH     = 8
        , ACC_WIDTH     = 32
        , ACC_MEM_WIDTH = ACC_WIDTH*16
        , INP_MEM_WIDTH = INP_WIDTH*16
        , WGT_MEM_WIDTH = WGT_WIDTH*16*16
        , BUF_ADR_WIDTH = 32
        , ACC_IDX_WIDTH = 12
        , INP_IDX_WIDTH = 12
        , WGT_IDX_WIDTH = 11
        , ACC_MEM_WREN  = 64
        , OUT_MEM_WREN  = 32;

// reg
reg clk, rst, en;
reg [INS_WIDTH-1:0] insn;

// net
wire [UOP_WIDTH-1:0] uop;
wire [UPC_WIDTH-1:0] upc;
wire [ACC_MEM_WIDTH-1:0] acc_mem_rd_data;
wire [ACC_IDX_WIDTH-1:0] acc_mem_rd_addr;
wire [ACC_MEM_WIDTH-1:0] acc_mem_wr_data;
wire [ACC_IDX_WIDTH-1:0] acc_mem_wr_addr;
wire                     acc_mem_wr_we;
wire [INP_MEM_WIDTH-1:0] inp_mem_rd_data;
wire [BUF_ADR_WIDTH-1:0] inp_mem_rd_addr;
wire [WGT_MEM_WIDTH-1:0] wgt_mem_rd_data;
wire [BUF_ADR_WIDTH-1:0] wgt_mem_rd_addr;
wire [INP_MEM_WIDTH-1:0] out_mem_wr_data;
wire [BUF_ADR_WIDTH-1:0] out_mem_wr_addr;
wire [OUT_MEM_WREN-1:0]  out_mem_wr_we;

wire [INP_WIDTH-1:0] inp_data [15:0];
wire [WGT_WIDTH-1:0] wgt_data [0:15][15:0];
wire [ACC_WIDTH-1:0] acc_data [15:0];
wire [INP_WIDTH-1:0] out_data [15:0];

genvar i,j,k;
generate
  for (i = 0; i < 16; i = i+1)
    for (j = 0; j < 16; j = j+1)
      assign wgt_data[15-i][j] = wgt_mem_rd_data[(i * 16 + j) * 8 +: 8];

  for (k = 0; k < 16; k = k+1) begin
    assign inp_data[k] = inp_mem_rd_data[k*8 +: 8];
    assign acc_data[k] = acc_mem_rd_data[k*8 +: 8];
    assign out_data[k] = out_mem_wr_data[k*8 +: 8];
  end
endgenerate

/////////////////////////////
//    design under test    //
/////////////////////////////

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


//////////////////
//    memory    //
//////////////////

uop_mem_0 uop_mem (
  .clka (clk),
  .rsta (rst),
  .ena  (en),
  .addra(upc),
  .douta(uop)
);

acc_mem_0 acc_mem (
  .clka (clk),
  .rsta (rst),
  .ena  (en),
  .addra(acc_mem_rd_addr),
  .douta(acc_mem_rd_data),
  .enb  (en),
  .web  (acc_mem_wr_we),
  .addrb(acc_mem_wr_addr),
  .dinb (acc_mem_wr_data)
);

inp_mem_0 inp_mem (
  .clka (clk),
  .rsta (rst),
  .ena  (en),
  .addra(inp_mem_rd_addr),
  .douta(inp_mem_rd_data)
);

wgt_mem_0 wgt_mem0 (
  .clka (clk),
  .rsta (rst),
  .ena  (en),
  .addra(wgt_mem_rd_addr),
  .douta(wgt_mem_rd_data[2047:1024])
);

wgt_mem_1 wgt_mem1 (
  .clka (clk),
  .rsta (rst),
  .ena  (en),
  .addra(wgt_mem_rd_addr),
  .douta(wgt_mem_rd_data[1023:0])
);


//////////////////////////////
//    running simulation    //
//////////////////////////////

/*

*/

always #5 clk <= ~clk;

initial begin
  #0
    clk  = 0;
    rst  = 1;
    insn = 0;
    en   = 0;
  #5
    rst = 0;
    en  = 1;
    insn[2:0]     =  3'd2;
    insn[7:3]     =  5'd0;
    insn[20:8]    = 13'd1;  // uop_bgn
    insn[34:21]   = 14'd4;  // uop_end
    insn[48:35]   = 14'd16;  // iter_out
    insn[62:49]   = 14'd16;  // iter_in
    insn[73:63]   = 11'd256;  // dst_factor_out // acc
    insn[84:74]   = 11'd256;  // dst_factor_in  // acc
    insn[95:85]   = 11'd16;  // src_factor_out // inp
    insn[106:96]  = 11'd16;  // src_factor_in  // inp
    insn[116:107] = 10'd128;  // wgt_factor_out // wgt
    insn[126:117] = 10'd128;  // wgt_factor_in  // wgt
    insn[127]     =  1'b0;  // *unused
  #10000000
    $finish;
end

endmodule