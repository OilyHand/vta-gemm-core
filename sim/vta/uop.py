import numpy as np
import vta_test as vt

A = np.load("./result/inp.npy")

A_hex = vt.convert_hex(A, shape=A.shape, dtype=np.uint8, tohex=True)
print(A_hex)

A_rec = vt.convert_hex(A_hex, shape=A.shape, dtype=np.int8)
print(A_rec)