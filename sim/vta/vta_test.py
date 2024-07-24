import numpy as np

class micro_op:
    def __init__(self, a_idx=0, i_idx=0, w_idx=0):
        self.__acc_idx = a_idx # 11 bits
        self.__inp_idx = i_idx # 11 bits
        self.__wgt_idx = w_idx # 10 bits

        uop =  np.uint32(self.__acc_idx << 21) \
             + np.uint32(self.__inp_idx << 10) \
             + np.uint32(self.__wgt_idx)
        self.__hex = np.vectorize(lambda x: format(x, '08X'))(uop)
    
    def __str__(self):
        return str(self.__hex)

class coe:
    def array2hex(data):
        data_uint = data.astype(np.uint8)
        return np.vectorize(lambda x: format(x, '02X'))(data_uint)

    def save_coe(hexs, filename):
        f = open(filename, "w")
        f.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
        for i0 in range(hexs.shape[0]):
            for i1 in range(hexs.shape[1]):
                for i2 in range(hexs.shape[2]):
                    for i3 in range(hexs.shape[3]):
                        f.write(hexs[i0][i1][i2][i3])
                        if (i0+1, i1+1, i2+1, i3+1) == hexs.shape:
                            f.write(";")
                        elif (i2+1,i3+1) == (hexs.shape[2],hexs.shape[3]):
                            f.write(",\n")
                    
        f.close()
        print(filename, "is saved")