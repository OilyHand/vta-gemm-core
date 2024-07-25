import numpy as np
from vta_test import coe

A = np.random.randint(-128, 128, size=(    1, 16*16)).astype(np.int8)
B = np.random.randint(-128, 128, size=(16*16, 16*16)).astype(np.int8)
C = np.dot(A.astype(np.int32), B.T.astype(np.int32)).astype(np.int8)

A_hex = coe.array2hex(A)
B_hex = coe.array2hex(B)
C_hex = coe.array2hex(C)

np.savetxt("./result/inp.csv", A, "%d", ",")
np.savetxt("./result/wgt.csv", B, "%d", ",")
np.savetxt("./result/out.csv", C, "%d", ",")

np.save("./result/inp", A)
np.save("./result/wgt", B)
np.save("./result/out", C)

coe.save_coe("../coefficients/inp_mem.coe", A_hex, 8, 16)
coe.save_coe("../coefficients/wgt_mem.coe", B_hex, 8, 16*16)
