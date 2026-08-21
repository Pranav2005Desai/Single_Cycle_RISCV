`timescale 1ns / 1ps

module tb_rv32;

  `include "expected.svh"

  logic clk, rst_n, running;
  int   errors = 0;

  initial begin
    clk     = 1'b0;
    rst_n   = 1'b0;
    running = 1'b0;
  end

  always #5 clk = ~clk;   // 100 MHz

  rv32_top dut (.clk(clk), .rst_n(rst_n));

  always @(posedge clk) begin
    if (running)
      $display("%4t  pc=%08h  inst=%08h  x%0d <= %08h  (we=%0b)",
               $time, dut.u_core.pc, dut.u_core.inst,
               dut.u_core.rd, dut.u_core.rd_data, dut.u_core.reg_write);
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_rv32);

    repeat (2) @(posedge clk);
    rst_n   = 1'b1;
    running = 1'b1;

    repeat (N_INST + 1) @(posedge clk);   // +1 for the last writeback
    @(negedge clk);

    $display("\nregister check:");
    for (int i = 0; i < 32; i++) begin
      automatic logic [31:0] got = dut.u_core.u_regfile.regs[i];
      if (got !== EXPECTED_REGS[i]) begin
        $display("  FAIL x%0d = %08h, expected %08h", i, got, EXPECTED_REGS[i]);
        errors++;
      end else if (got != 32'd0) begin
        $display("  ok   x%0d = %08h", i, got);
      end
    end

    if (errors == 0) $display("\nPASS: all registers match\n");
    else             $display("\nFAIL: %0d mismatches\n", errors);
    $finish;
  end

endmodule
