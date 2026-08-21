`timescale 1ns / 1ps

module rv32_core
  import rv32_pkg::*;
(
  input  logic        clk,
  input  logic        rst_n,

  output logic [31:0] imem_addr,
  input  logic [31:0] imem_rdata,

  output logic [31:0] dmem_addr,
  output logic [31:0] dmem_wdata,
  output logic        dmem_we,
  output logic [3:0]  dmem_be,
  input  logic [31:0] dmem_rdata
);

  logic [31:0] pc;
  logic [31:0] inst;

  pc_reg u_pc (
    .clk   (clk),
    .rst_n (rst_n),
    .pc    (pc)
  );

  assign imem_addr = pc;
  assign inst      = imem_rdata;


  // Instruction fields

  logic [6:0] opcode;
  logic [4:0] rd;
  logic [2:0] funct3;
  logic [4:0] rs1;
  logic [4:0] rs2;
  logic       funct7_5;

  assign opcode   = inst[6:0];
  assign rd       = inst[11:7];
  assign funct3   = inst[14:12];
  assign rs1      = inst[19:15];
  assign rs2      = inst[24:20];
  assign funct7_5 = inst[30];


  // Control

  logic    reg_write;
  logic    alu_src;
  logic    mem_read;
  logic    mem_write;
  logic    mem_to_reg;
  logic    illegal;

  alu_op_e  alu_op;
  imm_sel_e imm_sel;

  control u_control (
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


  // Register file

  logic [31:0] rs1_data;
  logic [31:0] rs2_data;
  logic [31:0] rd_data;

  regfile u_regfile (
    .clk      (clk),
    .rst_n    (rst_n),
    .rs1_addr (rs1),
    .rs1_data (rs1_data),
    .rs2_addr (rs2),
    .rs2_data (rs2_data),
    .we       (reg_write),
    .rd_addr  (rd),
    .rd_data  (rd_data)
  );


  // Immediate

  logic [31:0] imm;

  imm_gen u_imm_gen (
    .inst    (inst),
    .imm_sel (imm_sel),
    .imm     (imm)
  );


  // ALU

  logic [31:0] alu_b;
  logic [31:0] alu_y;

  assign alu_b = alu_src ? imm : rs2_data;

  alu u_alu (
    .a  (rs1_data),
    .b  (alu_b),
    .op (alu_op),
    .y  (alu_y)
  );


  // Memory

  logic [31:0] store_wdata;
  logic [31:0] load_data;

  logic [3:0] store_be;
  logic       store_mis;
  logic       load_mis;

  store_unit u_store_unit (
    .funct3     (funct3),
    .addr_lo    (alu_y[1:0]),
    .rs2_data   (rs2_data),
    .wdata      (store_wdata),
    .be         (store_be),
    .misaligned (store_mis)
  );

  load_unit u_load_unit (
    .funct3     (funct3),
    .addr_lo    (alu_y[1:0]),
    .mem_rdata  (dmem_rdata),
    .load_data  (load_data),
    .misaligned (load_mis)
  );

  assign dmem_addr  = alu_y;
  assign dmem_wdata = store_wdata;
  assign dmem_we    = mem_write;
  assign dmem_be    = mem_write ? store_be : 4'b0000;


  // Writeback

  assign rd_data = mem_to_reg ? load_data : alu_y;


  // Checks

  // synthesis translate_off

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin

    end
    else begin
      if (illegal)
        $error("core: illegal instruction 0x%08h at pc 0x%08h",
               inst, pc);

      if (mem_write && store_mis)
        $error("core: misaligned store to 0x%08h at pc 0x%08h",
               alu_y, pc);

      if (mem_read && load_mis)
        $error("core: misaligned load from 0x%08h at pc 0x%08h",
               alu_y, pc);
    end
  end

  // synthesis translate_on

endmodule
