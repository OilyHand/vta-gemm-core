import numpy as np


"""
Class for dealing micro-op code
"""
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
        return "0x" + str(self.__hex)
    
    def __repr__(self):
        return "(acc_idx, inp_idx, wgt_idx) = (%d, %d, %d)" % (self.__acc_idx, self.__inp_idx, self.__wgt_idx)

"""
Class for generating coefficient data file
"""
class coe:
    def array2hex(data):
        data_uint8 = data.astype(np.uint8)
        return np.vectorize(lambda x: format(x, '02X'))(data_uint8)
    
    def hex2array(data):
        pass

    def save_coe(filename, data, data_width, tile_width, addr_32=True):
        if addr_32 and tile_width*data_width > 1024:
            pass
        
        depth = int(data.size / tile_width)

        if data.size != (depth, tile_width):
            data = data.reshape((depth, tile_width))

        f = open(filename, "w")
        f.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
        
        for i in range(depth):
            for j in range(tile_width):
                f.write(data[i][j])
            if not(i == depth-1 and j == tile_width-1):
                f.write(",\n")
        f.write(";")
        f.close()
        print("*** save complete: \"%s\"" % filename)