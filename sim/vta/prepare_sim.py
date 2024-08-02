import numpy as np

""" micro-op code class

micro-op bit field (32 bits)
+------+---------+-------------------+
| size | field   | field name        |
+------+---------+-------------------+
| 11   | [10:0]  | accumulator index |
| 11   | [21:11] | input index       |
| 10   | [31:22] | weight index      |
+------+---------+-------------------+
"""
class uop:
    # initialize
    def __init__(self, acc_idx=0, inp_idx=0, wgt_idx=0):
        self.__acc_idx = acc_idx
        self.__inp_idx = inp_idx
        self.__wgt_idx = wgt_idx

        uop =  np.uint32(self.__acc_idx << 21) \
             + np.uint32(self.__inp_idx << 10) \
             + np.uint32(self.__wgt_idx)
        
        self.__hex = np.vectorize(lambda x: format(x, '08X'))(uop)
    
    # str expression
    def __str__(self):
        return "0x" + str(self.__hex)
    
    # repr expression
    def __repr__(self):
        return "(acc_idx, inp_idx, wgt_idx) = (%d, %d, %d)" % (self.__acc_idx, self.__inp_idx, self.__wgt_idx)




""" gemm instruction class

gemm instruction bit field (128 bits)
+------+-----------+----------------+
| size | field     | field name     |
+------+-----------+----------------+
| 3    | [2:0]     | opcode         |
| 1    | [3]       | pop_prev_dep   |
| 1    | [4]       | pop_next_dep   |
| 1    | [5]       | push_prev_dep  |
| 1    | [6]       | push_next_dep  |
| 1    | [7]       | reset_reg      |
| 13   | [20:8]    | uop_bgn        |
| 14   | [34:21]   | uop_end        |
| 14   | [48:35]   | iter_out       |
| 14   | [62:49]   | iter_in        |
| 11   | [73:63]   | dst_factor_out |
| 11   | [84:74]   | dst_factor_in  |
| 11   | [95:85]   | src_factor_out |
| 11   | [106:96]  | src_factor_in  |
| 10   | [116:107] | wgt_factor_out |
| 10   | [126:117] | wgt_factor_in  |
| 1    | [127]     | *unused        |
+------+-----------+----------------+
"""
class insn:
    def __init__(self):
        pass




"""
save memory file for bram
"""
def save_mem(filename, data, data_width, tile_width, addr_32=True):
        if addr_32 and tile_width*data_width > 1024:
            pass
        
        depth = int(data.size / tile_width)

        if data.size != (depth, tile_width):
            data = data.reshape((depth, tile_width))

        with open(filename, "w") as f:
            for i in range(depth):
                for j in range(tile_width):
                    f.write(data[i][j] + " ")

        print("*** save complete: \"%s\"" % filename)


"""
convert number to hex string or hex string to number
"""
def convert_hex(data, shape=None, dtype=np.int8, tohex=False):
    if shape != None:
        data = data.reshape(shape)
    if tohex:
        return np.vectorize(lambda x: format(x, '02X'))(data.astype(dtype))
    else:
        return np.vectorize(lambda x: dtype(int(x, 16)))(data)




#############################
##  Generate Memory Files  ##
#############################

if __name__ == "__main__":
    A = np.random.randint(-128, 128, size=( 1, 16)).astype(np.int8)
    B = np.random.randint(-128, 128, size=(16, 16)).astype(np.int8)

    C = np.dot(A.astype(np.int32), B.T.astype(np.int32))

    A_hex = convert_hex(A, dtype=np.uint8, tohex=True)
    B_hex = convert_hex(B, dtype=np.uint8, tohex=True)

    np.savetxt("./result/inp_mem.csv", A, "%4d", ",")
    np.savetxt("./result/wgt_mem.csv", B, "%4d", ",")
    np.savetxt("./result/out_mem.csv", C, "%4d", ",")

    save_mem("../coefficients/inp_mem.mem", A_hex, 8, 16)
    save_mem("../coefficients/wgt_mem.mem", B_hex, 8, 16*16)