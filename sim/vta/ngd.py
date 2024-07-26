import numpy as np

f = open("./print.txt", "w")

for i in range(16):
    for j in range(16):
        line = "assign wgt_data[{0}][{1}] = wgt_mem_rd_data[{2}:{3}];\n".format(i, j, 8*(j+1)+128*i-1, j*8+128*i)
        f.write(line)
f.close()