import os
from pathlib import Path
import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.runner import get_runner

async def clk_gen(dut):
    """Generate clock pulses."""

    for cycle in range(10):
        dut.clk.value = 0
        await Timer(1, units="ns")
        dut.clk.value = 1
        await Timer(1, units="ns")


@cocotb.test()
async def test_gemm(dut):
    """Try accessing the design."""

    await cocotb.start(clk_gen(dut))
    await Timer(5, units="ns")
    await RisingEdge(dut.clk)

    dut._log.info("my_signal_1 is %s", dut.my_signal_1.value)
    assert dut.my_signal_2.value[0] == 0, "my_signal_2[0] is not 0!"



def tb_gemm_runner():
    sim = os.getenv("SIM", "icarus")

    proj_path = Path(__file__).resolve().parent

    sources = [
        proj_path / "./sim/tb_gemm_op.v",
        proj_path / "./rtl/proc_elem.v",
        proj_path / "./rtl/systolic_row.v",
        proj_path / "./rtl/gemm_op.v"
    ]

    runner = get_runner(sim)
    runner.build(
        hdl_toplevel="gemm_op",
        sources=sources,
        always=True
    )

    runner.test(
        hdl_toplevel="gemm_op",
        hdl_toplevel_lang="verilog",
        test_module="tb_gemm_op"
    )

if __name__ == "__main__":
    tb_gemm_runner()