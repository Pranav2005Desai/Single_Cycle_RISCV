`timescale 1ns / 1ps

module rv32_top (
  input logic clk,
  input logic rst_n
);

  logic [31:0] imem_addr;
  logic [31:0] imem_rdata;

  logic [31:0] dmem_addr;
  logic [31:0] dmem_wdata;
  logic [31:0] dmem_rdata;
  logic        dmem_we;
  logic [3:0]  dmem_be;


  rv32_core u_core (
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


  imem u_imem (
    .addr  (imem_addr),
    .rdata (imem_rdata)
  );


  dmem u_dmem (
    .clk   (clk),
    .addr  (dmem_addr),
    .wdata (dmem_wdata),
    .we    (dmem_we),
    .be    (dmem_be),
    .rdata (dmem_rdata)
  );

endmodule
