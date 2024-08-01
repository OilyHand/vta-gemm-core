import numpy as np

def save_mem(filename, data, data_width, tile_width, addr_32=True):
        if addr_32 and tile_width*data_width > 1024:
            pass
        
        depth = int(data.size / tile_width)

        if data.size != (depth, tile_width):
            data = data.reshape((depth, tile_width))

        with open(filename, "w") as f:
            # f.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
            
            for i in range(depth):
                for j in range(tile_width):
                    f.write(data[i][j] + " ")
                # if not(i == depth-1 and j == tile_width-1):
                #     f.write("\n")

        print("*** save complete: \"%s\"" % filename)


def convert_hex(data, shape=None, dtype=np.int8, tohex=False):
    if shape != None:
        data = data.reshape(shape)
    if tohex:
        return np.vectorize(lambda x: format(x, '02X'))(data.astype(dtype))
    else:
        return np.vectorize(lambda x: dtype(int(x, 16)))(data)

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