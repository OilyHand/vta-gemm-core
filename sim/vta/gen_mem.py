import numpy as np
import vta_test as vt
from vta_test import coe

# if init:
A = np.random.randint(-128, 128, size=( 1, 16)).astype(np.int8)
B = np.random.randint(-128, 128, size=(16, 16)).astype(np.int8)
Bt = np.transpose(B)

C = np.dot(A.astype(np.int32), B.T.astype(np.int32)).astype(np.int8)

A_hex = vt.convert_hex(A, dtype=np.uint8, tohex=True)
B_hex = vt.convert_hex(Bt, dtype=np.uint8, tohex=True)

np.savetxt("./result/inp_mem.csv", A, "%4d", ",")
np.savetxt("./result/wgt_mem.csv", Bt, "%4d", ",")
np.savetxt("./result/out_mem.csv", C, "%4d", ",")

# np.save("./result/inp", A)
# np.save("./result/wgt", B)
# np.save("./result/out", C)

coe.save_coe("../coefficients/inp_mem.mem", A_hex, 8, 16)
coe.save_coe("../coefficients/wgt_mem.mem", B_hex, 8, 16*16)