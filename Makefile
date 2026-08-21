# Single-cycle RV32I (R/I/S subset)
#
#   make          build and run the full core testbench
#   make units    run every module testbench
#   make alu      run one module testbench by name
#   make lint     check the RTL only
#   make wave     open the waveform in GTKWave
#   make clean

VERILATOR ?= verilator

RTL := rtl/rv32_pkg.sv rtl/pc_reg.sv rtl/imem.sv rtl/regfile.sv \
       rtl/imm_gen.sv rtl/alu.sv rtl/control.sv rtl/store_unit.sv \
       rtl/load_unit.sv rtl/dmem.sv rtl/rv32_core.sv rtl/rv32_top.sv

# UNUSEDSIGNAL: word-addressed memories only use the middle address bits,
#               and imm_gen only reads the immediate fields.
# BLKSEQ:       "always #5 clk = ~clk;" is the normal testbench clock idiom.
WAIVE := -Wno-DECLFILENAME -Wno-UNUSEDSIGNAL -Wno-BLKSEQ

# Building one module against the whole package leaves most package
# constants unused, which is expected, not a bug.
UNIT_WAIVE := $(WAIVE) -Wno-IMPORTSTAR -Wno-UNUSEDPARAM

VFLAGS := --binary -j 0 --timing -CFLAGS "-std=c++20" -Wall -Itest --trace

UNITS := pc_reg regfile imem imm_gen alu control store_unit load_unit dmem

.PHONY: all sim units core top lint wave clean $(UNITS)

all: sim

sim:
	$(VERILATOR) $(VFLAGS) $(WAIVE) --top-module tb_rv32 $(RTL) tb/tb_rv32.sv -o sim_rv32
	./obj_dir/sim_rv32

$(UNITS):
	$(VERILATOR) $(VFLAGS) $(UNIT_WAIVE) --top-module tb_$@ \
	  rtl/rv32_pkg.sv rtl/$@.sv tb/unit/tb_$@.sv -o sim_$@
	./obj_dir/sim_$@

units: $(UNITS) core top

# Integration testbenches: core with memories attached, and the full top.
core:
	$(VERILATOR) $(VFLAGS) $(WAIVE) --top-module tb_rv32_core $(RTL) tb/tb_rv32_core.sv -o sim_core
	./obj_dir/sim_core

top:
	$(VERILATOR) $(VFLAGS) $(WAIVE) --top-module tb_rv32_top $(RTL) tb/tb_rv32_top.sv -o sim_top
	./obj_dir/sim_top

lint:
	$(VERILATOR) --lint-only -Wall $(WAIVE) --top-module rv32_top $(RTL)

wave:
	gtkwave wave.vcd wave.gtkw &

clean:
	rm -rf obj_dir wave.vcd