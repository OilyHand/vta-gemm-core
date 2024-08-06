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

  reg  clk;
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
    .FILE("/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/inp_mem.mem")
  ) inp_mem (
    .clk(clk),
    .en(1),
    .we(0),
    .addr(0),
    .din(),
    .dout(i_tensor)
  );

  bram_sp #(
    .WIDTH(WT_WIDTH),
    .DEPTH(1),
    .FILE("/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/wgt_mem.mem")
  ) wgt_mem (
    .clk(clk),
    .en(1),
    .we(0),
    .addr(0),
    .din(),
    .dout(w_tensor)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 1;

    #1000
    $stop;
  end

endmodule