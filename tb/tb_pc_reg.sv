`timescale 1ns / 1ps

module tb_pc_reg;

  logic clk;
  logic rst_n;
  logic [31:0] pc;

  pc_reg dut (
    .clk   (clk),
    .rst_n (rst_n),
    .pc    (pc)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 1'b0;
    #1;

    if (pc !== 32'h0000_0000)
      $fatal(1, "reset address is wrong: %h", pc);

    rst_n = 1'b1;

    @(posedge clk);
    #1;
    if (pc !== 32'h0000_0004)
      $fatal(1, "PC did not increment: %h", pc);

    @(posedge clk);
    #1;
    if (pc !== 32'h0000_0008)
      $fatal(1, "PC did not increment again: %h", pc);

    rst_n = 1'b0;
    #1;
    if (pc !== 32'h0000_0000)
      $fatal(1, "reset did not work");

    $display("tb_pc_reg: PASS");
    $finish;
  end

endmodule