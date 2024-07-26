module systolic_row_lut #(
  parameter
    INP_WIDTH = 8,
    WGT_WIDTH = 8,
    ACC_WIDTH = 32,
    IT_WIDTH  = INP_WIDTH * 16,
    WT_WIDTH  = WGT_WIDTH * 16,
    AT_WIDTH  = ACC_WIDTH * 16
)(
  input wire  [IT_WIDTH-1:0] i_row,
  input wire  [WT_WIDTH-1:0] w_row,
  input wire  [AT_WIDTH-1:0] a_row,
  output wire [AT_WIDTH-1:0] o_row
);

  mac_lut U_mac_lut_00 (
    .inp(i_row[INP_WIDTH-1:0]),
    .wgt(w_row[WGT_WIDTH-1:0]),
    .acc(a_row[ACC_WIDTH-1:0]),
    .sum(o_row[ACC_WIDTH-1:0])
  );

  mac_lut U_mac_lut_01 (
    .inp(i_row[INP_WIDTH*2-1:INP_WIDTH]),
    .wgt(w_row[WGT_WIDTH*2-1:WGT_WIDTH]),
    .acc(a_row[ACC_WIDTH*2-1:ACC_WIDTH]),
    .sum(o_row[ACC_WIDTH*2-1:ACC_WIDTH])
  );

  mac_lut U_mac_lut_02 (
    .inp(i_row[INP_WIDTH*3-1:INP_WIDTH*2]),
    .wgt(w_row[WGT_WIDTH*3-1:WGT_WIDTH*2]),
    .acc(a_row[ACC_WIDTH*3-1:ACC_WIDTH*2]),
    .sum(o_row[ACC_WIDTH*3-1:ACC_WIDTH*2])
  );

  mac_lut U_mac_lut_03 (
    .inp(i_row[INP_WIDTH*4-1:INP_WIDTH*3]),
    .wgt(w_row[WGT_WIDTH*4-1:WGT_WIDTH*3]),
    .acc(a_row[ACC_WIDTH*4-1:ACC_WIDTH*3]),
    .sum(o_row[ACC_WIDTH*4-1:ACC_WIDTH*3])
  );

  mac_lut U_mac_lut_04 (
    .inp(i_row[INP_WIDTH*5-1:INP_WIDTH*4]),
    .wgt(w_row[WGT_WIDTH*5-1:WGT_WIDTH*4]),
    .acc(a_row[ACC_WIDTH*5-1:ACC_WIDTH*4]),
    .sum(o_row[ACC_WIDTH*5-1:ACC_WIDTH*4])
  );

  mac_lut U_mac_lut_05 (
    .inp(i_row[INP_WIDTH*6-1:INP_WIDTH*5]),
    .wgt(w_row[WGT_WIDTH*6-1:WGT_WIDTH*5]),
    .acc(a_row[ACC_WIDTH*6-1:ACC_WIDTH*5]),
    .sum(o_row[ACC_WIDTH*6-1:ACC_WIDTH*5])
  );

  mac_lut U_mac_lut_06 (
    .inp(i_row[INP_WIDTH*7-1:INP_WIDTH*6]),
    .wgt(w_row[WGT_WIDTH*7-1:WGT_WIDTH*6]),
    .acc(a_row[ACC_WIDTH*7-1:ACC_WIDTH*6]),
    .sum(o_row[ACC_WIDTH*7-1:ACC_WIDTH*6])
  );

  mac_lut U_mac_lut_07 (
    .inp(i_row[INP_WIDTH*8-1:INP_WIDTH*7]),
    .wgt(w_row[WGT_WIDTH*8-1:WGT_WIDTH*7]),
    .acc(a_row[ACC_WIDTH*8-1:ACC_WIDTH*7]),
    .sum(o_row[ACC_WIDTH*8-1:ACC_WIDTH*7])
  );

  mac_lut U_mac_lut_08 (
    .inp(i_row[INP_WIDTH*9-1:INP_WIDTH*8]),
    .wgt(w_row[WGT_WIDTH*9-1:WGT_WIDTH*8]),
    .acc(a_row[ACC_WIDTH*9-1:ACC_WIDTH*8]),
    .sum(o_row[ACC_WIDTH*9-1:ACC_WIDTH*8])
  );

  mac_lut U_mac_lut_09 (
    .inp(i_row[INP_WIDTH*10-1:INP_WIDTH*9]),
    .wgt(w_row[WGT_WIDTH*10-1:WGT_WIDTH*9]),
    .acc(a_row[ACC_WIDTH*10-1:ACC_WIDTH*9]),
    .sum(o_row[ACC_WIDTH*10-1:ACC_WIDTH*9])
  );

  mac_lut U_mac_lut_10 (
    .inp(i_row[INP_WIDTH*11-1:INP_WIDTH*10]),
    .wgt(w_row[WGT_WIDTH*11-1:WGT_WIDTH*10]),
    .acc(a_row[ACC_WIDTH*11-1:ACC_WIDTH*10]),
    .sum(o_row[ACC_WIDTH*11-1:ACC_WIDTH*10])
  );

  mac_lut U_mac_lut_11 (
    .inp(i_row[INP_WIDTH*12-1:INP_WIDTH*11]),
    .wgt(w_row[WGT_WIDTH*12-1:WGT_WIDTH*11]),
    .acc(a_row[ACC_WIDTH*12-1:ACC_WIDTH*11]),
    .sum(o_row[ACC_WIDTH*12-1:ACC_WIDTH*11])
  );

  mac_lut U_mac_lut_12 (
    .inp(i_row[INP_WIDTH*13-1:INP_WIDTH*12]),
    .wgt(w_row[WGT_WIDTH*13-1:WGT_WIDTH*12]),
    .acc(a_row[ACC_WIDTH*13-1:ACC_WIDTH*12]),
    .sum(o_row[ACC_WIDTH*13-1:ACC_WIDTH*12])
  );

  mac_lut U_mac_lut_13 (
    .inp(i_row[INP_WIDTH*14-1:INP_WIDTH*13]),
    .wgt(w_row[WGT_WIDTH*14-1:WGT_WIDTH*13]),
    .acc(a_row[ACC_WIDTH*14-1:ACC_WIDTH*13]),
    .sum(o_row[ACC_WIDTH*14-1:ACC_WIDTH*13])
  );

  mac_lut U_mac_lut_14 (
    .inp(i_row[INP_WIDTH*15-1:INP_WIDTH*14]),
    .wgt(w_row[WGT_WIDTH*15-1:WGT_WIDTH*14]),
    .acc(a_row[ACC_WIDTH*15-1:ACC_WIDTH*14]),
    .sum(o_row[ACC_WIDTH*15-1:ACC_WIDTH*14])
  );

  mac_lut U_mac_lut_15 (
    .inp(i_row[INP_WIDTH*16-1:INP_WIDTH*15]),
    .wgt(w_row[WGT_WIDTH*16-1:WGT_WIDTH*15]),
    .acc(a_row[ACC_WIDTH*16-1:ACC_WIDTH*15]),
    .sum(o_row[ACC_WIDTH*16-1:ACC_WIDTH*15])
  );

endmodule

//-----------------------------------------------------------------------------

module systolic_row_dsp #(
  parameter INP_WIDTH = 8
          , WGT_WIDTH = 8
          , ACC_WIDTH = 32 
          , IT_WIDTH  = INP_WIDTH * 16
          , WT_WIDTH  = WGT_WIDTH * 16
          , AT_WIDTH  = ACC_WIDTH * 16
)(
    input  wire [IT_WIDTH-1:0] i_row
  , input  wire [WT_WIDTH-1:0] w_row
  , input  wire [AT_WIDTH-1:0] a_row
  , output wire [AT_WIDTH-1:0] o_row
);

  mac_dsp U_mac_dsp_00 (
    .inp(i_row[INP_WIDTH-1:0]),
    .wgt(w_row[WGT_WIDTH-1:0]),
    .acc(a_row[ACC_WIDTH-1:0]),
    .sum(o_row[ACC_WIDTH-1:0])
  );

  mac_dsp U_mac_dsp_01 (
    .inp(i_row[INP_WIDTH*2-1:INP_WIDTH]),
    .wgt(w_row[WGT_WIDTH*2-1:WGT_WIDTH]),
    .acc(a_row[ACC_WIDTH*2-1:ACC_WIDTH]),
    .sum(o_row[ACC_WIDTH*2-1:ACC_WIDTH])
  );

  mac_dsp U_mac_dsp_02 (
    .inp(i_row[INP_WIDTH*3-1:INP_WIDTH*2]),
    .wgt(w_row[WGT_WIDTH*3-1:WGT_WIDTH*2]),
    .acc(a_row[ACC_WIDTH*3-1:ACC_WIDTH*2]),
    .sum(o_row[ACC_WIDTH*3-1:ACC_WIDTH*2])
  );

  mac_dsp U_mac_dsp_03 (
    .inp(i_row[INP_WIDTH*4-1:INP_WIDTH*3]),
    .wgt(w_row[WGT_WIDTH*4-1:WGT_WIDTH*3]),
    .acc(a_row[ACC_WIDTH*4-1:ACC_WIDTH*3]),
    .sum(o_row[ACC_WIDTH*4-1:ACC_WIDTH*3])
  );

  mac_dsp U_mac_dsp_04 (
    .inp(i_row[INP_WIDTH*5-1:INP_WIDTH*4]),
    .wgt(w_row[WGT_WIDTH*5-1:WGT_WIDTH*4]),
    .acc(a_row[ACC_WIDTH*5-1:ACC_WIDTH*4]),
    .sum(o_row[ACC_WIDTH*5-1:ACC_WIDTH*4])
  );

  mac_dsp U_mac_dsp_05 (
    .inp(i_row[INP_WIDTH*6-1:INP_WIDTH*5]),
    .wgt(w_row[WGT_WIDTH*6-1:WGT_WIDTH*5]),
    .acc(a_row[ACC_WIDTH*6-1:ACC_WIDTH*5]),
    .sum(o_row[ACC_WIDTH*6-1:ACC_WIDTH*5])
  );

  mac_dsp U_mac_dsp_06 (
    .inp(i_row[INP_WIDTH*7-1:INP_WIDTH*6]),
    .wgt(w_row[WGT_WIDTH*7-1:WGT_WIDTH*6]),
    .acc(a_row[ACC_WIDTH*7-1:ACC_WIDTH*6]),
    .sum(o_row[ACC_WIDTH*7-1:ACC_WIDTH*6])
  );

  mac_dsp U_mac_dsp_07 (
    .inp(i_row[INP_WIDTH*8-1:INP_WIDTH*7]),
    .wgt(w_row[WGT_WIDTH*8-1:WGT_WIDTH*7]),
    .acc(a_row[ACC_WIDTH*8-1:ACC_WIDTH*7]),
    .sum(o_row[ACC_WIDTH*8-1:ACC_WIDTH*7])
  );

  mac_dsp U_mac_dsp_08 (
    .inp(i_row[INP_WIDTH*9-1:INP_WIDTH*8]),
    .wgt(w_row[WGT_WIDTH*9-1:WGT_WIDTH*8]),
    .acc(a_row[ACC_WIDTH*9-1:ACC_WIDTH*8]),
    .sum(o_row[ACC_WIDTH*9-1:ACC_WIDTH*8])
  );

  mac_dsp U_mac_dsp_09 (
    .inp(i_row[INP_WIDTH*10-1:INP_WIDTH*9]),
    .wgt(w_row[WGT_WIDTH*10-1:WGT_WIDTH*9]),
    .acc(a_row[ACC_WIDTH*10-1:ACC_WIDTH*9]),
    .sum(o_row[ACC_WIDTH*10-1:ACC_WIDTH*9])
  );

  mac_dsp U_mac_dsp_10 (
    .inp(i_row[INP_WIDTH*11-1:INP_WIDTH*10]),
    .wgt(w_row[WGT_WIDTH*11-1:WGT_WIDTH*10]),
    .acc(a_row[ACC_WIDTH*11-1:ACC_WIDTH*10]),
    .sum(o_row[ACC_WIDTH*11-1:ACC_WIDTH*10])
  );

  mac_dsp U_mac_dsp_11 (
    .inp(i_row[INP_WIDTH*12-1:INP_WIDTH*11]),
    .wgt(w_row[WGT_WIDTH*12-1:WGT_WIDTH*11]),
    .acc(a_row[ACC_WIDTH*12-1:ACC_WIDTH*11]),
    .sum(o_row[ACC_WIDTH*12-1:ACC_WIDTH*11])
  );

  mac_dsp U_mac_dsp_12 (
    .inp(i_row[INP_WIDTH*13-1:INP_WIDTH*12]),
    .wgt(w_row[WGT_WIDTH*13-1:WGT_WIDTH*12]),
    .acc(a_row[ACC_WIDTH*13-1:ACC_WIDTH*12]),
    .sum(o_row[ACC_WIDTH*13-1:ACC_WIDTH*12])
  );

  mac_dsp U_mac_dsp_13 (
    .inp(i_row[INP_WIDTH*14-1:INP_WIDTH*13]),
    .wgt(w_row[WGT_WIDTH*14-1:WGT_WIDTH*13]),
    .acc(a_row[ACC_WIDTH*14-1:ACC_WIDTH*13]),
    .sum(o_row[ACC_WIDTH*14-1:ACC_WIDTH*13])
  );

  mac_dsp U_mac_dsp_14 (
    .inp(i_row[INP_WIDTH*15-1:INP_WIDTH*14]),
    .wgt(w_row[WGT_WIDTH*15-1:WGT_WIDTH*14]),
    .acc(a_row[ACC_WIDTH*15-1:ACC_WIDTH*14]),
    .sum(o_row[ACC_WIDTH*15-1:ACC_WIDTH*14])
  );

  mac_dsp U_mac_dsp_15 (
    .inp(i_row[INP_WIDTH*16-1:INP_WIDTH*15]),
    .wgt(w_row[WGT_WIDTH*16-1:WGT_WIDTH*15]),
    .acc(a_row[ACC_WIDTH*16-1:ACC_WIDTH*15]),
    .sum(o_row[ACC_WIDTH*16-1:ACC_WIDTH*15])
  );

endmodule
