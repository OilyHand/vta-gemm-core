# vta-gemm-core

## Pipeline Stage

1. Micro-op Code Fetch (UOP)

2. Index Decode (IDX)

3. Memory Read (MEM)

4. GEMM Excution (EX)

5. Write Back (WB)

<br>

## Code

**not-yet**

- gemm.v (top module)
- uop_fetch.v
- memory_read.v
- write_back.v

**complete**

- proc_elem.v
- systolic_row.v
- idx_decode.v
- gemm_op.v
