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

`timescale 1ns/1ps

module tb_gemm_top ();
    // width parameters
    parameter
          UOP_WIDTH     = 32
        , UPC_WIDTH     = 13
        , INS_WIDTH     = 128
        , INP_WIDTH     = 8
        , WGT_WIDTH     = 8
        , ACC_WIDTH     = 32
        , INP_DEPTH     = 16
        , WGT_DEPTH     = 16*16
        , ACC_DEPTH     = 16
        , ACC_MEM_WIDTH = ACC_WIDTH*ACC_DEPTH
        , INP_MEM_WIDTH = INP_WIDTH*INP_DEPTH
        , WGT_MEM_WIDTH = WGT_WIDTH*WGT_DEPTH
        , BUF_ADR_WIDTH = 32
        , ACC_IDX_WIDTH = 12
        , INP_IDX_WIDTH = 12
        , WGT_IDX_WIDTH = 11
        , ACC_MEM_WREN  = 64
        , OUT_MEM_WREN  = 32;

    /**** file path ****/
    parameter
          INP_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/inp_mem.mem"
        , WGT_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/wgt_mem.mem";

    /**** control signals ****/
    reg ap_clk;
    reg ap_rst;

    /**** nets ****/
    wire [INS_WIDTH-1:0]     insn,
    wire [UOP_WIDTH-1:0]     uop,
    wire                     uop_ce,
    wire [UPC_WIDTH-1:0]     upc,
    wire [ACC_IDX_WIDTH-1:0] acc_mem_rd_addr,
    wire                     acc_mem_rd_ce,
    wire [ACC_MEM_WREN-1:0]  acc_mem_rd_we,
    wire                     acc_mem_rd_data_out,
    wire [ACC_MEM_WIDTH-1:0] acc_mem_rd_data_in,
    wire [ACC_IDX_WIDTH-1:0] acc_mem_wr_addr,
    wire                     acc_mem_wr_ce,
    wire [ACC_MEM_WREN-1:0]  acc_mem_wr_we,
    wire [ACC_MEM_WIDTH-1:0] acc_mem_wr_data_out,
    wire [ACC_MEM_WIDTH-1:0] acc_mem_wr_data_in,
    wire [INP_MEM_WIDTH-1:0] inp_mem_rd_data,
    wire                     inp_mem_rd_ce,
    wire [BUF_ADR_WIDTH-1:0] inp_mem_rd_addr,
    wire [WGT_MEM_WIDTH-1:0] wgt_mem_rd_data,
    wire                     wgt_mem_rd_ce,
    wire [BUF_ADR_WIDTH-1:0] wgt_mem_rd_addr,
    wire [BUF_ADR_WIDTH-1:0] out_mem_wr_addr,
    wire                     out_mem_wr_ce,
    wire [INP_MEM_WIDTH-1:0] out_mem_wr_data,
    wire [OUT_MEM_WREN-1:0]  out_mem_wr_we

////////////////////////////////////////////////////////////////////////////////
//                               instantialtion                               //
////////////////////////////////////////////////////////////////////////////////
    gemm #(
        .UOP_WIDTH(UOP_WIDTH),
        .UPC_WIDTH(UPC_WIDTH),
        .INS_WIDTH(INS_WIDTH),
        .INP_WIDTH(INP_WIDTH),
        .WGT_WIDTH(WGT_WIDTH),
        .ACC_WIDTH(ACC_WIDTH),
        .INP_DEPTH(INP_DEPTH),
        .WGT_DEPTH(WGT_DEPTH),
        .ACC_DEPTH(ACC_DEPTH)
    ) U_GEMM (
        // control signals
        .ap_clk     (ap_clk),
        .ap_rst     (ap_rst),
        .ap_ce      (),
        .ap_start   (),
        .ap_continue(),
        .ap_idle    (),
        .ap_done    (),
        .ap_ready   (),
        // instruction
        .insn(insn),
        // memory ports
        .uop                (uop),
        .uop_ce             (uop_ce),
        .upc                (upc),
        .acc_mem_rd_addr    (acc_mem_rd_addr),
        .acc_mem_rd_ce      (acc_mem_rd_ce),
        .acc_mem_rd_we      (acc_mem_rd_we),
        .acc_mem_rd_data_out(acc_mem_rd_data_out),
        .acc_mem_rd_data_in (acc_mem_rd_data_in),
        .acc_mem_wr_addr    (acc_mem_wr_addr),
        .acc_mem_wr_ce      (acc_mem_wr_ce),
        .acc_mem_wr_we      (acc_mem_wr_we),
        .acc_mem_wr_data_out(acc_mem_wr_data_out),
        .acc_mem_wr_data_in (acc_mem_wr_data_in),
        .inp_mem_rd_data    (inp_mem_rd_data),
        .inp_mem_rd_ce      (inp_mem_rd_ce),
        .inp_mem_rd_addr    (inp_mem_rd_addr),
        .wgt_mem_rd_data    (wgt_mem_rd_data),
        .wgt_mem_rd_ce      (wgt_mem_rd_ce),
        .wgt_mem_rd_addr    (wgt_mem_rd_addr),
        .out_mem_wr_addr    (out_mem_wr_addr),
        .out_mem_wr_ce      (out_mem_wr_ce),
        .out_mem_wr_data    (out_mem_wr_data),
        .out_mem_wr_we      (out_mem_wr_we)
    );

////////////////////////////////////////////////////////////////////////////////
//                                   memory                                   //
////////////////////////////////////////////////////////////////////////////////
    bram_sp #(
        .WIDTH(INP_MEM_WIDTH),
        .DEPTH(2048),
        .ADDR(INP_IDX_WIDTH),
        .FILE(INP_MEM_PATH)
    ) inp_mem (
        .clk (clk),
        .en  (en),
        .rst (rst),
        .addr(inp_mem_rd_addr[2+:INP_IDX_WIDTH]),
        .dout(inp_mem_rd_data)
    );

    bram_sp #(
        .WIDTH(WGT_MEM_WIDTH),
        .DEPTH(1024),
        .ADDR(WGT_IDX_WIDTH),
        .FILE(WGT_MEM_PATH)
    ) wgt_mem (
        .clk (clk),
        .en  (en),
        .rst (rst),
        .addr(wgt_mem_rd_addr[2+:INP_IDX_WIDTH]),
        .dout(wgt_mem_rd_data)
    );

    bram_sp #(
        .WIDTH(INP_MEM_WIDTH),
        .DEPTH(1024),
        .ADDR(INP_IDX_WIDTH)
    ) out_mem (
        .clk (clk),
        .en  (en),
        .rst (rst),
        .we  (out_mem_wr_we),
        .addr(out_mem_wr_addr[2+:INP_IDX_WIDTH]),
        .din (out_mem_wr_data)
    );

    bram_sp #(
        .WIDTH(UOP_WIDTH),
        .DEPTH(2),
        .ADDR(UPC_WIDTH)
    ) uop_mem (
        .clk (clk),
        .en  (en),
        .rst (rst),
        .addr(upc),
        .dout(uop)
    );

    bram_dp #(
        .WIDTH(ACC_MEM_WIDTH),
        .DEPTH(2048),
        .ADDR(ACC_IDX_WIDTH)
    ) acc_mem (
        // port A
        .clka (clk),
        .ena  (en),
        .rsta (rst),
        .addra(acc_mem_rd_addr),
        .douta(acc_mem_rd_data),
        // port B
        .clkb (clk),
        .enb  (en),
        .rstb (rst),
        .web  (acc_mem_wr_we),
        .addrb(acc_mem_wr_addr),
        .dinb (acc_mem_wr_data)
    );

    initial begin
        $dumpfile("result.vcd");
        $dumpvars(0);
    end

endmodule