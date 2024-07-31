`timescale 1ns/1ns

module tb_gemm_op();

  parameter INP_WIDTH = 8
          , WGT_WIDTH = 8
          , ACC_WIDTH = 32
          , INP_DEPTH = 16
          , WGT_DEPTH = 16*16
          , IT_WIDTH  = INP_WIDTH * INP_DEPTH
          , WT_WIDTH  = WGT_WIDTH * WGT_DEPTH
          , AT_WIDTH  = ACC_WIDTH * INP_DEPTH;

  wire [IT_WIDTH-1:0] i_tensor;
  wire [WT_WIDTH-1:0] w_tensor;
  wire [AT_WIDTH-1:0] o_tensor;

  wire [INP_WIDTH-1:0] i_view [0:INP_DEPTH-1];
  wire [WGT_WIDTH-1:0] w_view [0:INP_DEPTH-1][0:INP_DEPTH-1];
  wire [INP_WIDTH-1:0] o_view [0:INP_DEPTH-1];

  reg clk;

  genvar m,n;
  generate
    for(m=0; m<INP_DEPTH; m=m+1) begin
      assign o_view[m] = o_tensor[m*ACC_WIDTH +: INP_WIDTH];
      assign i_view[m] = i_tensor[m*INP_WIDTH +: INP_WIDTH];
      for(n=0; n<INP_DEPTH; n=n+1)
        assign w_view[m][n] = w_tensor[(m*INP_DEPTH + n*WGT_WIDTH) +: WGT_WIDTH];
    end
  endgenerate

  gemm_op U_GEMM (
    .i_tensor(i_tensor),
    .w_tensor(w_tensor),
    .a_tensor(0),
    .o_tensor(o_tensor)
  );

  always #5 clk <= ~clk;

  bram #(
    .FILE("/home/sjson/work/tvm_project/vta-gemm-core/sim/coefficients/inp_mem.mem"),
    .WIDTH(INP_WIDTH),
    .DEPTH(INP_DEPTH)
  ) inp_mem (
    .clk(clk),
    .we(1'b0),
    .din(),
    .dout(),
    .full(i_tensor)
  );

  bram #(
    .FILE("/home/sjson/work/tvm_project/vta-gemm-core/sim/coefficients/wgt_mem.mem"),
    .WIDTH(WGT_WIDTH),
    .DEPTH(WGT_DEPTH)
  ) wgt_mem (
    .clk(clk),
    .we(1'b0),
    .din(),
    .dout(),
    .full(w_tensor)
  );

  // bram #(
  //   // .FILE("/home/sjson/work/tvm_project/vta-gemm-core/sim/coefficients/out_mem.mem"),
  //   .WIDTH(ACC_WIDTH),
  //   .DEPTH(INP_DEPTH)
  // ) out_mem (
  //   .clk(clk),
  //   .we(1'b1),
  //   .din(o_tensor),
  //   .dout()
  // );

  initial begin
  #0
    clk = 0;
  #10
    $stop;
  end

endmodule

module bram #(
  parameter WIDTH = 8
          , DEPTH = 16
          , FILE = "test.mem"
)(
  input  wire clk,
  input  wire we,
  input  wire addr,
  input  wire [WIDTH-1:0] din,
  output reg  [WIDTH-1:0] dout,
  output wire [WIDTH*DEPTH-1:0] full
);
  reg [WIDTH-1:0] ram [DEPTH-1:0];

  // integer i;
  initial begin
    // i = 0;
    $readmemh(FILE, ram);
    // for(i = 0; i < 2; i=i+1)
    // ram[i] <= 0;
  end

  always @(posedge clk)
  begin
    if (we) begin
      ram[addr] <= din;
      // $writememh(FILE, out_mem);
    end
    dout <= ram[addr];
  end

  genvar j;
  generate
    for (j=0; j<DEPTH; j=j+1)
      assign full[j*WIDTH +: WIDTH] = ram[j];
  endgenerate
endmodule