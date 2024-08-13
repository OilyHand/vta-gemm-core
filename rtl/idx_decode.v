/*
  instruction field
  +------+------------+----------------+
  | size | field      | field name     |
  +------+------------+----------------+
  | 3    | [2:0]      | opcode         |
  | 1    | [3]        | pop_prev_dep   |
  | 1    | [4]        | pop_next_dep   |
  | 1    | [5]        | push_prev_dep  |
  | 1    | [6]        | push_next_dep  |
  | 1    | [7]        | reset_reg      |
  | 13   | [20:8]     | uop_bgn        |
  | 14   | [34:21]    | uop_end        |
  | 14   | [48:35]    | iter_out       |
  | 14   | [62:49]    | iter_in        |
  | 11   | [73:63]    | dst_factor_out |
  | 11   | [84:74]    | dst_factor_in  |
  | 11   | [95:85]    | src_factor_out |
  | 11   | [106:96]   | src_factor_in  |
  | 10   | [116:107]  | wgt_factor_out |
  | 10   | [126:117]  | wgt_factor_in  |
  | 1    | [127]      | *unused        |
  +------+------------+----------------+

  micro-op field
  +------+---------+-------------------+
  | size | field   | field name        |
  +------+---------+-------------------+
  | 11   | [10:0]  | accumulator index |
  | 11   | [21:11] | input index       |
  | 10   | [31:22] | weight index      |
  +------+---------+-------------------+
*/

module idx_decode (
  input  wire [31:0] uop,
  input  wire [10:0] dst_offset_out,
  input  wire [10:0] src_offset_out,
  input  wire [9:0]  wgt_offset_out,
  input  wire [10:0] dst_offset_in,
  input  wire [10:0] src_offset_in,
  input  wire [9:0]  wgt_offset_in,
  output wire [11:0] dst_idx, // accum tensor index
  output wire [11:0] src_idx, // input tensor index
  output wire [10:0] wgt_idx  // weight tensor index
);

  wire [10:0] x = uop[10:0];  // uop_acc_index
  wire [10:0] y = uop[21:11]; // uop_inp_index
  wire [9:0]  z = uop[31:22]; // uop_wgt_index

  wire [10:0] x0 = dst_offset_out; // dst_factor_out
  wire [10:0] x1 = dst_offset_in;  // dst_factor_in
  wire [10:0] y0 = src_offset_out; // src_factor_out
  wire [10:0] y1 = src_offset_in;  // src_factor_in
  wire [9:0]  z0 = wgt_offset_out; // wgt_factor_out
  wire [9:0]  z1 = wgt_offset_in;  // wgt_factor_in

  assign dst_idx = x0 + x1 + x;
  assign src_idx = y0 + y1 + y;
  assign wgt_idx = z0 + z1 + z;

endmodule