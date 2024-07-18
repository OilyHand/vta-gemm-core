module gemm #(
  parameter UOP_WIDTH   = 32
          , INS_WIDTH   = 128  
          , INP_WIDTH   = 8
          , WGT_WIDTH   = 8
          , ACC_WIDTH   = 32 
          , IT_WIDTH    = INP_WIDTH * 16
          , WT_WIDTH    = WGT_WIDTH * 16 * 16
          , AT_WIDTH    = ACC_WIDTH * 16
          , A_IDX_WIDTH = 12
          , I_IDX_WIDTH = 12
          , W_IDX_WIDTH = 11
)(
  input wire clk,
  input wire rst,
  // instruction  
  input  wire [INS_WIDTH-1:0] insn,
  // micro-op access
  input  wire [UOP_WIDTH-1:0] uop,
  output wire [12:0]          upc
  // register file access
  // input  wire [31:0]          acc_mem_in,
  // output reg  [31:0]          acc_mem_out,
  // output reg  [12:0]          acc_mem_addr,
  // buffer access
  // input  wire [IT_WIDTH-1:0]  inp_mem,
  // input  wire [WT_WIDTH-1:0]  wgt_mem,
  // output wire [IT_WIDTH-1:0]  out_mem,
  // output wire [12:0]          inp_mem_addr,
  // output wire [12:0]          wgt_mem_addr,
  // output wire [12:0]          out_mem_addr
);
  //################# UOP Stage #####################################
  wire [A_IDX_WIDTH-2:0] u_dst_offset_out;
  wire [I_IDX_WIDTH-2:0] u_src_offset_out;
  wire [W_IDX_WIDTH-2:0] u_wgt_offset_out;
  wire [A_IDX_WIDTH-2:0] u_dst_offset_in;
  wire [I_IDX_WIDTH-2:0] u_src_offset_in; 
  wire [W_IDX_WIDTH-2:0] u_wgt_offset_in; 

  uop_fetch U_UOP (
    .clk  (clk),
    .rst  (rst),
    .insn (insn),
    .upc  (upc),
    .dst_offset_out(u_dst_offset_out),
    .src_offset_out(u_src_offset_out),
    .wgt_offset_out(u_wgt_offset_out),
    .dst_offset_in (u_dst_offset_in),
    .src_offset_in (u_src_offset_in),
    .wgt_offset_in (u_wgt_offset_in)
  );

  // -------------- reg U2I -------------- //
  reg [UOP_WIDTH-1:0] u2i_uop;
  reg [A_IDX_WIDTH-2:0] u2i_dst_offset_out;
  reg [I_IDX_WIDTH-2:0] u2i_src_offset_out;
  reg [W_IDX_WIDTH-2:0] u2i_wgt_offset_out;
  reg [A_IDX_WIDTH-2:0] u2i_dst_offset_in;
  reg [I_IDX_WIDTH-2:0] u2i_src_offset_in; 
  reg [W_IDX_WIDTH-2:0] u2i_wgt_offset_in;
  reg u2i_reg_reset;

  always @(posedge clk, negedge rst) begin
    if(!rst) begin
      u2i_uop <= 0;
      u2i_reg_reset <= 0;
      u2i_dst_offset_out <= 0;
      u2i_src_offset_out <= 0;
      u2i_wgt_offset_out <= 0;
      u2i_dst_offset_in  <= 0;
      u2i_src_offset_in  <= 0;
      u2i_wgt_offset_in  <= 0;
    end
    else begin
      u2i_uop <= uop;
      u2i_reg_reset <= insn[7];
      u2i_dst_offset_out <= u_dst_offset_out;
      u2i_src_offset_out <= u_src_offset_out;
      u2i_wgt_offset_out <= u_wgt_offset_out;
      u2i_dst_offset_in  <= u_dst_offset_in;
      u2i_src_offset_in  <= u_src_offset_in;
      u2i_wgt_offset_in  <= u_wgt_offset_in;
    end
  end


  //################# IDX Stage #####################################
  wire [A_IDX_WIDTH-1:0] i_dst_idx;
  wire [I_IDX_WIDTH-1:0] i_src_idx;
  wire [W_IDX_WIDTH-1:0] i_wgt_idx;

  idx_decode U_IDX (
    .uop(u2i_uop),
    .dst_offset_out(u2i_dst_offset_out),
    .src_offset_out(u2i_src_offset_out),
    .wgt_offset_out(u2i_wgt_offset_out),
    .dst_offset_in (u2i_dst_offset_in),
    .src_offset_in (u2i_src_offset_in),
    .wgt_offset_in (u2i_wgt_offset_in),
    .dst_idx(i_dst_idx),
    .src_idx(i_src_idx),
    .wgt_idx(i_wgt_idx)
  );

  // -------------- reg I2M -------------- //
  reg [A_IDX_WIDTH-1:0] i2m_dst_idx;
  reg [I_IDX_WIDTH-1:0] i2m_src_idx;
  reg [W_IDX_WIDTH-1:0] i2m_wgt_idx;
  reg i2m_reg_reset;

  always @(posedge clk, negedge rst) begin
    if (!rst) begin
      i2m_reg_reset <= 0;
      i2m_dst_idx <= 0;
      i2m_src_idx <= 0;
      i2m_wgt_idx <= 0;
    end
    else begin
      i2m_reg_reset <= u2i_reg_reset;
      i2m_dst_idx <= i_dst_idx;
      i2m_src_idx <= i_src_idx;
      i2m_wgt_idx <= i_wgt_idx;
    end
  end
  
  //################# MEM Stage #####################################
  mem_read U_MEM (

  );

    // -------------- reg M2E -------------- //
  

  //################# EX Stage #####################################
  gemm_op U_EX (

  );

    // -------------- reg E2W -------------- //


  //################# WB Stage #####################################
  write_back U_WB (

  );
  	      
endmodule
