module u2i_reg #(
  parameter UOP_WIDTH   = 32
          , A_IDX_WIDTH = 12
          , I_IDX_WIDTH = 12
          , W_IDX_WIDTH = 11
)(
  input  wire [UOP_WIDTH-1:0] uop,
  input  wire [A_IDX_WIDTH-2:0] u_dst_offset_out,
  input  wire [I_IDX_WIDTH-2:0] u_src_offset_out,
  input  wire [W_IDX_WIDTH-2:0] u_wgt_offset_out,
  input  wire [A_IDX_WIDTH-2:0] u_dst_offset_in,
  input  wire [I_IDX_WIDTH-2:0] u_src_offset_in,
  input  wire [W_IDX_WIDTH-2:0] u_wgt_offset_in
  output reg  [UOP_WIDTH-1:0] u2i_uop;
  output reg  [A_IDX_WIDTH-2:0] u2i_dst_offset_out;
  output reg  [I_IDX_WIDTH-2:0] u2i_src_offset_out;
  output reg  [W_IDX_WIDTH-2:0] u2i_wgt_offset_out;
  output reg  [A_IDX_WIDTH-2:0] u2i_dst_offset_in;
  output reg  [I_IDX_WIDTH-2:0] u2i_src_offset_in; 
  output reg  [W_IDX_WIDTH-2:0] u2i_wgt_offset_in;
  output reg  u2i_reg_reset;
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

endmodule