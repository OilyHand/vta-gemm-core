import numpy as np
from vta_test import micro_op

uop = micro_op(3, 5, 12)
print(uop)

"""
inp array : ( 1, 16,  1, 16)
    각 텐서는 (1, 16)가 16개

한 번의 gemm 연산은

(1, 16) * (16, 16)

inst...
uop_bgn  = 
uop_end  = 
iter_in  = 
iter_out =

micro-op...
acc_idx = 
inp_idx = 
wgt_idx = 


wgt array : (16, 16, 16, 16)
    각 텐서는 (16, 16)


out array : ( 1, 16,  1, 16)











# from tvm.script import ir as I
# from tvm.script import tir as T

@I.ir_module
class Module:
    @T.prim_func
    def main(A: T.Buffer((1, 16, 1, 16), "int8"), B: T.Buffer((16, 16, 16, 16), "int8"), C: T.Buffer((1, 16, 1, 16), "int8")):
        T.func_attr({"from_legacy_te_schedule": T.bool(True), "tir.noalias": T.bool(True)})
        vta = T.int32()
        with T.attr(T.iter_var(vta, None, "ThreadIndex", "vta"), "coproc_scope", 2):
            with T.attr(T.iter_var(vta, None, "ThreadIndex", "vta"), "coproc_uop_scope", "VTAPushGEMMOp"):
                T.call_extern("int32", "VTAUopLoopBegin", 16, 1, 0, 0)
                T.tir.vta.uop_push(0, 1, 0, 0, 0, 0, 0, 0)
                T.call_extern("int32", "VTAUopLoopEnd")
            T.tir.vta.coproc_dep_push(2, 1)
        for ko in range(16):
            with T.attr(T.iter_var(vta, None, "ThreadIndex", "vta"), "coproc_scope", 1):
                T.tir.vta.coproc_dep_pop(2, 1)
                T.call_extern("int32", "VTALoadBuffer2D", T.tvm_thread_context(T.tir.vta.command_handle()), A.data, ko, 1, 1, 1, 0, 0, 0, 0, 0, 2)
                T.call_extern("int32", "VTALoadBuffer2D", T.tvm_thread_context(T.tir.vta.command_handle()), B.data, ko, 1, 16, 16, 0, 0, 0, 0, 0, 1)
                T.tir.vta.coproc_dep_push(1, 2)
            T.attr(T.iter_var(vta, None, "ThreadIndex", "vta"), "coproc_scope", 2)
            T.tir.vta.coproc_dep_pop(1, 2)
            with T.attr(T.iter_var(vta, None, "ThreadIndex", "vta"), "coproc_uop_scope", "VTAPushGEMMOp"):
                T.call_extern("int32", "VTAUopLoopBegin", 16, 1, 0, 1)
                T.tir.vta.uop_push(0, 0, 0, 0, 0, 0, 0, 0)
                T.call_extern("int32", "VTAUopLoopEnd")
            T.tir.vta.coproc_dep_push(2, 1)
        T.tir.vta.coproc_dep_push(2, 3)
        T.tir.vta.coproc_dep_pop(2, 1)
        with T.attr(T.iter_var(vta, None, "ThreadIndex", "vta"), "coproc_scope", 3):
            T.tir.vta.coproc_dep_pop(2, 3)
            T.call_extern("int32", "VTAStoreBuffer2D", T.tvm_thread_context(T.tir.vta.command_handle()), 0, 4, C.data, 0, 16, 1, 16)
        T.tir.vta.coproc_sync()

"""