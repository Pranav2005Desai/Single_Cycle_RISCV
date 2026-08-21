`timescale 1ns / 1ps

module alu

  import rv32_pkg::*;

(
  input  logic [31:0] a,
  input  logic [31:0] b,
  input  alu_op_e     op,
  output logic [31:0] y
);

  logic signed [31:0] a_s, b_s;

  assign a_s = a;
  assign b_s = b;

  always_comb begin

    case (op)

      ALU_ADD:  y = a + b;
      ALU_SUB:  y = a - b;

      ALU_SLL:  y = a << b[4:0];

      ALU_SLT:  y = {31'd0, (a_s < b_s)};
      ALU_SLTU: y = {31'd0, (a < b)};

      ALU_XOR:  y = a ^ b;

      ALU_SRL:  y = a >> b[4:0];
      ALU_SRA:  y = a_s >>> b[4:0];

      ALU_OR:   y = a | b;
      ALU_AND:  y = a & b;

      default:  y = 32'd0;

    endcase

  end

endmodule
