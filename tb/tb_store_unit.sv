`timescale 1ns / 1ps

import rv32_pkg::*;

module tb_store_unit;

  logic [2:0]  funct3;
  logic [1:0]  addr_lo;
  logic [31:0] rs2_data;
  logic [31:0] wdata;
  logic [3:0]  be;
  logic        misaligned;

  store_unit dut (
    .funct3     (funct3),
    .addr_lo    (addr_lo),
    .rs2_data   (rs2_data),
    .wdata      (wdata),
    .be         (be),
    .misaligned (misaligned)
  );

  initial begin
    rs2_data = 32'h1122_3344;

    funct3 = F3_SB;
    addr_lo = 2'b00;
    #1;
    if (wdata !== 32'h4444_4444 || be !== 4'b0001 || misaligned !== 0)
      $fatal(1, "SB lane 0 failed");

    addr_lo = 2'b10;
    #1;
    if (wdata !== 32'h4444_4444 || be !== 4'b0100 || misaligned !== 0)
      $fatal(1, "SB lane 2 failed");

    funct3 = F3_SH;
    addr_lo = 2'b00;
    #1;
    if (wdata !== 32'h3344_3344 || be !== 4'b0011 || misaligned !== 0)
      $fatal(1, "SH low half failed");

    addr_lo = 2'b10;
    #1;
    if (wdata !== 32'h3344_3344 || be !== 4'b1100 || misaligned !== 0)
      $fatal(1, "SH high half failed");

    addr_lo = 2'b01;
    #1;
    if (misaligned !== 1)
      $fatal(1, "misaligned SH not detected");

    funct3 = F3_SW;
    addr_lo = 2'b00;
    #1;
    if (wdata !== 32'h1122_3344 || be !== 4'b1111 || misaligned !== 0)
      $fatal(1, "SW failed");

    addr_lo = 2'b01;
    #1;
    if (misaligned !== 1)
      $fatal(1, "misaligned SW not detected");

    $display("tb_store_unit: PASS");
    $finish;
  end

endmodule
