module gemm #(
  parameter UOP_WIDTH     = 32
          , UPC_WIDTH     = 13
          , INS_WIDTH     = 128  
          , INP_WIDTH     = 8
          , WGT_WIDTH     = 8
          , ACC_WIDTH     = 32 
          , ACC_MEM_WIDTH = ACC_WIDTH * 16
          , INP_MEM_WIDTH = INP_WIDTH * 16
          , WGT_MEM_WIDTH = WGT_WIDTH * 16 * 16
          , ACC_IDX_WIDTH = 12
          , INP_IDX_WIDTH = 12
          , WGT_IDX_WIDTH = 11
          , ACC_MEM_WREN  = 16
          , OUT_MEM_WREN  = 16*16
)(
  input wire clk,
  input wire rst,
  // commands
  input  wire [INS_WIDTH-1:0] insn, // instruction
  input  wire [UOP_WIDTH-1:0] uop,  // micro-op code
  output wire [UPC_WIDTH-1:0] upc,  // micro-op program counter
  // register file access
  input  wire [ACC_MEM_WIDTH-1:0] acc_mem_rd_data,
  output wire [ACC_MEM_WIDTH-1:0] acc_mem_wr_data,
  output wire [ACC_IDX_WIDTH-1:0] acc_mem_rd_addr,
  output wire [ACC_IDX_WIDTH-1:0] acc_mem_wr_addr,
  output wire [ACC_MEM_WREN-1:0]  acc_mem_wr_en,
  // input memory(buffer) access
  input  wire [INP_MEM_WIDTH-1:0] inp_mem_rd_data,
  output wire [INP_IDX_WIDTH-1:0] inp_mem_rd_addr,
  // weight memory(buffer) access
  input  wire [WGT_MEM_WIDTH-1:0] wgt_mem_rd_data,
  output wire [WGT_IDX_WIDTH-1:0] wgt_mem_rd_addr,
  // output memory(buffer) access
  output wire [INP_MEM_WIDTH-1:0] out_mem_wr_data,
  output wire [ACC_IDX_WIDTH-1:0] out_mem_wr_addr,
  output wire [OUT_MEM_WREN-1:0]  out_mem_wr_en
);
  // UOP
  wire [ACC_IDX_WIDTH-2:0] u_dst_offset_out;
  wire [INP_IDX_WIDTH-2:0] u_src_offset_out;
  wire [WGT_IDX_WIDTH-2:0] u_wgt_offset_out;
  wire [ACC_IDX_WIDTH-2:0] u_dst_offset_in;
  wire [INP_IDX_WIDTH-2:0] u_src_offset_in; 
  wire [WGT_IDX_WIDTH-2:0] u_wgt_offset_in;

  reg [UOP_WIDTH-1:0]     u2i_uop;
  reg [ACC_IDX_WIDTH-2:0] u2i_dst_offset_out;
  reg [INP_IDX_WIDTH-2:0] u2i_src_offset_out;
  reg [WGT_IDX_WIDTH-2:0] u2i_wgt_offset_out;
  reg [ACC_IDX_WIDTH-2:0] u2i_dst_offset_in;
  reg [INP_IDX_WIDTH-2:0] u2i_src_offset_in; 
  reg [WGT_IDX_WIDTH-2:0] u2i_wgt_offset_in;
  reg u2i_reg_reset;
  reg u2i_wr_en;

  // IDX
  wire [ACC_IDX_WIDTH-1:0] i_dst_idx;
  wire [INP_IDX_WIDTH-1:0] i_src_idx;
  wire [WGT_IDX_WIDTH-1:0] i_wgt_idx;

  reg [ACC_IDX_WIDTH-1:0] i2m_dst_idx;
  reg [INP_IDX_WIDTH-1:0] i2m_src_idx;
  reg [WGT_IDX_WIDTH-1:0] i2m_wgt_idx;
  reg i2m_reg_reset;
  reg i2m_wr_en;

  // MEM
  reg [INP_MEM_WIDTH-1:0] m2e_i_tenor;
  reg [WGT_MEM_WIDTH-1:0] m2e_w_tenor;
  reg [ACC_MEM_WIDTH-1:0] m2e_a_tenor;
  reg [ACC_MEM_WIDTH-1:0] m2e_dst_idx;
  reg m2e_reg_reset;
  reg m2e_wr_en;

  // EX
  wire [ACC_MEM_WIDTH-1:0] gemm_res;

  reg [ACC_MEM_WIDTH-1:0] e_a_tensor;
  reg [INP_MEM_WIDTH-1:0] e_o_tensor;
  reg [ACC_MEM_WIDTH-1:0] e2w_dst_idx;
  reg e2w_wr_en;


/* ============================== UOP Stage ============================== */
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

  // --------------- reg U2I --------------- //
  always @(posedge clk, negedge rst) begin
    if(!rst) begin
    ///////////////////////
      u2i_uop <= 0;
      u2i_reg_reset <= 0;
      u2i_wr_en <= 0;
    ///////////////////////
      u2i_dst_offset_out <= 0;
      u2i_src_offset_out <= 0;
      u2i_wgt_offset_out <= 0;
      u2i_dst_offset_in  <= 0;
      u2i_src_offset_in  <= 0;
      u2i_wgt_offset_in  <= 0;
    end
    else begin
    /////////////////////////////
      u2i_uop <= uop;
      u2i_reg_reset <= insn[7];
      u2i_wr_en <= (insn[2:0] == 3'b010);
    /////////////////////////////
      u2i_dst_offset_out <= u_dst_offset_out;
      u2i_src_offset_out <= u_src_offset_out;
      u2i_wgt_offset_out <= u_wgt_offset_out;
      u2i_dst_offset_in  <= u_dst_offset_in;
      u2i_src_offset_in  <= u_src_offset_in;
      u2i_wgt_offset_in  <= u_wgt_offset_in;
    end
  end


/* ============================== IDX Stage ============================== */
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
  
  // --------------- reg I2M --------------- //
  always @(posedge clk, negedge rst) begin
    if (!rst) begin
    ///////////////////////
      i2m_reg_reset <= 0;
      i2m_wr_en <= 0;
    ///////////////////////
      i2m_dst_idx <= 0;
      i2m_src_idx <= 0;
      i2m_wgt_idx <= 0;
    end
    else begin
    ///////////////////////////////////
      i2m_reg_reset <= u2i_reg_reset;
      i2m_wr_en <= u2i_wr_en;
    ///////////////////////////////////
      i2m_dst_idx <= i_dst_idx;
      i2m_src_idx <= i_src_idx;
      i2m_wgt_idx <= i_wgt_idx;
    end
  end


/* ============================== MEM Stage ============================== */
  // addressing
  assign acc_mem_rd_addr = i2m_dst_idx;
  assign inp_mem_rd_addr = i2m_src_idx;
  assign wgt_mem_rd_addr = i2m_wgt_idx;
  
  // --------------- reg M2E --------------- //
  always @(posedge clk, negedge rst) begin
    if(!rst) begin
    ///////////////////////
      m2e_reg_reset <= 0;
      m2e_dst_idx   <= 0;
      m2e_wr_en     <= 0;
    ///////////////////////
      m2e_i_tenor <= 0;
      m2e_w_tenor <= 0;
      m2e_a_tenor <= 0;
    end else begin
    ///////////////////////////////////
      m2e_reg_reset <= i2m_reg_reset;
      m2e_dst_idx   <= i2m_dst_idx;
      m2e_wr_en     <= i2m_wr_en;
    ///////////////////////////////////
      m2e_i_tenor <= inp_mem_rd_data;
      m2e_w_tenor <= wgt_mem_rd_data;
      m2e_a_tenor <= (i2m_dst_idx == m2e_dst_idx) ? gemm_res : acc_mem_rd_data; // forwarding
    end
  end
  

/* ============================== EX Stage ============================== */
  gemm_op U_EX (
    .i_tensor(m2e_i_tenor),
    .w_tensor(m2e_w_tenor),
    .a_tensor(m2e_a_tenor),
    .o_tensor(gemm_res)
  );

  // --------------- reg E2W --------------- //
  always @(posedge clk, negedge rst) begin
    if (!rst) begin
    ///////////////////////
      e2w_dst_idx <= 0;
      e2w_wr_en   <= 0;
    ///////////////////////
      e_a_tensor <= 0;
      e_o_tensor <= 0;
    end else begin
    ///////////////////////////////
      e2w_dst_idx <= m2e_dst_idx;
      e2w_wr_en   <= m2e_wr_en;
    ///////////////////////////////
      e_a_tensor <= (m2e_reg_reset) ? 0 : gemm_res;
      e_o_tensor <= gemm_res[INP_MEM_WIDTH-1:0];
    end
  end


/* ============================== WB Stage ============================== */
  // write enable signal setting
  // assign data
  assign acc_mem_wr_data = e_a_tensor;
  assign acc_mem_wr_addr = e2w_dst_idx;
  assign acc_mem_wr_en   = { OUT_MEM_WREN{e2w_wr_en} };
  assign out_mem_wr_data = e_o_tensor;
  assign out_mem_wr_addr = e2w_dst_idx;
  assign out_mem_wr_en   = { OUT_MEM_WREN{e2w_wr_en} };
  
endmodule
