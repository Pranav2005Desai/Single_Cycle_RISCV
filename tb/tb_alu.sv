`timescale 1ns / 1ps

import rv32_pkg::*;

module tb_alu;

  logic [31:0] a, b;
  alu_op_e op;
  logic [31:0] y;

  alu dut (
    .a  (a),
    .b  (b),
    .op (op),
    .y  (y)
  );

  task check(input logic [31:0] exp);
    #1;
    if (y !== exp) begin
      $display("FAIL a=%h b=%h op=%0d got=%h expected=%h",
               a, b, op, y, exp);
      $fatal;
    end
  endtask

  initial begin
    a = 32'd10; b = 32'd3;

    op = ALU_ADD;  check(32'd13);
    op = ALU_SUB;  check(32'd7);
    op = ALU_SLL;  check(32'd80);
    op = ALU_SLT;  check(32'd0);
    op = ALU_SLTU; check(32'd0);
    op = ALU_XOR;  check(32'd9);
    op = ALU_SRL;  check(32'd1);
    op = ALU_SRA;  check(32'd1);
    op = ALU_OR;   check(32'd11);
    op = ALU_AND;  check(32'd2);

    a = 32'hffff_fffd;
    b = 32'd10;

    op = ALU_SLT;
    check(32'd1);

    op = ALU_SLTU;
    check(32'd0);

    a = 32'h8000_0000;
    b = 32'd1;

    op = ALU_SRL;
    check(32'h4000_0000);

    op = ALU_SRA;
    check(32'hc000_0000);

    $display("tb_alu: PASS");
    $finish;
  end

endmodule
