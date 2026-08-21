`timescale 1ns / 1ps

package rv32_pkg;

  // Opcodes

  localparam logic [6:0] OP_RTYPE = 7'b0110011;
  localparam logic [6:0] OP_ITYPE = 7'b0010011;
  localparam logic [6:0] OP_LOAD  = 7'b0000011;
  localparam logic [6:0] OP_STORE = 7'b0100011;


  // ALU funct3

  localparam logic [2:0] F3_ADD_SUB = 3'b000;
  localparam logic [2:0] F3_SLL     = 3'b001;
  localparam logic [2:0] F3_SLT     = 3'b010;
  localparam logic [2:0] F3_SLTU    = 3'b011;
  localparam logic [2:0] F3_XOR     = 3'b100;
  localparam logic [2:0] F3_SRL_SRA = 3'b101;
  localparam logic [2:0] F3_OR      = 3'b110;
  localparam logic [2:0] F3_AND     = 3'b111;


  // Load funct3

  localparam logic [2:0] F3_LW  = 3'b010;
  localparam logic [2:0] F3_LBU = 3'b100;
  localparam logic [2:0] F3_LHU = 3'b101;


  // Store funct3

  localparam logic [2:0] F3_SB = 3'b000;
  localparam logic [2:0] F3_SH = 3'b001;
  localparam logic [2:0] F3_SW = 3'b010;


  // ALU operations

  typedef enum logic [3:0] {
    ALU_ADD  = 4'd0,
    ALU_SUB  = 4'd1,
    ALU_SLL  = 4'd2,
    ALU_SLT  = 4'd3,
    ALU_SLTU = 4'd4,
    ALU_XOR  = 4'd5,
    ALU_SRL  = 4'd6,
    ALU_SRA  = 4'd7,
    ALU_OR   = 4'd8,
    ALU_AND  = 4'd9
  } alu_op_e;


  // Immediate formats

  typedef enum logic {
    IMM_I = 1'b0,
    IMM_S = 1'b1
  } imm_sel_e;

endpackage
