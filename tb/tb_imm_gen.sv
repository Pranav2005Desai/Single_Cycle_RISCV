`timescale 1ns / 1ps

module tb_rv32_top;

  logic clk;
  logic rst_n;

  rv32_top dut (
    .clk  (clk),
    .rst_n(rst_n)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 1'b0;

    repeat (2) @(posedge clk);
    rst_n = 1'b1;

    repeat (27) @(posedge clk);   // 26 instructions plus final writeback
    @(negedge clk);

    if (dut.u_core.u_regfile.regs[1] !== 32'h0000_0005)
      $fatal(1, "x1 wrong");

    if (dut.u_core.u_regfile.regs[13] !== 32'h0000_0400)
      $fatal(1, "x13 wrong");

    if (dut.u_core.u_regfile.regs[23] !== 32'hffff_fffe)
      $fatal(1, "x23 wrong");

    if (dut.u_core.u_regfile.regs[25] !== 32'h0000_fffe)
      $fatal(1, "x25 wrong");

    $display("tb_rv32_top: PASS");
    $finish;
  end

endmodule