module tb_mem ();

////////////////////////////////////////////////////////////////////////////////////////////////////
//    parameters    //
//////////////////////

parameter UOP_WIDTH     = 32
        , UPC_WIDTH     = 13
        , INS_WIDTH     = 128
        , INP_WIDTH     = 8
        , WGT_WIDTH     = 8
        , ACC_WIDTH     = 32
        , ACC_MEM_WIDTH = ACC_WIDTH*16
        , INP_MEM_WIDTH = INP_WIDTH*16
        , WGT_MEM_WIDTH = WGT_WIDTH*16*16
        , BUF_ADR_WIDTH = 32
        , ACC_IDX_WIDTH = 12
        , INP_IDX_WIDTH = 12
        , WGT_IDX_WIDTH = 11
        , ACC_MEM_WREN  = 64
        , OUT_MEM_WREN  = 32;




////////////////////////////////////////////////////////////////////////////////////////////////////
//    declaration    //
///////////////////////

reg clk, rst;

wire [UOP_WIDTH-1:0] uop;
reg  [UPC_WIDTH-1:0] upc;

wire [INP_MEM_WIDTH-1:0] inp_mem_rd_data;
reg  [BUF_ADR_WIDTH-1:0] inp_mem_rd_addr;

wire [WGT_MEM_WIDTH-1:0] wgt_mem_rd_data;
reg  [BUF_ADR_WIDTH-1:0] wgt_mem_rd_addr;




////////////////////////////////////////////////////////////////////////////////////////////////////
//    data checking    //
/////////////////////////

wire [INP_WIDTH-1:0] inp_data [15:0];
wire [WGT_WIDTH-1:0] wgt_data [0:15][15:0];

genvar i,j,k;
generate
begin
  for (i = 0; i < 16; i = i+1)
    for (j = 0; j < 16; j = j+1)
      assign wgt_data[15-i][j] = wgt_mem_rd_data[(i * 16 + j) * 8 +: 8];

  for (k = 0; k < 16; k = k+1) begin
    assign inp_data[k] = inp_mem_rd_data[k*8 +: 8];
  end
end
endgenerate




////////////////////////////////////////////////////////////////////////////////////////////////////
//    Memory Access    //
/////////////////////////

uop_mem_0 uop_mem (
  .clka (clk),
  .rsta (rst),
  .ena  (1'b1),
  .addra(upc),
  .douta(uop)
);

inp_mem_0 inp_mem (
  .clka (clk),
  .rsta (rst),
  .ena  (1'b1),
  .addra(inp_mem_rd_addr),
  .douta(inp_mem_rd_data)
);

wgt_mem_0 wgt_mem0 (
  .clka (clk),
  .rsta (rst),
  .ena  (1'b1),
  .addra(wgt_mem_rd_addr),
  .douta(wgt_mem_rd_data[2047:1024])
);

wgt_mem_1 wgt_mem1 (
  .clka (clk),
  .rsta (rst),
  .ena  (1'b1),
  .addra(wgt_mem_rd_addr),
  .douta(wgt_mem_rd_data[1023:0])
);




////////////////////////////////////////////////////////////////////////////////////////////////////
//    Running Simulation    //
//////////////////////////////

localparam count = 1, inp_offset = 16, wgt_offset = 128;

always #5 clk <= ~clk;

always @(posedge clk) begin
  upc <= upc + count;
  inp_mem_rd_addr <= inp_mem_rd_addr + inp_offset;
  wgt_mem_rd_addr <= wgt_mem_rd_addr + wgt_offset;
end

initial begin
  #0
    clk = 0; rst = 1;
    upc = 0;
    inp_mem_rd_addr = 0;
    wgt_mem_rd_addr = 0;
  #1
    rst = 0;

  #9999
    $finish;
end

endmodule