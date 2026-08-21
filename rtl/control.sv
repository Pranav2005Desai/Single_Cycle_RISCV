`timescale 1ns / 1ps

module control
  import rv32_pkg::*;
(
  input  logic [6:0]  opcode,
  input  logic [2:0]  funct3,
  input  logic        funct7_5,

  output logic        reg_write,
  output logic        alu_src,
  output logic        mem_read,
  output logic        mem_write,
  output logic        mem_to_reg,
  output alu_op_e     alu_op,
  output imm_sel_e    imm_sel,
  output logic        illegal
);

  logic is_arith;

  assign is_arith = (opcode == OP_RTYPE) || (opcode == OP_ITYPE);

  always_comb begin

    reg_write  = 1'b0;
    alu_src    = 1'b0;
    mem_read   = 1'b0;
    mem_write  = 1'b0;
    mem_to_reg = 1'b0;
    imm_sel    = IMM_I;
    illegal    = 1'b0;

    case (opcode)

      OP_RTYPE: begin
        reg_write = 1'b1;
      end

      OP_ITYPE: begin
        reg_write = 1'b1;
        alu_src   = 1'b1;
        imm_sel   = IMM_I;
      end

      OP_LOAD: begin
        reg_write  = 1'b1;
        alu_src    = 1'b1;
        mem_read   = 1'b1;
        mem_to_reg = 1'b1;
        imm_sel    = IMM_I;
      end

      OP_STORE: begin
        alu_src   = 1'b1;
        mem_write = 1'b1;
        imm_sel   = IMM_S;
      end

      default: illegal = 1'b1;

    endcase
  end

  always_comb begin

    alu_op = ALU_ADD;

    if (is_arith) begin

      case (funct3)

        F3_ADD_SUB:
          alu_op = (funct7_5 && (opcode == OP_RTYPE))
                   ? ALU_SUB : ALU_ADD;

        F3_SLL:
          alu_op = ALU_SLL;

        F3_SLT:
          alu_op = ALU_SLT;

        F3_SLTU:
          alu_op = ALU_SLTU;

        F3_XOR:
          alu_op = ALU_XOR;

        F3_SRL_SRA:
          alu_op = funct7_5 ? ALU_SRA : ALU_SRL;

        F3_OR:
          alu_op = ALU_OR;

        F3_AND:
          alu_op = ALU_AND;

        default:
          alu_op = ALU_ADD;

      endcase

    end

  end

endmodule
