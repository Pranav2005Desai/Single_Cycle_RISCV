`timescale 1ns / 1ps

module tb_regfile;

  logic clk;
  logic rst_n;

  logic [4:0]  rs1_addr;
  logic [31:0] rs1_data;
  logic [4:0]  rs2_addr;
  logic [31:0] rs2_data;

  logic        we;
  logic [4:0]  rd_addr;
  logic [31:0] rd_data;

  regfile dut (
    .clk      (clk),
    .rst_n    (rst_n),
    .rs1_addr (rs1_addr),
    .rs1_data (rs1_data),
    .rs2_addr (rs2_addr),
    .rs2_data (rs2_data),
    .we       (we),
    .rd_addr  (rd_addr),
    .rd_data  (rd_data)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 1'b0;
    we = 1'b0;
    rs1_addr = 0;
    rs2_addr = 0;
    rd_addr = 0;
    rd_data = 0;

    #1;

    if (rs1_data !== 0 || rs2_data !== 0)
      $fatal(1, "reset failed");

    rst_n = 1'b1;

    rd_addr = 5'd5;
    rd_data = 32'h1234_5678;
    we = 1'b1;

    @(posedge clk);
    #1;
    we = 1'b0;

    rs1_addr = 5'd5;
    #1;

    if (rs1_data !== 32'h1234_5678)
      $fatal(1, "register write failed");

    rd_addr = 5'd0;
    rd_data = 32'hffff_ffff;
    we = 1'b1;

    @(posedge clk);
    #1;
    we = 1'b0;

    rs1_addr = 5'd0;
    rs2_addr = 5'd0;
    #1;

    if (rs1_data !== 32'd0 || rs2_data !== 32'd0)
      $fatal(1, "x0 changed");

    $display("tb_regfile: PASS");
    $finish;
  end

endmodule
