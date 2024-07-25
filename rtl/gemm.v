`default_nettype none

module gemm #(
  parameter UOP_WIDTH     = 32
          , UPC_WIDTH     = 13
          , INS_WIDTH     = 128
          , INP_WIDTH     = 8
          , WGT_WIDTH     = 8
          , ACC_WIDTH     = 32
          , ACC_MEM_WIDTH = ACC_WIDTH*16
          , INP_MEM_WIDTH = INP_WIDTH*16
          , WGT_MEM_WIDTH = WGT_WIDTH*16*16
          , ACC_IDX_WIDTH = 12
          , INP_IDX_WIDTH = 12
          , WGT_IDX_WIDTH = 11
          , ACC_MEM_WREN  = 64
          , OUT_MEM_WREN  = 32
)(
  // control signal
  input  wire                     clk,
  input  wire                     rst,
  input  wire [INS_WIDTH-1:0]     insn, // instruction
  // micro-op cache read access
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> DOUT" *)
  input  wire [UOP_WIDTH-1:0]     uop,  // micro-op code
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> ADDR" *)
  output wire [UPC_WIDTH-1:0]     upc,  // micro-op program counter
  
  // register file read access
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> DOUT" *)
  input  wire [ACC_MEM_WIDTH-1:0] acc_mem_rd_data,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> ADDR" *)
  output wire [ACC_IDX_WIDTH-1:0] acc_mem_rd_addr,

  // register file write access
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> DIN" *)
  output wire [ACC_MEM_WIDTH-1:0] acc_mem_wr_data,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> ADDR" *)
  output wire [ACC_IDX_WIDTH-1:0] acc_mem_wr_addr,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> WE" *)
  output wire [ACC_MEM_WREN-1:0]  acc_mem_wr_we,
  
  // input memory(buffer) access
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> DOUT" *)
  input  wire [INP_MEM_WIDTH-1:0] inp_mem_rd_data,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> ADDR" *)
  output wire [INP_IDX_WIDTH-1:0] inp_mem_rd_addr,
  // weight memory(buffer) access
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> DOUT" *)
  input  wire [WGT_MEM_WIDTH-1:0] wgt_mem_rd_data,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> ADDR" *)
  output wire [WGT_IDX_WIDTH-1:0] wgt_mem_rd_addr,
  // output memory(buffer) access
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> DIN" *)
  output wire [INP_MEM_WIDTH-1:0] out_mem_wr_data,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> ADDR" *)
  output wire [ACC_IDX_WIDTH-1:0] out_mem_wr_addr,
  (* X_INTERFACE_INFO = "xilinx.com:interface:bram:1.0 <interface_name> WE" *)
  output wire [OUT_MEM_WREN-1:0]  out_mem_wr_we
);
  // UOP Stage
  wire [ACC_IDX_WIDTH-2:0] u_dst_offset_out;
  wire [INP_IDX_WIDTH-2:0] u_src_offset_out;
  wire [WGT_IDX_WIDTH-2:0] u_wgt_offset_out;
  wire [ACC_IDX_WIDTH-2:0] u_dst_offset_in;
  wire [INP_IDX_WIDTH-2:0] u_src_offset_in;
  wire [WGT_IDX_WIDTH-2:0] u_wgt_offset_in;

  // UOP to IDX registers
  reg [UOP_WIDTH-1:0]     u2i_uop;
  reg [ACC_IDX_WIDTH-2:0] u2i_dst_offset_out;
  reg [INP_IDX_WIDTH-2:0] u2i_src_offset_out;
  reg [WGT_IDX_WIDTH-2:0] u2i_wgt_offset_out;
  reg [ACC_IDX_WIDTH-2:0] u2i_dst_offset_in;
  reg [INP_IDX_WIDTH-2:0] u2i_src_offset_in;
  reg [WGT_IDX_WIDTH-2:0] u2i_wgt_offset_in;
  reg u2i_reg_reset;
  reg u2i_we;

  // IDX Stage
  wire [ACC_IDX_WIDTH-1:0] i_dst_idx;
  wire [INP_IDX_WIDTH-1:0] i_src_idx;
  wire [WGT_IDX_WIDTH-1:0] i_wgt_idx;

  // IDX to MEM registers
  reg [ACC_IDX_WIDTH-1:0] i2m_dst_idx;
  reg [INP_IDX_WIDTH-1:0] i2m_src_idx;
  reg [WGT_IDX_WIDTH-1:0] i2m_wgt_idx;
  reg i2m_reg_reset;
  reg i2m_we;

  // MEM to EX registers
  reg [INP_MEM_WIDTH-1:0] m2e_i_tenor;
  reg [WGT_MEM_WIDTH-1:0] m2e_w_tenor;
  reg [ACC_MEM_WIDTH-1:0] m2e_a_tenor;
  reg [ACC_MEM_WIDTH-1:0] m2e_dst_idx;
  reg m2e_reg_reset;
  reg m2e_we;

  // EX Stage
  wire [ACC_MEM_WIDTH-1:0] e_gemm_res;

  // EX to WB registers
  reg [ACC_MEM_WIDTH-1:0] e_a_tensor;
  reg [INP_MEM_WIDTH-1:0] e_o_tensor;
  reg [ACC_MEM_WIDTH-1:0] e2w_dst_idx;
  reg e2w_we;


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
      u2i_we <= 0;
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
      u2i_we <= (insn[2:0] == 3'b010);
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
      i2m_we        <= 0;
    ///////////////////////
      i2m_dst_idx <= 0;
      i2m_src_idx <= 0;
      i2m_wgt_idx <= 0;
    end
    else begin
    ///////////////////////////////////
      i2m_reg_reset <= u2i_reg_reset;
      i2m_we        <= u2i_we;
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
      m2e_we        <= 0;
    ///////////////////////
      m2e_i_tenor <= 0;
      m2e_w_tenor <= 0;
      m2e_a_tenor <= 0;
    end else begin
    ///////////////////////////////////
      m2e_reg_reset <= i2m_reg_reset;
      m2e_dst_idx   <= i2m_dst_idx;
      m2e_we        <= i2m_we;
    ///////////////////////////////////
      m2e_i_tenor <= inp_mem_rd_data;
      m2e_w_tenor <= wgt_mem_rd_data;
      m2e_a_tenor <= (i2m_dst_idx == m2e_dst_idx) ? e_gemm_res : acc_mem_rd_data; // forwarding
    end
  end
  

/* ============================== EX Stage ============================== */
  gemm_op U_EX (
    .i_tensor(m2e_i_tenor),
    .w_tensor(m2e_w_tenor),
    .a_tensor(m2e_a_tenor),
    .o_tensor(e_gemm_res)
  );

  // --------------- reg E2W --------------- //
  always @(posedge clk, negedge rst) begin
    if (!rst) begin
    ///////////////////////
      e2w_dst_idx <= 0;
      e2w_we      <= 0;
    ///////////////////////
      e_a_tensor <= 0;
      e_o_tensor <= 0;
    end else begin
    ///////////////////////////////
      e2w_dst_idx <= m2e_dst_idx;
      e2w_we      <= m2e_we;
    ///////////////////////////////
      e_a_tensor <= (m2e_reg_reset) ? 0 : e_gemm_res;
      e_o_tensor <= e_gemm_res[INP_MEM_WIDTH-1:0];
    end
  end


/* ============================== WB Stage ============================== */
  // write enable signal setting
  // assign data
  assign acc_mem_wr_data = e_a_tensor;
  assign acc_mem_wr_addr = e2w_dst_idx;
  assign acc_mem_wr_we   = e2w_we;
  assign out_mem_wr_data = e_o_tensor;
  assign out_mem_wr_addr = e2w_dst_idx;
  assign out_mem_wr_we   = e2w_we;
  
endmodule
