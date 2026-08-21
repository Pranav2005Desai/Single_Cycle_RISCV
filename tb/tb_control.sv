`timescale 1ns / 1ps

import rv32_pkg::*;

module tb_control;

  logic [6:0] opcode;
  logic [2:0] funct3;
  logic       funct7_5;

  logic    reg_write;
  logic    alu_src;
  logic    mem_read;
  logic    mem_write;
  logic    mem_to_reg;
  logic    illegal;
  alu_op_e  alu_op;
  imm_sel_e imm_sel;

  control dut (
    .opcode     (opcode),
    .funct3     (funct3),
    .funct7_5   (funct7_5),
    .reg_write  (reg_write),
    .alu_src    (alu_src),
    .mem_read   (mem_read),
    .mem_write  (mem_write),
    .mem_to_reg (mem_to_reg),
    .alu_op     (alu_op),
    .imm_sel    (imm_sel),
    .illegal    (illegal)
  );

  task check(
    input logic exp_reg_write,
    input logic exp_alu_src,
    input logic exp_mem_read,
    input logic exp_mem_write,
    input logic exp_mem_to_reg,
    input alu_op_e exp_alu_op,
    input imm_sel_e exp_imm_sel,
    input logic exp_illegal
  );
    #1;
    if (reg_write !== exp_reg_write ||
        alu_src !== exp_alu_src ||
        mem_read !== exp_mem_read ||
        mem_write !== exp_mem_write ||
        mem_to_reg !== exp_mem_to_reg ||
        alu_op !== exp_alu_op ||
        imm_sel !== exp_imm_sel ||
        illegal !== exp_illegal) begin
      $display("FAIL opcode=%b funct3=%b f7_5=%b",
               opcode, funct3, funct7_5);
      $display("got: rw=%b as=%b mr=%b mw=%b m2r=%b alu=%0d imm=%0d ill=%b",
               reg_write, alu_src, mem_read, mem_write,
               mem_to_reg, alu_op, imm_sel, illegal);
      $fatal;
    end
  endtask

  initial begin
    opcode = OP_RTYPE;
    funct3 = F3_ADD_SUB;
    funct7_5 = 1'b0;
    check(1,0,0,0,0,ALU_ADD,IMM_I,0);

    funct7_5 = 1'b1;
    check(1,0,0,0,0,ALU_SUB,IMM_I,0);

    opcode = OP_ITYPE;
    funct3 = F3_ADD_SUB;
    funct7_5 = 1'b1;
    check(1,1,0,0,0,ALU_ADD,IMM_I,0);

    funct3 = F3_SRL_SRA;
    funct7_5 = 1'b0;
    check(1,1,0,0,0,ALU_SRL,IMM_I,0);

    funct7_5 = 1'b1;
    check(1,1,0,0,0,ALU_SRA,IMM_I,0);

    opcode = OP_LOAD;
    funct3 = F3_LW;
    funct7_5 = 1'b0;
    check(1,1,1,0,1,ALU_ADD,IMM_I,0);

    opcode = OP_STORE;
    funct3 = F3_SW;
    check(0,1,0,1,0,ALU_ADD,IMM_S,0);

    opcode = 7'b1111111;
    check(0,0,0,0,0,ALU_ADD,IMM_I,1);

    $display("tb_control: PASS");
    $finish;
  end

endmodule
