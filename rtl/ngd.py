for i in range(16):
    line = "{"
    for j in range(16):
        line += "w_elem[%d][%d], " % (i, j)
    print(line + "}")