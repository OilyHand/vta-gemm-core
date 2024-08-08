////////////////////////////////////
//    single port block memory    //
////////////////////////////////////
module bram_sp #(
    parameter WIDTH = 128  // memory data width
            , DEPTH = 1024 // memory depth
            , ADDR  = 10
            , FILE = ""    // init file path
)(
    input  wire clk,
    input  wire rst,
    input  wire en,
    input  wire we,
    input  wire [ADDR-1:0] addr,
    input  wire [WIDTH-1:0] din,
    output reg  [WIDTH-1:0] dout
);
    // memory
    (* ram_style = "block" *)
    reg [WIDTH-1:0] ram [0:DEPTH-1];

    // memory access
    integer i;
    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            // initialize memory
            for(i=0; i<DEPTH; i=i+1) begin
                ram[i] = 0;
            end
            // load init memory data
            if(FILE != "") begin
                $readmemh(FILE, ram);
            end
            dout <= 0;
        end else if(en) begin
            // write data
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
    parameter WIDTH = 128,  // memory data width
    parameter DEPTH = 1024, // memory depth
    parameter ADDR  = 10,
    parameter FILE  = ""    // init file path
)(
    // port A
    input  wire clka,
    input  wire rsta,
    input  wire ena,
    input  wire wea,
    input  wire [ADDR-1:0]  addra,
    input  wire [WIDTH-1:0] dina,
    output reg  [WIDTH-1:0] douta,
    // port B
    input  wire clkb,
    input  wire rstb,
    input  wire enb,
    input  wire web,
    input  wire [ADDR-1:0] addrb,
    input  wire [WIDTH-1:0] dinb,
    output reg  [WIDTH-1:0] doutb
);
    // memory
    (* ram_style = "block" *)
    reg [WIDTH-1:0] ram [0:DEPTH-1];

    integer i;
    // port A, memory access
    always @(posedge clka, negedge rsta) begin
        if(!rsta) begin
            // initialize memory
            for(i=0; i<DEPTH; i=i+1) begin
                ram[i] = 0;
            end
            // load init memory data
            if(FILE != "") begin
                $readmemh(FILE, ram);
            end
            douta <= 0;
        end else if(ena) begin
            // write action
            if(wea) begin
                ram[addra] <= dina;
            end
            douta <= ram[addra];
        end
    end

  // port B, memory access
    always @(posedge clkb, negedge rstb) begin
        if(!rstb) begin
            // initialize memory
            for(i=0; i<DEPTH; i=i+1) begin
                ram[i] = 0;
            end
            // load init memory data
            if(FILE != "") begin
                $readmemh(FILE, ram);
            end
            doutb <= 0;
        end else if(enb) begin
            // write action
            if(web) begin
                ram[addrb] <= dinb;
            end
            doutb <= ram[addrb];
        end
    end

endmodule