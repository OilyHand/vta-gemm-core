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

module idx_decode (
  input  wire [31:0] uop,
  input  wire [13:0] iter_out,
  input  wire [13:0] iter_in,
  input  wire [21:0] dst_factor,
  input  wire [21:0] src_factor,
  input  wire [19:0] wgt_factor,
  output wire [11:0] dst_idx, // accum tensor index 
  output wire [11:0] src_idx, // input tensor index
  output wire [11:0] wgt_idx  // weight tensor index
);
  
  wire [10:0] x = uop[10:0];  // uop_acc_index 
  wire [10:0] y = uop[21:11]; // uop_inp_index 
  wire [9:0]  z = uop[31:22]; // uop_wgt_index
  
  wire [10:0] x0 = dst_factor[10:0];  // dst_factor_out
  wire [10:0] x1 = dst_factor[21:11]; // dst_factor_in
  wire [10:0] y0 = src_factor[10:0];  // src_factor_out
  wire [10:0] y1 = src_factor[21:11]; // src_factor_in
  wire [9:0]  z0 = wgt_factor[9:0];   // wgt_factor_out
  wire [9:0]  z1 = wgt_factor[19:10]; // wgt_factor_in
  
  assign dst_idx = iter_out*x0 + iter_in*x1 + x;
  assign src_idx = iter_out*y0 + iter_in*y1 + y;
  assign wgt_idx = iter_out*z0 + iter_in*z1 + z;

endmodule