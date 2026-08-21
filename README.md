# Single-Cycle RV32I Core

A single-cycle RISC-V processor implementing the RV32I base integer instruction set, written in SystemVerilog and simulated with Verilator.

This is Phase 0 of a staged processor project — the single-cycle core exists to establish a clean datapath and a verification harness that later phases build on.

## Status

Work in progress. Implemented so far:

- [ ] I-type ALU (ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI)
- [ ] R-type ALU (ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND)
- [ ] LUI, AUIPC
- [ ] Branches (BEQ, BNE, BLT, BGE, BLTU, BGEU)
- [ ] JAL, JALR
- [ ] Word load/store (LW, SW)
- [ ] Byte/halfword load/store (LB, LH, LBU, LHU, SB, SH)
- [ ] ECALL, EBREAK, FENCE

## Architecture

Classic single-cycle datapath — one instruction retires per clock, no pipelining.

```
PC → Instruction Memory → Decode → Register File → ALU → Data Memory → Writeback
```

Key structural points:

- **Separate branch comparator.** Branch conditions are evaluated in a dedicated
  comparator rather than the ALU, leaving the ALU free to compute the branch
  target (`PC + imm`) in the same cycle.
- **One adder for all targets.** Branch, JAL and JALR targets all resolve through
  the ALU with different operand-mux settings.
- **Four muxes carry the control logic:** PC-next, ALU operand 1 (rs1/PC/zero),
  ALU operand 2 (rs2/imm), and writeback source (ALU/memory/PC+4).

## Repository layout

```
rtl/       SystemVerilog design sources
tb/        Testbenches
test/      Assembly test programs
Makefile   Build and simulation targets
```

## Building

Requires [Verilator](https://verilator.org) and GTKWave.

```bash
make          # build and run simulation
make wave     # open waveforms
```

## Verification

- Hand-written assembly tests per instruction group, self-checking via register
  file dump and comparison against expected values
- Planned: `riscv-tests` compliance suite and instruction-level lockstep
  against the Spike ISA simulator

## Roadmap

| Phase | Scope |
|-------|-------|
| 0 | Single-cycle RV32I + verification infrastructure |
| 1 | 5-stage pipeline, forwarding, hazard handling, CSRs and traps |
| 2 | Caches, RV32M, branch prediction, performance counters |
| 3 | Out-of-order execution (register renaming, reorder buffer) |
| 4 | Vector extension (Zve32x) |
| 5 | Floating point (F, Zve32f) |
| 6 | Matrix acceleration |

## References

- [RISC-V Unprivileged ISA Specification](https://riscv.org/technical/specifications/)
- Patterson & Hennessy, *Computer Organization and Design: RISC-V Edition*
