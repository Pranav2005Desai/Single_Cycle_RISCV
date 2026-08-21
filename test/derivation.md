# Hand-Derived Test Program — Encoding and Execution Trace

This file replaces the earlier Python-generated test vectors. Every
instruction below is encoded by hand, following the RV32I bit layouts, and
every register value is computed by manually tracing execution — not by
running the RTL and copying its output. That's what makes it a real check:
the expected answer comes from the ISA specification, independent of
whatever the hardware actually does.

## 1. Bit Layouts

```
R-type: funct7[31:25] rs2[24:20] rs1[19:15] funct3[14:12] rd[11:7]  opcode[6:0]
I-type: imm[31:20]               rs1[19:15] funct3[14:12] rd[11:7]  opcode[6:0]
S-type: imm[31:25]    rs2[24:20] rs1[19:15] funct3[14:12] imm[11:7] opcode[6:0]
```

Opcodes: R = `0110011`, I-arith/load = `0010011` / `0000011`, S = `0100011`.

## 2. Four Fully Worked Examples (one per case that matters)

### 2a. R-type — `add x3, x1, x2`

| Field | Value | Bits |
|---|---|---|
| funct7 | 0000000 | `[31:25]` |
| rs2 | x2 = 2 = `00010` | `[24:20]` |
| rs1 | x1 = 1 = `00001` | `[19:15]` |
| funct3 | 000 (add/sub) | `[14:12]` |
| rd | x3 = 3 = `00011` | `[11:7]` |
| opcode | `0110011` | `[6:0]` |

Concatenated: `0000000 00010 00001 000 00011 0110011`
Grouped into hex nibbles: `0000 0000 0100 0001 1000 0001 1011 0011` → **`0x002081b3`**

### 2b. I-type — `addi x13, x0, 1024` (the classic trap case)

`1024 = 0x400 = binary 0100_0000_0000`. Bit 10 of that immediate is **1**.

| Field | Value | Bits |
|---|---|---|
| imm[11:0] | `010000000000` | `[31:20]` |
| rs1 | x0 = `00000` | `[19:15]` |
| funct3 | 000 | `[14:12]` |
| rd | x13 = `01101` | `[11:7]` |
| opcode | `0010011` | `[6:0]` |

Result: **`0x40000693`**

Notice `inst[30]` — bit 30 of the *whole instruction word* — is 1 here, because
it's immediate bit 10 landing in that position. This is exactly the bit the
ALU control block uses to distinguish `sub` from `add`. If `control.sv`
decoded that bit without checking the opcode first, this `addi` would
silently execute as a subtraction. That's why `funct7_5` is gated on
`opcode == OP_RTYPE` in the control logic — this instruction is the reason
that gate exists, not a hypothetical.

### 2c. I-type load — `lbu x24, 0(x22)`

| Field | Value | Bits |
|---|---|---|
| imm[11:0] | `000000000000` (offset 0) | `[31:20]` |
| rs1 | x22 = `10110` | `[19:15]` |
| funct3 | 100 (lbu) | `[14:12]` |
| rd | x24 = `11000` | `[11:7]` |
| opcode | `0000011` | `[6:0]` |

Result: **`0x000b4c03`**

### 2d. S-type — `sw x2, 0(x22)`

The immediate splits across two field groups — `imm[11:5]` up top,
`imm[4:0]` down near the opcode — because rd's field position is reused for
the low immediate bits (S-type has no destination register).

| Field | Value | Bits |
|---|---|---|
| imm[11:5] | `0000000` (offset 0) | `[31:25]` |
| rs2 | x2 = `00010` (the value being stored) | `[24:20]` |
| rs1 | x22 = `10110` (the base address) | `[19:15]` |
| funct3 | 010 (sw) | `[14:12]` |
| imm[4:0] | `00000` | `[11:7]` |
| opcode | `0100011` | `[6:0]` |

Result: **`0x002b2023`**

Every other line in the program below follows the same four patterns.

## 3. Full Program, Encoded

```
00500093   addi x1,  x0, 5          # x1  = 5
ffe00113   addi x2,  x0, -2         # x2  = -2  (0xFFFFFFFE)

002081b3   add  x3,  x1, x2
40208233   sub  x4,  x1, x2
0020f2b3   and  x5,  x1, x2
0020e333   or   x6,  x1, x2
0020c3b3   xor  x7,  x1, x2
00109433   sll  x8,  x1, x1
001154b3   srl  x9,  x2, x1
40115533   sra  x10, x2, x1
001125b3   slt  x11, x2, x1
00113633   sltu x12, x2, x1

40000693   addi  x13, x0, 1024      # bit-10 trap case, see 2b
00012713   slti  x14, x2, 0
fff13793   sltiu x15, x2, -1
00f0c813   xori  x16, x1, 15
0080e893   ori   x17, x1, 8
0030f913   andi  x18, x1, 3
00209993   slli  x19, x1, 2
00315a13   srli  x20, x2, 3
40315a93   srai  x21, x2, 3

04000b13   addi x22, x0, 64         # base pointer
002b2023   sw   x2,  0(x22)
000b2b83   lw   x23, 0(x22)
000b4c03   lbu  x24, 0(x22)
000b5c83   lhu  x25, 0(x22)
```

## 4. Execution Trace (worked by hand, ISA semantics only)

Two's complement reminder: `-2` as a 32-bit value is `0xFFFFFFFE`
(all ones except the low bit).

| Instr | Working | Result |
|---|---|---|
| `x1 = 5` | given | `0x00000005` |
| `x2 = -2` | given | `0xFFFFFFFE` |
| `x3 = x1+x2` | `5 + (-2)` | `3` → `0x00000003` |
| `x4 = x1-x2` | `5 - (-2) = 5+2` | `7` → `0x00000007` |
| `x5 = x1&x2` | `0101 & 1110` | `0100` = `4` |
| `x6 = x1\|x2` | `0101 \| 1110` | `1111` = `0xFFFFFFFF` (-1) |
| `x7 = x1^x2` | `0101 ^ 1110` | `1011` = `0xFFFFFFFB` (-5) |
| `x8 = x1<<x1` | shift 5 by (5&31)=5 | `5×32 = 160` = `0xA0` |
| `x9 = x2>>x1` (logical) | `0xFFFFFFFE >> 5`, zero-fill | `0x07FFFFFF` |
| `x10 = x2>>>x1` (arith) | sign-fill: `-2 >> 5` (floor) | `-1` = `0xFFFFFFFF` |
| `x11 = slt(x2,x1)` | signed: `-2 < 5`? | `1` |
| `x12 = sltu(x2,x1)` | unsigned: `0xFFFFFFFE < 5`? | `0` |
| `x13 = x0+1024` | | `1024` = `0x00000400` |
| `x14 = slti(x2,0)` | signed: `-2 < 0`? | `1` |
| `x15 = sltiu(x2,-1)` | imm sign-extends to `0xFFFFFFFF`; unsigned: `0xFFFFFFFE < 0xFFFFFFFF`? | `1` |
| `x16 = x1^15` | `0101 ^ 1111` | `1010` = `10` |
| `x17 = x1\|8` | `0101 \| 1000` | `1101` = `13` |
| `x18 = x1&3` | `0101 & 0011` | `0001` = `1` |
| `x19 = x1<<2` | `5×4` | `20` |
| `x20 = x2>>3` (logical) | zero-fill | `0x1FFFFFFF` |
| `x21 = x2>>>3` (arith) | `-2 >> 3` (floor) | `-1` = `0xFFFFFFFF` |
| `x22 = x0+64` | | `64` = `0x00000040` |
| `sw x2 -> mem[64]` | stores `0xFFFFFFFE` | (memory, not a register) |
| `x23 = lw mem[64]` | full word back | `0xFFFFFFFE` |
| `x24 = lbu mem[64]` | lowest byte only, zero-extended | `0xFE` = `254` |
| `x25 = lhu mem[64]` | lowest halfword only, zero-extended | `0xFFFE` = `65534` |

These are exactly the values in `test/expected.svh`. If you're asked to
defend any single one in a viva, this table is where the arithmetic lives.
