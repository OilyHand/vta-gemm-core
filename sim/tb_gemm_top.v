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

    // file path
    parameter
          INP_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/inp_mem.mem"
        , WGT_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/wgt_mem.mem";


    // control signals
    reg clk, rst, en;

    // uop related
    reg [INS_WIDTH-1:0] insn;
    reg [UOP_WIDTH-1:0] uop_push_val;
    reg [UPC_WIDTH-1:0] uop_push_addr;
    reg uop_we;

    // nets
    wire [UOP_WIDTH-1:0]      uop;
    wire [UPC_WIDTH-1:0]      upc;
    wire [ACC_MEM_WIDTH-1:0]  acc_mem_rd_data;
    wire [ACC_IDX_WIDTH-1:0]  acc_mem_rd_addr;
    wire [ACC_MEM_WIDTH-1:0]  acc_mem_wr_data;
    wire [ACC_IDX_WIDTH-1:0]  acc_mem_wr_addr;
    wire [ACC_MEM_WREN-1:0]   acc_mem_wr_we;
    wire [INP_MEM_WIDTH-1:0]  inp_mem_rd_data;
    wire [BUF_ADR_WIDTH-1:0]  inp_mem_rd_addr;
    wire [WGT_MEM_WIDTH-1:0]  wgt_mem_rd_data;
    wire [BUF_ADR_WIDTH-1:0]  wgt_mem_rd_addr;
    wire [INP_MEM_WIDTH-1:0]  out_mem_wr_data;
    wire [BUF_ADR_WIDTH-1:0]  out_mem_wr_addr;
    wire [OUT_MEM_WREN-1:0]   out_mem_wr_we;

    // insn fields
    wire [2:0]  insn_0_opcode         = insn[2:0];
    wire        insn_1_pop_prev_dep   = insn[3];
    wire        insn_2_pop_next_dep   = insn[4];
    wire        insn_3_push_prev_dep  = insn[5];
    wire        insn_4_push_next_dep  = insn[6];
    wire        insn_5_reset_reg      = insn[7];
    wire [12:0] insn_6_uop_bgn        = insn[20:8];
    wire [13:0] insn_7_uop_end        = insn[34:21];
    wire [13:0] insn_8_iter_out       = insn[48:35];
    wire [13:0] insn_9_iter_in        = insn[62:49];
    wire [10:0] insn_a_dst_factor_out = insn[73:63];
    wire [10:0] insn_b_dst_factor_in  = insn[84:74];
    wire [10:0] insn_c_src_factor_out = insn[95:85];
    wire [10:0] insn_d_src_factor_in  = insn[106:96];
    wire [9:0]  insn_e_wgt_factor_out = insn[116:107];
    wire [9:0]  insn_f_wgt_factor_in  = insn[126:117];

    integer counter;
    initial begin
        counter = 0;
    end

    always @(posedge clk)
        counter = counter+1;

    /////////////////////////
    //    instantiation    //
    /////////////////////////

    /** gemm module **/
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
        .ap_clk         (clk),
        .ap_rst_n       (rst),
        .insn           (insn),
        .uop            (uop),
        .upc            (upc),
        .acc_mem_rd_data(acc_mem_rd_data),
        .acc_mem_rd_addr(acc_mem_rd_addr),
        .acc_mem_wr_data(acc_mem_wr_data),
        .acc_mem_wr_addr(acc_mem_wr_addr),
        .acc_mem_wr_we  (acc_mem_wr_we),
        .inp_mem_rd_data(inp_mem_rd_data),
        .inp_mem_rd_addr(inp_mem_rd_addr),
        .wgt_mem_rd_data(wgt_mem_rd_data),
        .wgt_mem_rd_addr(wgt_mem_rd_addr),
        .out_mem_wr_data(out_mem_wr_data),
        .out_mem_wr_addr(out_mem_wr_addr),
        .out_mem_wr_we  (out_mem_wr_we)
    );

    /** memory modules **/
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
        // $dumpfile("result.vcd");
        // $dumpvars(0);
    end

endmodule