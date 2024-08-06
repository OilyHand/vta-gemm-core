////////////////////////////////////
//    single port block memory    //
////////////////////////////////////
module bram_sp #(
  parameter WIDTH = 128  // memory data width
          , DEPTH = 1024 // memory depth
          , FILE = ""    // init file path
)(
  input  wire clk,
  input  wire en,
  input  wire we,
  input  wire addr,
  input  wire [WIDTH-1:0] din,
  output reg  [WIDTH-1:0] dout
);
  // memory
  reg [WIDTH-1:0] ram [DEPTH-1:0];

  // initialize
  integer i;
  initial begin
    for(i=0; i<DEPTH; i=i+1)
      ram[i] = 0;
    if(FILE != "") begin
      $readmemh(FILE, ram);
    end
  end

  // memory access
  always @(posedge clk)
  begin
    if(en) begin
      if(we) begin
        ram[addr] <= din;
      end
      dout <= ram[addr];
    end
  end

endmodule


//////////////////////////////////
//    dual port block memory    //
//////////////////////////////////
module bram_dp #(
  parameter WIDTH = 128  // memory data width
          , DEPTH = 1024 // memory depth
          , FILE = ""    // init file path
)(
  // port A
  input  wire clka,
  input  wire ena,
  input  wire wea,
  input  wire addra,
  input  wire [WIDTH-1:0] dina,
  output reg  [WIDTH-1:0] douta,
  // port B
  input  wire clkb,
  input  wire enb,
  input  wire web,
  input  wire addrb,
  input  wire [WIDTH-1:0] dinb,
  output reg  [WIDTH-1:0] doutb
);
  // memory
  reg [WIDTH-1:0] ram [DEPTH-1:0];

  // initialize
  integer i;
  initial begin
    for(i=0; i<DEPTH; i=i+1)
      ram[i] = 0;
    if(FILE != "") begin
      $readmemh(FILE, ram);
    end
  end

  // port A, memory access
  always @(posedge clka)
  begin
    if(ena) begin
      if (wea) begin
        ram[addra] <= dina;
      end
      douta <= ram[addra];
    end
  end

  // port B, memory access
  always @(posedge clkb)
  begin
    if(enb) begin
      if (web) begin
        ram[addrb] <= dinb;
      end
      doutb <= ram[addrb];
    end
  end

endmodule