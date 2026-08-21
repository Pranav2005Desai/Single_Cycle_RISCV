`timescale 1ns / 1ps

module tb_rv32_core;

  logic clk;
  logic rst_n;

  logic [31:0] imem_addr;
  logic [31:0] imem_rdata;

  logic [31:0] dmem_addr;
  logic [31:0] dmem_wdata;
  logic        dmem_we;
  logic [3:0]  dmem_be;
  logic [31:0] dmem_rdata;

  rv32_core dut (
    .clk        (clk),
    .rst_n      (rst_n),
    .imem_addr  (imem_addr),
    .imem_rdata (imem_rdata),
    .dmem_addr  (dmem_addr),
    .dmem_wdata (dmem_wdata),
    .dmem_we    (dmem_we),
    .dmem_be    (dmem_be),
    .dmem_rdata (dmem_rdata)
  );

  imem imem0 (
    .addr  (imem_addr),
    .rdata (imem_rdata)
  );

  dmem dmem0 (
    .clk   (clk),
    .addr  (dmem_addr),
    .wdata (dmem_wdata),
    .we    (dmem_we),
    .be    (dmem_be),
    .rdata (dmem_rdata)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 1'b0;

    repeat (2) @(posedge clk);
    rst_n = 1'b1;

    repeat (27) @(posedge clk);   // 26 instructions plus final writeback
    @(negedge clk);

    if (dut.u_regfile.regs[1]  !== 32'h0000_0005) $fatal(1, "x1 wrong");
    if (dut.u_regfile.regs[2]  !== 32'hffff_fffe) $fatal(1, "x2 wrong");
    if (dut.u_regfile.regs[3]  !== 32'h0000_0003) $fatal(1, "x3 wrong");
    if (dut.u_regfile.regs[4]  !== 32'h0000_0007) $fatal(1, "x4 wrong");
    if (dut.u_regfile.regs[11] !== 32'h0000_0001) $fatal(1, "x11 wrong");
    if (dut.u_regfile.regs[12] !== 32'h0000_0000) $fatal(1, "x12 wrong");
    if (dut.u_regfile.regs[13] !== 32'h0000_0400) $fatal(1, "x13 wrong");
    if (dut.u_regfile.regs[23] !== 32'hffff_fffe) $fatal(1, "x23 wrong");
    if (dut.u_regfile.regs[24] !== 32'h0000_00fe) $fatal(1, "x24 wrong");
    if (dut.u_regfile.regs[25] !== 32'h0000_fffe) $fatal(1, "x25 wrong");

    $display("tb_rv32_core: PASS");
    $finish;
  end

endmodule