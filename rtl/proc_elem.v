(* use_dsp = "yes" *)
module mac_dsp #(
  parameter INP_WIDTH=8
          , WGT_WIDTH=8
          , ACC_WIDTH=32
)(
    input  wire [INP_WIDTH-1:0] inp
  , input  wire [WGT_WIDTH-1:0] wgt
  , input  wire [ACC_WIDTH-1:0] acc
  , output wire [ACC_WIDTH-1:0] sum
);
    wire signed [ACC_WIDTH-1:0] a;
    wire signed [ACC_WIDTH-1:0] b;
    wire signed [ACC_WIDTH-1:0] c;
    wire signed [ACC_WIDTH-1:0] mul;
    
    assign a = $signed(inp);
    assign b = $signed(wgt);
    assign c = $signed(acc);
    assign mul = a * b;
    assign sum = mul + c;

endmodule

//=======================================================

(* use_dsp = "no" *)
module mac_lut #(
  parameter INP_WIDTH=8
          , WGT_WIDTH=8
          , ACC_WIDTH=32
)(
    input  wire [INP_WIDTH-1:0] inp
  , input  wire [WGT_WIDTH-1:0] wgt
  , input  wire [ACC_WIDTH-1:0] acc
  , output wire [ACC_WIDTH-1:0] sum
);
    wire signed [ACC_WIDTH-1:0] a;
    wire signed [ACC_WIDTH-1:0] b;
    wire signed [ACC_WIDTH-1:0] c;
    wire signed [ACC_WIDTH-1:0] mul;
    
    assign a = $signed(inp);
    assign b = $signed(wgt);
    assign c = $signed(acc);
    assign mul = a * b;
    assign sum = mul + c;

endmodule