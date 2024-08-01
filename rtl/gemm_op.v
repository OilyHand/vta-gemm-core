module gemm_op #(
  parameter INP_WIDTH = 8
          , WGT_WIDTH = 8
          , ACC_WIDTH = 32
          , IT_WIDTH  = INP_WIDTH * 16
          , WT_WIDTH  = WGT_WIDTH * 16 * 16
          , AT_WIDTH  = ACC_WIDTH * 16
)(
  input  wire [IT_WIDTH-1:0] i_tensor, // 1x16 input matrix, size of each tile is 8 bits (16 * 8 bits = 128 bits)
  input  wire [WT_WIDTH-1:0] w_tensor, // 16x16 weight matrix, size of each tile is 8 bits (16 * 16 * 8 bits = 2048 bits)
  input  wire [AT_WIDTH-1:0] a_tensor, // 1x16 accumulator matrix, size of each tile is 32 bits (16 * 32 = 512 bits)
  output wire [AT_WIDTH-1:0] o_tensor  // 1x16 result matrix, each element is 8 bits
);

  wire [AT_WIDTH-1:0] srow_00, srow_01, srow_02, srow_03;
  wire [AT_WIDTH-1:0] srow_04, srow_05, srow_06, srow_07;
  wire [AT_WIDTH-1:0] srow_08, srow_09, srow_10, srow_11;
  wire [AT_WIDTH-1:0] srow_12, srow_13, srow_14;

  // systolic_row_lut U_ROW_00 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH-1:0]),
  //   .a_row(a_tensor),
  //   .o_row(srow_00)
  // );

  // systolic_row_lut U_ROW_01 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*2-1:IT_WIDTH]),
  //   .a_row(srow_00),
  //   .o_row(srow_01)
  // );

  // systolic_row_lut U_ROW_02 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*3-1:IT_WIDTH*2]),
  //   .a_row(srow_01),
  //   .o_row(srow_02)
  // );

  // systolic_row_dsp U_ROW_03 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*4-1:IT_WIDTH*3]),
  //   .a_row(srow_02),
  //   .o_row(srow_03)
  // );

  // systolic_row_dsp U_ROW_04 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*5-1:IT_WIDTH*4]),
  //   .a_row(srow_03),
  //   .o_row(srow_04)
  // );

  // systolic_row_dsp U_ROW_05 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*6-1:IT_WIDTH*5]),
  //   .a_row(srow_04),
  //   .o_row(srow_05)
  // );

  // systolic_row_dsp U_ROW_06 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*7-1:IT_WIDTH*6]),
  //   .a_row(srow_05),
  //   .o_row(srow_06)
  // );

  // systolic_row_dsp U_ROW_07 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*8-1:IT_WIDTH*7]),
  //   .a_row(srow_06),
  //   .o_row(srow_07)
  // );

  // systolic_row_dsp U_ROW_08 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*9-1:IT_WIDTH*8]),
  //   .a_row(srow_07),
  //   .o_row(srow_08)
  // );

  // systolic_row_dsp U_ROW_09 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*10-1:IT_WIDTH*9]),
  //   .a_row(srow_08),
  //   .o_row(srow_09)
  // );

  // systolic_row_dsp U_ROW_10 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*11-1:IT_WIDTH*10]),
  //   .a_row(srow_09),
  //   .o_row(srow_10)
  // );

  // systolic_row_dsp U_ROW_11 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*12-1:IT_WIDTH*11]),
  //   .a_row(srow_10),
  //   .o_row(srow_11)
  // );

  // systolic_row_dsp U_ROW_12 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*13-1:IT_WIDTH*12]),
  //   .a_row(srow_11),
  //   .o_row(srow_12)
  // );

  // systolic_row_dsp U_ROW_13 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*14-1:IT_WIDTH*13]),
  //   .a_row(srow_12),
  //   .o_row(srow_13)
  // );

  // systolic_row_dsp U_ROW_14 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*15-1:IT_WIDTH*14]),
  //   .a_row(srow_13),
  //   .o_row(srow_14)
  // );

  // systolic_row_dsp U_ROW_15 (
  //   .i_row(i_tensor),
  //   .w_row(w_tensor[IT_WIDTH*16-1:IT_WIDTH*15]),
  //   .a_row(srow_14),
  //   .o_row(o_tensor)
  // );

endmodule