import os, argparse, sys
from pathlib import Path
import numpy as np

import cocotb
from cocotb.triggers import Timer
from cocotb.clock    import Clock
from cocotb.runner   import get_runner

import gemm_tb as gm

## path control ################################################################
sim_path = Path(__file__).resolve().parent
rtl_path = sim_path.parent/"rtl"
skip_gemm_op  = False
skip_gemm_top = False


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


## test module #################################################################
@cocotb.test(skip=skip_gemm_op)
async def test_gemm_op(dut):
    cocotb.start_soon(Clock(dut.clk, 1, units="ns").start())
    await Timer(1, units="ns")

    i_tensor = [dut.i_tensor.value[i*8:(i+1)*8-1].signed_integer for i in range(16)]
    w_tensor = [dut.w_tensor.value[i*8:(i+1)*8-1].signed_integer for i in range(256)]
    o_tensor = [dut.o_tensor.value[i*32:(i+1)*32-1].signed_integer for i in range(16)]

    i_tensor = np.asarray(i_tensor, dtype=np.int8)
    w_tensor = np.asarray(w_tensor, dtype=np.int8).reshape((16,16))
    o_tensor = np.asarray(o_tensor, dtype=np.int32).astype(np.int8).reshape(1, 16)
    o_tensor_ref = np.load(sim_path/"mem/out_mem.npy")

    assert np.array_equal(o_tensor_ref, o_tensor)


@cocotb.test(skip=skip_gemm_top)
async def test_gemm_top(dut):
    pass


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

    if args.target == "tb_gemm_top":
        prepare_data(inp_size=(1, 256), wgt_size=(256,256))
    elif args.target == "tb_gemm_op":
        prepare_data(inp_size=(1, 16), wgt_size=(16,16))
    else:
        print("invalid target")

    hdl_top = "tb_"+str(args.target)
    testcase = "test_"+str(args.target)
    gemm_runner(hdl_top, testcase)