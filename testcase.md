# GEMM instruction

## instruction field

size   | field      | field name
-------|------------|-----------------
3      | [2:0]      | opcode
1      | [3]        | pop_prev_dep
1      | [4]        | pop_next_dep
1      | [5]        | push_prev_dep
1      | [6]        | push_next_dep
1      | [7]        | reset_reg
13     | [20:8]     | uop_bgn
14     | [34:21]    | uop_end
14     | [48:35]    | iter_out
14     | [62:49]    | iter_in
11     | [73:63]    | dst_factor_out
11     | [84:74]    | dst_factor_in
11     | [95:85]    | src_factor_out
11     | [106:96]   | src_factor_in
10     | [116:107]  | wgt_factor_out
10     | [126:117]  | wgt_factor_in
1      | [127]      | *unused


## micro-op field

size   | field      | field name
-------|------------|--------------------
11     | [10:0]     | accumulator index
11     | [21:11]    | input index
10     | [31:22]    | weight index

<br>

# Test Case

* **Instruction**

field         |size| value
--------------|----|--
opcode        |3   | 2 (gemm)
pop_prev_dep  |1   | 0
pop_next_dep  |1   | 0
push_prev_dep |1   | 0
push_next_dep |1   | 0
reset_reg     |1   | 0
uop_bgn       |13  | 0
uop_end       |14  | 15
iter_out      |14  | 0
iter_in       |14  | 3
dst_factor_out|11  | 
dst_factor_in |11  | 
src_factor_out|11  | 
src_factor_in |11  | 
wgt_factor_out|10  | 
wgt_factor_in |10  | 
*unused       |1   | 

* **tensor**

```
input = 
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]

accum = 
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

weight = 
  [
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
  ]

accumulator =
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]
  
output =
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]


```