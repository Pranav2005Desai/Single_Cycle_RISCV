`timescale 1ns / 1ps

package rv32_pkg;

  // Opcodes
  typedef enum logic [6:0] {
   
    //R TYPE
    OP_OP       = 7'b0110011,
    
    //I TYPE
    OP_OP_IMM   = 7'b0010011,
    OP_LOAD     = 7'b0000011,
    OP_MISC_MEM = 7'b0001111,
    OP_JALR     = 7'b1100111,
    OP_SYS      = 7'b1110011,
    
    //S TYPE
    OP_STORE    = 7'b0100011,
    
    //B TYPE
    OP_BRANCH   = 7'b1100011,
    
    //J TYPE
    OP_JAL      = 7'b1101111,
    
    //U TYPE
    OP_LUI      = 7'b0110111,
    OP_AUIPC    = 7'b0010111
  
  } OP_Code;
 
  //Funct3

  // ALU funct3
  typedef enum logic [2:0] {
    F3_ADD_SUB = 3'b000,
    F3_SLL     = 3'b001,
    F3_SLT     = 3'b010,
    F3_SLTU    = 3'b011,
    F3_XOR     = 3'b100,
    F3_SRL_SRA = 3'b101,
    F3_OR      = 3'b110,
    F3_AND     = 3'b111
  } FUN3_ALU;


  // Load funct3
  typedef enum logic [2:0] {
    F3_LB  = 3'b000,
    F3_LH  = 3'b001,
    F3_LW  = 3'b010,
    F3_LBU = 3'b100,
    F3_LHU = 3'b101
  } FUN3_Load;


  // Store funct3
  typedef enum logic [2:0] {
    F3_SB = 3'b000,
    F3_SH = 3'b001,
    F3_SW = 3'b010
  } FUN3_Store;


  // Branch funct3
  typedef enum logic [2:0] {
    F3_BEQ  = 3'b000,
    F3_BNE  = 3'b001,
    F3_BLT  = 3'b100,
    F3_BGE  = 3'b101,
    F3_BLTU = 3'b110,
    F3_BGEU = 3'b111
  } FUN3_Branch;


  //Funct7
  typedef enum logic [6:0] {
    F7_BASE = 7'b0000000,
    F7_ALT  = 7'b0100000
  } FUN7;


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
