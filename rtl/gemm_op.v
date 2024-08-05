module gemm_op #(
  parameter INP_WIDTH = 8
          , WGT_WIDTH = 8
          , ACC_WIDTH = 32
          , INP_DEPTH = 16
          , WGT_DEPTH = 16*16
          , ACC_DEPTH = 16
          , I_T_WIDTH = INP_WIDTH * INP_DEPTH
          , W_T_WIDTH = WGT_WIDTH * WGT_DEPTH
          , A_T_WIDTH = ACC_WIDTH * ACC_DEPTH
)(
  input  wire [I_T_WIDTH-1:0] i_tensor, // 1x16 input matrix, size of each tile is 8 bits (16 * 8 bits = 128 bits)
  input  wire [W_T_WIDTH-1:0] w_tensor, // 16x16 weight matrix, size of each tile is 8 bits (16 * 16 * 8 bits = 2048 bits)
  input  wire [A_T_WIDTH-1:0] a_tensor, // 1x16 accumulator matrix, size of each tile is 32 bits (16 * 32 = 512 bits)
  output wire [A_T_WIDTH-1:0] o_tensor  // 1x16 result matrix, each element is 32 bits
);

  genvar i;
  generate 
    for(i=0; i<INP_DEPTH; i=i+1) begin : U_Systolic_Array
      if(i < 3) begin : ROW_LUT
        systolic_row_lut #(
          .INP_WIDTH(INP_WIDTH),
          .WGT_WIDTH(WGT_WIDTH),
          .ACC_WIDTH(ACC_WIDTH),
          .INP_DEPTH(INP_DEPTH),
          .WGT_DEPTH(WGT_DEPTH),
          .ACC_DEPTH(ACC_DEPTH),
          .I_T_WIDTH(I_T_WIDTH),
          .W_T_WIDTH(W_T_WIDTH),
          .A_T_WIDTH(A_T_WIDTH)
        ) LUT (
          .i_row(i_tensor),
          .w_row(w_tensor[i*I_T_WIDTH +: I_T_WIDTH]),
          .a_ele(a_tensor[i*ACC_WIDTH +: ACC_WIDTH]),
          .o_ele(o_tensor[i*ACC_WIDTH +: ACC_WIDTH])
        );
      end else begin : ROW_DSP
        systolic_row_dsp #(
          .INP_WIDTH(INP_WIDTH),
          .WGT_WIDTH(WGT_WIDTH),
          .ACC_WIDTH(ACC_WIDTH),
          .INP_DEPTH(INP_DEPTH),
          .WGT_DEPTH(WGT_DEPTH),
          .ACC_DEPTH(ACC_DEPTH),
          .I_T_WIDTH(I_T_WIDTH),
          .W_T_WIDTH(W_T_WIDTH),
          .A_T_WIDTH(A_T_WIDTH)
        ) DSP (
          .i_row(i_tensor),
          .w_row(w_tensor[i*I_T_WIDTH +: I_T_WIDTH]),
          .a_ele(a_tensor[i*ACC_WIDTH +: ACC_WIDTH]),
          .o_ele(o_tensor[i*ACC_WIDTH +: ACC_WIDTH])
        );
      end
    end
  endgenerate

endmodule