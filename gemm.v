module gemm (
  input wire ap_clk, ap_rst_n,
  
  // instruction  
  input wire [127:0]  inst,
  
  // micro-op access
  input wire [31:0]   uop,
  output reg [12:0]   upc,
  
  // buffer access
  input wire [127:0]  inp_mem,
  input wire [2047:0] wgt_mem,
  output reg [15:0]   out_mem,
  
  output wire inp_mem_addr,
  output wire wgt_mem_addr,
  output wire out_mem_addr,
  
  // register file access
  input wire [31:0]   acc_mem_in,
  output reg [31:0]   acc_mem_out,
  output reg [12:0]   acc_mem_addr
);
  
  reg [31:0]   uop_reg; // micro-op register
  
  reg [127:0]  i_tensor; // input tensor
  reg [127:0]  a_tensor; // accumulator tensor
  reg [2047:0] w_tensor; // weight tensor
  reg [127:0]  o_tensor; // output tensor
  // uop read
  
    // index computing
  
  // tensor read
  
  
  // gemm operation
  
  
  // write back
  	      
endmodule
