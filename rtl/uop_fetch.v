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

module uop_fetch #(
  parameter INS_WIDTH = 128
          , UPC_WIDTH = 13
          , ACC_IDX_WIDTH = 11
          , INP_IDX_WIDTH = 11
          , WGT_IDX_WIDTH = 10
)(
  input  wire                     clk, // system clock
  input  wire                     rst, // async active-low reset
  input  wire [INS_WIDTH-1:0]     insn,
  output reg  [UPC_WIDTH-1:0]     upc,
  output reg  [ACC_IDX_WIDTH-1:0] dst_offset_out,
  output reg  [INP_IDX_WIDTH-1:0] src_offset_out,
  output reg  [WGT_IDX_WIDTH-1:0] wgt_offset_out,
  output reg  [ACC_IDX_WIDTH-1:0] dst_offset_in,
  output reg  [INP_IDX_WIDTH-1:0] src_offset_in,
  output reg  [WGT_IDX_WIDTH-1:0] wgt_offset_in
);

///////////////////////////////////////////////////////////////////////////////
  // instruction decode
  wire [12:0] insn_uop_bgn        = insn[20:8];
  wire [12:0] insn_uop_end        = insn[34:21];
  wire [13:0] insn_iter_out       = insn[48:35];
  wire [13:0] insn_iter_in        = insn[62:49];
  wire [10:0] insn_dst_factor_out = insn[73:63];
  wire [10:0] insn_dst_factor_in  = insn[84:74];
  wire [10:0] insn_src_factor_out = insn[95:85];
  wire [10:0] insn_src_factor_in  = insn[106:96];
  wire [9:0]  insn_wgt_factor_out = insn[116:107];
  wire [9:0]  insn_wgt_factor_in  = insn[126:117];

///////////////////////////////////////////////////////////////////////////////
  wire [UPC_WIDTH-1:0] upc_next = upc + 1;
  
  always @(posedge clk, negedge rst) begin
    // reset
    if(!rst) begin
      upc      <= 0;
    // count up
    end else begin
      // micro-op counter
      if (upc_next == insn_uop_end)
        upc <= insn_uop_bgn;
      else
        upc <= upc_next;
    end
  end

///////////////////////////////////////////////////////////////////////////////
  reg  [13:0] iter_in, iter_out; // iteration counters
  wire [13:0] iter_out_next = iter_out + 1;
  wire [13:0] iter_in_next  = iter_in + 1;

  wire isEnd_upc      = (upc_next      == insn_uop_end);
  wire isEnd_iter_in  = (iter_in_next  == insn_iter_in);
  wire isEnd_iter_out = (iter_out_next == insn_iter_out);

  always @(posedge clk, negedge rst) begin
    // reset
    if(!rst) begin
      iter_out <= 0;
      iter_in  <= 0;
    // count up
    end else begin
      // outer iteration increment
      if (isEnd_iter_in && isEnd_upc)
        if (isEnd_iter_out)
          iter_out <= 0;
        else
          iter_out <= iter_out_next;
      else 
        iter_out <= iter_out;
      
      // inner iteration increment
      if (isEnd_upc)
        if (isEnd_iter_in)
          iter_in <= 0;
        else
          iter_in <= iter_in_next;
      else 
        iter_in <= iter_in;
    end
  end

///////////////////////////////////////////////////////////////////////////////
  // index decode factors
  always @(posedge clk, negedge rst) begin
    // reset
    if(!rst) begin
        dst_offset_out <= 0;
        src_offset_out <= 0;
        wgt_offset_out <= 0;
        dst_offset_in  <= 0;
        src_offset_in  <= 0;
        wgt_offset_in  <= 0;
    end else begin
      // offset_out increment
      if (isEnd_iter_in && isEnd_upc) begin
        if (isEnd_iter_out) begin
          dst_offset_out <= 0;
          src_offset_out <= 0;
          wgt_offset_out <= 0;
        end else begin
          dst_offset_out <= dst_offset_out + insn_dst_factor_out;
          src_offset_out <= src_offset_out + insn_src_factor_out;
          wgt_offset_out <= wgt_offset_out + insn_wgt_factor_out;
        end
      end else begin
        dst_offset_out <= dst_offset_out;
        src_offset_out <= src_offset_out;
        wgt_offset_out <= wgt_offset_out;
      end

      // offset_in increment
      if (isEnd_upc)begin
        if (isEnd_iter_in) begin
          dst_offset_in <= 0;
          src_offset_in <= 0;
          wgt_offset_in <= 0;
        end else begin
          dst_offset_in <= dst_offset_in + insn_dst_factor_in;
          src_offset_in <= src_offset_in + insn_src_factor_in;
          wgt_offset_in <= wgt_offset_in + insn_wgt_factor_in;
        end
      end
      else begin
        dst_offset_in <= dst_offset_in;
        src_offset_in <= src_offset_in;
        wgt_offset_in <= wgt_offset_in;
      end
    end
  end

endmodule
