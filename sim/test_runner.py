import os, argparse
from pathlib import Path
import numpy as np

import cocotb
from cocotb.triggers import Timer, RisingEdge
from cocotb.clock    import Clock
from cocotb.runner   import get_runner

import gemm_tb as gm
from gemm_tb import insn_gemm

## path config #################################################################
sim_path = Path(__file__).resolve().parent
rtl_path = sim_path.parent/"rtl"


## prepare data ################################################################
def prepare_data(inp_size=(1, 16), wgt_size=(16,16), dtype=np.int8):
    inp_array = np.random.randint(
        np.iinfo(dtype).min, np.iinfo(dtype).max, size=inp_size
    ).astype(dtype)

    wgt_array = np.random.randint(
        np.iinfo(dtype).min, np.iinfo(dtype).max, size=wgt_size
    ).astype(dtype)

    out_array = np.dot(
        inp_array.astype(np.int32), wgt_array.T.astype(np.int32)
    ).astype(np.int8)

    inp_hex = gm.convert_hex(inp_array, dtype=np.uint8, tohex=True)
    wgt_hex = gm.convert_hex(wgt_array, dtype=np.uint8, tohex=True)

    # for verification
    np.savetxt(sim_path/"mem/inp_mem.csv", inp_array, "%d", ",")
    np.savetxt(sim_path/"mem/wgt_mem.csv", wgt_array, "%d", ",")
    np.savetxt(sim_path/"mem/out_mem.csv", out_array, "%d", ",")
    np.save(sim_path/"mem/out_mem", out_array)

    # generate memory files
    gm.save_mem(sim_path/"mem/inp_mem.mem", inp_hex, 128, 1)
    gm.save_mem(sim_path/"mem/wgt_mem.mem", wgt_hex, 128, 1)


## test ########################################################################
@cocotb.test()
async def test_gemm_op(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    await Timer(1, units="ns")

    o_tensor = dut.o_tensor.value
    o_arr = [o_tensor[i*32:(i+1)*32-1].signed_integer for i in range(16)]
    o_arr = np.asarray(o_arr, dtype=np.int32).astype(np.int8).reshape(1, 16)
    o_ref = np.load(sim_path/"mem/out_mem.npy")

    assert np.array_equal(o_ref, o_arr)


@cocotb.test()
async def test_gemm_top(dut):
    # clock generate
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    # initialize
    dut.en.value = 0
    dut.rst.value = 0
    insn_test = insn_gemm(2, 0, 0, 1, 0, 1, 0, 1, 16, 1, 0, 0, 1, 0, 0, 0)
    dut.insn.value = int(insn_test.bitstr, 2)

    # wait transition time
    await Timer(1, units="ns")
    dut.rst.value  = 1

    # running reset acc_mem
    for i in range(16):
        await RisingEdge(dut.clk)

    # run gemm operation
    insn_test = insn_gemm(2, 0, 0, 1, 0, 0, 1, 2, 16, 1, 1, 0, 1, 0, 0, 0)
    dut.insn.value = int(insn_test.bitstr, 2)


## simulation runner ###########################################################
def gemm_runner(hdl_top_level="tb_gemm_top", testcase="test_gemm_top"):
    sim = os.getenv("SIM", "icarus")

    sources = [item for item in rtl_path.iterdir() if item.suffix == ".v"]
    sources.append(sim_path/(hdl_top_level+".v"))

    runner = get_runner(sim)

    runner.build(
        sources=sources,
        hdl_toplevel=hdl_top_level
    )

    runner.test(
        hdl_toplevel=hdl_top_level,
        test_module="test_runner",
        testcase=testcase
    )


################################################################################
if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '-t', '--target',
        help="simulation target (gemm_top, gemm_op)",
        default="gemm_top"
    )

    args = parser.parse_args()

    if args.target == "gemm_top":
        prepare_data(inp_size=(1, 256), wgt_size=(256,256))
    elif args.target == "gemm_op":
        prepare_data(inp_size=(1, 16), wgt_size=(16,16))
    else:
        print("invalid target")

    hdl_top = "tb_"+str(args.target)
    testcase = "test_"+str(args.target)
    gemm_runner(hdl_top, testcase)