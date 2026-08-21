`timescale 1ns / 1ps

module imm_gen
  import rv32_pkg::*;
(
  input  logic [31:0] inst,
  input  imm_sel_e    imm_sel,
  output logic [31:0] imm
);

  logic [31:0] imm_i;
  logic [31:0] imm_s;

  assign imm_i = {{20{inst[31]}}, inst[31:20]};
  assign imm_s = {{20{inst[31]}}, inst[31:25], inst[11:7]};

  always_comb begin
    case (imm_sel)

      IMM_I:   imm = imm_i;
      IMM_S:   imm = imm_s;

      default: imm = 32'd0;

    endcase
  end

endmodule
