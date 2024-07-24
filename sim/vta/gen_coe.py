import numpy as np
from vta_test import coe

A_2d = np.random.randint(-128, 128, size=(    1, 16*16)).astype(np.int8)
B_2d = np.random.randint(-128, 128, size=(16*16, 16*16)).astype(np.int8)

A_4d = A_2d.reshape( 1,  1, 16, 16).transpose((0, 2, 1, 3))
B_4d = B_2d.reshape(16, 16, 16, 16).transpose((0, 2, 1, 3))
C_4d = np.dot(A_2d.astype(np.int32), B_2d.T.astype(np.int32)).astype(np.int8)
C_4d = C_4d.reshape( 1,  1, 16, 16).transpose((0, 2, 1, 3))
C_2d = C_4d.reshape(16, 16)

A_hex = coe.array2hex(A_4d)
B_hex = coe.array2hex(B_4d)
C_hex = coe.array2hex(C_4d)

np.savetxt("./result/inp.csv", A_2d, "%d", ",")
np.savetxt("./result/wgt.csv", B_2d, "%d", ",")
np.savetxt("./result/out.csv", C_2d, "%d", ",")

np.save("./result/inp", A_2d)
np.save("./result/wgt", B_2d)
np.save("./result/out", C_2d)

coe.save_coe(A_hex, "../coefficients/inp_mem.coe")
coe.save_coe(B_hex, "../coefficients/wgt_mem.coe")