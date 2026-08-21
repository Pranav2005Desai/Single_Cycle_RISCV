`timescale 1ns / 1ps

module store_unit
  import rv32_pkg::*;
(
  input  logic [2:0]  funct3,
  input  logic [1:0]  addr_lo,
  input  logic [31:0] rs2_data,
  output logic [31:0] wdata,
  output logic [3:0]  be,
  output logic        misaligned
);

  always_comb begin
    case (funct3)
      F3_SB: begin
        wdata      = {4{rs2_data[7:0]}};
        be         = 4'b0001 << addr_lo;
        misaligned = 1'b0;
      end
      F3_SH: begin
        wdata      = {2{rs2_data[15:0]}};
        be         = addr_lo[1] ? 4'b1100 : 4'b0011;
        misaligned = addr_lo[0];
      end
      F3_SW: begin
        wdata      = rs2_data;
        be         = 4'b1111;
        misaligned = |addr_lo;
      end
      default: begin
        wdata      = rs2_data;
        be         = 4'b0000;
        misaligned = 1'b1;
      end
    endcase
  end

endmodule
