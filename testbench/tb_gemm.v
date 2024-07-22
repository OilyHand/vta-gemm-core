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
        , ACC_MEM_WREN  = 16
        , OUT_MEM_WREN  = 16*16;

reg clk, rst;
reg  [INS_WIDTH-1:0] insn;
wire [UOP_WIDTH-1:0] uop;
wire [UPC_WIDTH-1:0] upc;
wire [ACC_MEM_WIDTH-1:0] acc_mem_rd_data;
wire [ACC_MEM_WIDTH-1:0] acc_mem_wr_data;
wire [ACC_IDX_WIDTH-1:0] acc_mem_rd_addr;
wire [ACC_IDX_WIDTH-1:0] acc_mem_wr_addr;
wire [ACC_MEM_WREN-1:0]  acc_mem_wr_en;
wire [INP_MEM_WIDTH-1:0] inp_mem_rd_data;
wire [INP_IDX_WIDTH-1:0] inp_mem_rd_addr;
wire [WGT_MEM_WIDTH-1:0] wgt_mem_rd_data;
wire [WGT_IDX_WIDTH-1:0] wgt_mem_rd_addr;
wire [INP_MEM_WIDTH-1:0] out_mem_wr_data;
wire [ACC_IDX_WIDTH-1:0] out_mem_wr_addr;
wire [OUT_MEM_WREN-1:0]  out_mem_wr_en;

gemm dut (
  .clk (clk ),
  .rst (rst ),
  .insn(insn),
  .uop (uop ),
  .upc (upc ),
  .acc_mem_rd_data(acc_mem_rd_data),
  .acc_mem_wr_data(acc_mem_wr_data),
  .acc_mem_rd_addr(acc_mem_rd_addr),
  .acc_mem_wr_addr(acc_mem_wr_addr),
  .acc_mem_wr_en  (acc_mem_wr_en  ),
  .inp_mem_rd_data(inp_mem_rd_data),
  .inp_mem_rd_addr(inp_mem_rd_addr),
  .wgt_mem_rd_data(wgt_mem_rd_data),
  .wgt_mem_rd_addr(wgt_mem_rd_addr),
  .out_mem_wr_data(out_mem_wr_data),
  .out_mem_wr_addr(out_mem_wr_addr),
  .out_mem_wr_en  (out_mem_wr_en  )
);

uop_mem uop_mem (
  .clka (clk),    // input wire clka
  .addra(),  // input wire [12 : 0] addra
  .douta()  // output wire [31 : 0] douta
);

acc_mem acc_mem (
  .clka (clk),    // input wire clka
  .wea  (),      // input wire [0 : 0] wea
  .addra(),  // input wire [10 : 0] addra
  .dina (),    // input wire [511 : 0] dina
  .clkb (),    // input wire clkb
  .addrb(),  // input wire [10 : 0] addrb
  .doutb()  // output wire [511 : 0] doutb
);

inp_mem inp_mem (
  .clka (clk),    // input wire clka
  .addra(),  // input wire [10 : 0] addra
  .douta()  // output wire [127 : 0] douta
);

wgt_mem wgt_mem (
  .clka (clk),    // input wire clka
  .addra(),  // input wire [10 : 0] addra
  .douta()  // output wire [1023 : 0] douta
);

endmodule