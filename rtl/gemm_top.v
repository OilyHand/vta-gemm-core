module gemm_top#(
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
        , OUT_MEM_WREN  = 32
        , INP_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/inp_mem.mem"
        , WGT_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/wgt_mem.mem"
        , ACC_MEM_PATH = "/home/sjson/work/tvm_project/vta-gemm-core/sim/mem/acc_mem.mem"
)(
    input wire clk,
    input wire rst,
    input wire en
);

    wire [UOP_WIDTH-1:0]     uop;
    wire [UPC_WIDTH-1:0]     upc;
    wire [ACC_MEM_WIDTH-1:0] acc_mem_rd_data;
    wire [ACC_IDX_WIDTH-1:0] acc_mem_rd_addr;
    wire [ACC_MEM_WIDTH-1:0] acc_mem_wr_data;
    wire [ACC_IDX_WIDTH-1:0] acc_mem_wr_addr;
    wire [ACC_MEM_WREN-1:0]  acc_mem_wr_we;
    wire [INP_MEM_WIDTH-1:0] inp_mem_rd_data;
    wire [BUF_ADR_WIDTH-1:0] inp_mem_rd_addr;
    wire [WGT_MEM_WIDTH-1:0] wgt_mem_rd_data;
    wire [BUF_ADR_WIDTH-1:0] wgt_mem_rd_addr;
    wire [INP_MEM_WIDTH-1:0] out_mem_wr_data;
    wire [BUF_ADR_WIDTH-1:0] out_mem_wr_addr;
    wire [OUT_MEM_WREN-1:0]  out_mem_wr_we;

    reg [INS_WIDTH-1:0] insn;

    initial begin
        insn[2:0]     =  3'd2;
        insn[3]       =  5'd0;
        insn[4]       =  5'd0;
        insn[5]       =  5'd1;
        insn[6]       =  5'd0;
        insn[7]       =  5'd0;
        insn[20:8]    = 13'd1;  // uop_bgn
        insn[34:21]   = 14'd2;  // uop_end
        insn[48:35]   = 14'd16; // iter_out
        insn[62:49]   = 14'd1;  // iter_in
        insn[73:63]   = 11'd1;  // dst_factor_out
        insn[84:74]   = 11'd0;  // dst_factor_in
        insn[95:85]   = 11'd1;  // src_factor_out
        insn[106:96]  = 11'd0;  // src_factor_in
        insn[116:107] = 10'd0;  // wgt_factor_out
        insn[126:117] = 10'd0;  // wgt_factor_in
        insn[127]     =  1'b0;  // *unused
    end

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
        .ap_clk  (clk),
        .ap_rst_n(rst),
        .insn    (insn),
        .uop     (uop),
        .upc     (upc),
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
        .FILE(INP_MEM_PATH)
    ) inp_mem (
        .clk (clk),
        .rst (rst),
        .en  (en),
        .addr(inp_mem_rd_addr[2+:INP_IDX_WIDTH]),
        .dout(inp_mem_rd_data)
    );

    bram_sp #(
        .WIDTH(1024),
        .DEPTH(1024),
        .FILE(WGT_MEM_PATH)
    ) wgt_mem (
        .clk (clk),
        .rst (rst),
        .en  (en),
        .addr(wgt_mem_rd_addr[2+:WGT_IDX_WIDTH]),
        .dout(wgt_mem_rd_data)
    );

    bram_sp #(
        .WIDTH(UOP_WIDTH),
        .DEPTH(2048)
    ) uop_mem (
        .clk (clk),
        .rst (rst),
        .en  (en),
        .addr(upc),
        .dout(uop)
    );

    bram_dp #(
        .WIDTH(ACC_MEM_WIDTH),
        .DEPTH(2048)
    ) acc_mem (
        // port A
        .clka (clk),
        .ena  (en),
        .rsta (rst),
        .addra(acc_mem_rd_addr),
        .douta(acc_mem_rd_data),
        // port B
        .clkb (clk),
        .rstb (rst),
        .enb  (en),
        .web  (acc_mem_wr_we),
        .addrb(acc_mem_wr_addr),
        .dinb (acc_mem_wr_data)
    );

endmodule