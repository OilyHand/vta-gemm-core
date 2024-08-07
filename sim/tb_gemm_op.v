`timescale 1ns/1ps

module tb_gemm_op();

  parameter INP_WIDTH = 8
          , WGT_WIDTH = 8
          , ACC_WIDTH = 32
          , INP_DEPTH = 16
          , WGT_DEPTH = 16*16
          , IT_WIDTH  = INP_WIDTH * INP_DEPTH
          , WT_WIDTH  = WGT_WIDTH * WGT_DEPTH
          , AT_WIDTH  = ACC_WIDTH * INP_DEPTH;

    parameter
          INP_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/inp_mem.mem"
        , WGT_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/wgt_mem.mem"
        , ACC_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/acc_mem.mem";

  reg  clk, rst;
  wire [IT_WIDTH-1:0] i_tensor;
  wire [WT_WIDTH-1:0] w_tensor;
  wire [AT_WIDTH-1:0] o_tensor;

  gemm_op U_GEMM (
    .i_tensor(i_tensor),
    .w_tensor(w_tensor),
    .a_tensor(0),
    .o_tensor(o_tensor)
  );

  bram_sp #(
    .WIDTH(IT_WIDTH),
    .DEPTH(1),
    .FILE(INP_MEM_PATH)
  ) inp_mem (
    .clk(clk),
    .en(1),
    .rst(rst),
    .we(0),
    .addr(0),
    .din(),
    .dout(i_tensor)
  );

  bram_sp #(
    .WIDTH(WT_WIDTH),
    .DEPTH(1),
    .FILE(WGT_MEM_PATH)
  ) wgt_mem (
    .clk(clk),
    .en(1),
    .rst(rst),
    .we(0),
    .addr(0),
    .din(),
    .dout(w_tensor)
  );

endmodule