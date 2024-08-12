#include "example.h"

extern "C" void gemm(
    insn_T insn,
    uop_T uop_mem[VTA_UOP_BUFF_DEPTH],
    bus_T acc_mem[VTA_ACC_BUFF_DEPTH][ACC_MAT_AXI_RATIO],
    bus_T inp_mem[VTA_INP_BUFF_DEPTH][INP_MAT_AXI_RATIO],
    bus_T wgt_mem[VTA_WGT_BUFF_DETH][WGT_MAT_AXI_RATIO],
    bus_T out_mem[VTA_ACC_BUFF_DEPTH][OUT_MAT_AXI_RAIO]
);