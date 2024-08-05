module systolic_row_lut #(
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
  input wire  [I_T_WIDTH-1:0] i_row,
  input wire  [I_T_WIDTH-1:0] w_row,
  input wire  [ACC_WIDTH-1:0] a_ele,
  output wire [ACC_WIDTH-1:0] o_ele
);

  wire [A_T_WIDTH-1:0] sum;

  genvar i;
  generate
    for(i=0; i<INP_DEPTH; i=i+1) begin : U_MAC
      mac_lut U_MAC_LUT (
        .inp(i_row[i*INP_WIDTH +: INP_WIDTH]),
        .wgt(w_row[i*WGT_WIDTH +: WGT_WIDTH]),
        .acc((i==0) ? a_ele[i*ACC_WIDTH +: ACC_WIDTH] : sum[(i-1)*ACC_WIDTH +: ACC_WIDTH]),
        .sum(sum[i*ACC_WIDTH +: ACC_WIDTH])
      );
    end
  endgenerate

  assign o_ele = sum[A_T_WIDTH-1 -: ACC_WIDTH];
endmodule

//-----------------------------------------------------------------------------

module systolic_row_dsp #(
  parameter INP_WIDTH = 8
          , WGT_WIDTH = 8
          , ACC_WIDTH = 32
          , INP_DEPTH = 16
          , WGT_DEPTH = 16*16
          , ACC_DEPTH = 16
          , I_T_WIDTH = INP_WIDTH * INP_DEPTH
          , W_T_WIDTH = WGT_WIDTH * WGT_DEPTH
          , A_T_WIDTH = ACC_WIDTH * ACC_DEPTH
          , BLOCK_IN  = 16
)(
  input  wire [I_T_WIDTH-1:0] i_row,
  input  wire [I_T_WIDTH-1:0] w_row,
  input  wire [ACC_WIDTH-1:0] a_ele,
  output wire [ACC_WIDTH-1:0] o_ele
);
wire [A_T_WIDTH-1:0] sum;

  genvar i;
  generate
    for(i=0; i<INP_DEPTH; i=i+1) begin : U_MAC
      mac_dsp U_MAC_DSP (
        .inp(i_row[i*INP_WIDTH +: INP_WIDTH]),
        .wgt(w_row[i*WGT_WIDTH +: WGT_WIDTH]),
        .acc((i==0) ? a_ele[i*ACC_WIDTH +: ACC_WIDTH] : sum[(i-1)*ACC_WIDTH +: ACC_WIDTH]),
        .sum(sum[i*ACC_WIDTH +: ACC_WIDTH])
      );
    end
  endgenerate

  assign o_ele = sum[A_T_WIDTH-1 -: ACC_WIDTH];
endmodule
