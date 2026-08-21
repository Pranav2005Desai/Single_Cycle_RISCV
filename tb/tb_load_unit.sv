`timescale 1ns / 1ps

import rv32_pkg::*;

module tb_load_unit;

  logic [2:0]  funct3;
  logic [1:0]  addr_lo;
  logic [31:0] mem_rdata;
  logic [31:0] load_data;
  logic        misaligned;

  load_unit dut (
    .funct3     (funct3),
    .addr_lo    (addr_lo),
    .mem_rdata  (mem_rdata),
    .load_data  (load_data),
    .misaligned (misaligned)
  );

  initial begin
    mem_rdata = 32'h4433_2211;

    funct3 = F3_LW;
    addr_lo = 2'b00;
    #1;
    if (load_data !== 32'h4433_2211 || misaligned !== 0)
      $fatal(1, "LW failed");

    addr_lo = 2'b01;
    #1;
    if (misaligned !== 1)
      $fatal(1, "misaligned LW not detected");

    funct3 = F3_LBU;
    addr_lo = 2'b00;
    #1;
    if (load_data !== 32'h0000_0011 || misaligned !== 0)
      $fatal(1, "LBU byte 0 failed");

    addr_lo = 2'b10;
    #1;
    if (load_data !== 32'h0000_0033)
      $fatal(1, "LBU byte 2 failed");

    funct3 = F3_LHU;
    addr_lo = 2'b00;
    #1;
    if (load_data !== 32'h0000_2211 || misaligned !== 0)
      $fatal(1, "LHU low half failed");

    addr_lo = 2'b10;
    #1;
    if (load_data !== 32'h0000_4433 || misaligned !== 0)
      $fatal(1, "LHU high half failed");

    addr_lo = 2'b01;
    #1;
    if (misaligned !== 1)
      $fatal(1, "misaligned LHU not detected");

    $display("tb_load_unit: PASS");
    $finish;
  end

endmodule
