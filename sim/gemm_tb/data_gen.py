import numpy as np

###############################
##    micro-op code class    ##
###############################
class uop:
    '''
    **micro-op code class**

    - micro-op bit field (32 bits)

    +------+---------+-------------------+
    | size | field   | field name        |
    +------+---------+-------------------+
    | 11   | [10:0]  | accumulator index |
    | 11   | [21:11] | input index       |
    | 10   | [31:22] | weight index      |
    +------+---------+-------------------+

    '''
    # initialize
    def __init__(self, acc_idx=0, inp_idx=0, wgt_idx=0):
        self.__acc_idx = acc_idx
        self.__inp_idx = inp_idx
        self.__wgt_idx = wgt_idx

        self.bitstr  = "{0:011b}".format(self.__acc_idx)
        self.bitstr += "{0:011b}".format(self.__inp_idx)
        self.bitstr += "{0:010b}".format(self.__wgt_idx)

        self.hex = format(int(self.bitstr, 2), '08X')

    # str expression
    def __str__(self):
        return "0x" + str(self.hex)

    # repr expression
    def __repr__(self):
        return "(acc_idx, inp_idx, wgt_idx) = (%d, %d, %d)" % \
                (self.__acc_idx, self.__inp_idx, self.__wgt_idx)


##################################
##    gemm instruction class    ##
##################################
class insn_gemm :
    '''
    **gemm instruction class**

    - gemm instruction bit field (128 bits)

    +------+------------+----------------+
    | size | field      | field name     |
    +------+------------+----------------+
    | 3    | [2:0]      | opcode         |
    | 1    | [3]        | pop_prev_dep   |
    | 1    | [4]        | pop_next_dep   |
    | 1    | [5]        | push_prev_dep  |
    | 1    | [6]        | push_next_dep  |
    | 1    | [7]        | reset_reg      |
    | 13   | [20:8]     | uop_bgn        |
    | 14   | [34:21]    | uop_end        |
    | 14   | [48:35]    | iter_out       |
    | 14   | [62:49]    | iter_in        |
    | 11   | [73:63]    | dst_factor_out |
    | 11   | [84:74]    | dst_factor_in  |
    | 11   | [95:85]    | src_factor_out |
    | 11   | [106:96]   | src_factor_in  |
    | 10   | [116:107]  | wgt_factor_out |
    | 10   | [126:117]  | wgt_factor_in  |
    | 1    | [127]      | *unused        |
    +------+------------+----------------+

    '''
    def __init__(
        self,
        opcode=0,
        pop_prev_dep=0,
        pop_next_dep=0,
        push_prev_dep=0,
        push_next_dep=0,
        reset_reg=0,
        uop_bgn=0,
        uop_end=0,
        iter_out=0,
        iter_in=0,
        dst_factor_out=0,
        dst_factor_in=0,
        src_factor_out=0,
        src_factor_in=0,
        wgt_factor_out=0,
        wgt_factor_in=0
    ):
        self.__opcode = opcode
        self.__pop_prev_dep = pop_prev_dep
        self.__pop_next_dep = pop_next_dep
        self.__push_prev_dep = push_prev_dep
        self.__push_next_dep = push_next_dep
        self.__reset_reg = reset_reg
        self.__uop_bgn = uop_bgn
        self.__uop_end = uop_end
        self.__iter_out = iter_out
        self.__iter_in = iter_in
        self.__dst_factor_out = dst_factor_out
        self.__dst_factor_in = dst_factor_in
        self.__src_factor_out = src_factor_out
        self.__src_factor_in = src_factor_in
        self.__wgt_factor_out = wgt_factor_out
        self.__wgt_factor_in = wgt_factor_in

        self.bitstr  = "0"
        self.bitstr += "{0:010b}".format(self.__wgt_factor_in)
        self.bitstr += "{0:010b}".format(self.__wgt_factor_out)
        self.bitstr += "{0:011b}".format(self.__src_factor_in)
        self.bitstr += "{0:011b}".format(self.__src_factor_out)
        self.bitstr += "{0:011b}".format(self.__dst_factor_in)
        self.bitstr += "{0:011b}".format(self.__dst_factor_out)
        self.bitstr += "{0:014b}".format(self.__iter_in)
        self.bitstr += "{0:014b}".format(self.__iter_out)
        self.bitstr += "{0:014b}".format(self.__uop_end)
        self.bitstr += "{0:013b}".format(self.__uop_bgn)
        self.bitstr += "{0:1b}".format(self.__reset_reg)
        self.bitstr += "{0:1b}".format(self.__push_next_dep)
        self.bitstr += "{0:1b}".format(self.__push_prev_dep)
        self.bitstr += "{0:1b}".format(self.__pop_next_dep)
        self.bitstr += "{0:1b}".format(self.__pop_prev_dep)
        self.bitstr += "{0:03b}".format(self.__opcode)

        self.hex = format(int(self.bitstr, 2), "032X")

    def __str__(self):
        str_out  = "opcode: %d\n" % self.opcode
        str_out += "pop prev: %d, pop next: %d " % \
                   (self.pop_prev_dep, self.pop_next_dep)
        str_out += "push prev: %d, push next: %d\n" % \
                   (self.push_prev_dep, self.push_next_dep)
        str_out += "reset_out: %d" % self.reset_reg
        str_out += "uop range: (%d, %d)\n" % \
                   (self.uop_bgn, self.uop_end)
        str_out += "iter_out: %d, iter_in: %d\n" % \
                   (self.iter_out, self.iter_in)
        str_out += "factor_out: (wgt=%d, inp=%d, acc=%d)\n" % \
                   (self.wgt_factor_out, self.src_factor_out, self.dst_factor_out)
        str_out += "factor_in:  (wgt=%d, inp=%d, acc=%d)" % \
                   (self.wgt_factor_in, self.src_factor_in, self.dst_factor_in)
        return str_out


def save_mem(filename, data, tile_width):
    '''
    save memory file for bram
    '''

    with open(filename, "w") as f:
        for i in range(data.size):
            if i%tile_width == 0:
                f.write(" ")
            f.write(data[0][i])


    print("*** save complete: \"%s\"" % filename)


def convert_hex(data, shape=None, dtype=np.uint8, tohex=True):
    '''
    convert number to hex string or hex string to number
    '''
    if shape != None:
        data = data.reshape(shape)
    if tohex:
        return np.vectorize(lambda x: format(x, '02X'))(data.astype(dtype))
    else:
        return np.vectorize(lambda x: dtype(int(x, 16)))(data)