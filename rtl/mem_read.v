module mem_read #(
  parameter INS_WIDTH     = 128  
          , INP_WIDTH     = 8
          , WGT_WIDTH     = 8
          , ACC_WIDTH     = 32 
          , ACC_MEM_WIDTH = ACC_WIDTH * 16
          , INP_MEM_WIDTH = INP_WIDTH * 16
          , WGT_MEM_WIDTH = WGT_WIDTH * 16 * 16
          , ACC_IDX_WIDTH = 12
          , INP_IDX_WIDTH = 12
          , WGT_IDX_WIDTH = 11
)(
  input  wire [INP_MEM_WIDTH-1:0] inp_mem,
  input  wire [WGT_MEM_WIDTH-1:0] wgt_mem,
  input  wire [ACC_MEM_WIDTH-1:0] acc_mem,
  input  wire [INP_MEM_WIDTH-1:0] inp_mem,
  input  wire [WGT_MEM_WIDTH-1:0] wgt_mem,
  input  wire [ACC_MEM_WIDTH-1:0] acc_mem,
  output wire [INP_IDX_WIDTH-1:0] inp_addr,
  output wire [WGT_IDX_WIDTH-1:0] wgt_addr,
  output wire [ACC_IDX_WIDTH-1:0] acc_addr,
  output wire [INP_IDX_WIDTH-1:0] inp_addr,
  output wire [WGT_IDX_WIDTH-1:0] wgt_addr,
  output wire [ACC_IDX_WIDTH-1:0] acc_addr
);
/*
to be access
- input memory  -> input tensor
- weight memory -> weight tensor
- accum memory  -> accum tensor
*/



endmodule