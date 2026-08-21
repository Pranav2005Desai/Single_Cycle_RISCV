`timescale 1ns / 1ps

module load_unit
  import rv32_pkg::*;
(
  input  logic [2:0]  funct3,
  input  logic [1:0]  addr_lo,
  input  logic [31:0] mem_rdata,
  output logic [31:0] load_data,
  output logic        misaligned
);

  logic [7:0]  byte_sel;
  logic [15:0] half_sel;

  assign byte_sel = mem_rdata[8*addr_lo +: 8];
  assign half_sel = addr_lo[1] ? mem_rdata[31:16] : mem_rdata[15:0];

  always_comb begin

    load_data  = 32'd0;
    misaligned = 1'b0;

    case (funct3)

      F3_LW: begin
        load_data  = mem_rdata;
        misaligned = |addr_lo;
      end

      F3_LBU: begin
        load_data = {24'd0, byte_sel};
      end

      F3_LHU: begin
        load_data  = {16'd0, half_sel};
        misaligned = addr_lo[0];
      end

      default: begin
        load_data  = 32'd0;
        misaligned = 1'b1;
      end

    endcase

  end

endmodule
