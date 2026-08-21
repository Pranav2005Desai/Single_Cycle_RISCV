`timescale 1ns / 1ps

module tb_dmem;

  logic clk;
  logic [31:0] addr;
  logic [31:0] wdata;
  logic        we;
  logic [3:0]  be;
  logic [31:0] rdata;

  dmem dut (
    .clk   (clk),
    .addr  (addr),
    .wdata (wdata),
    .we    (we),
    .be    (be),
    .rdata (rdata)
  );

  initial clk = 1'b0;
  always #5 clk = ~clk;

  task write_word(input logic [31:0] a, input logic [31:0] d);
    begin
      addr = a;
      wdata = d;
      be = 4'b1111;
      we = 1'b1;
      @(posedge clk);
      #1;
      we = 1'b0;
    end
  endtask

  initial begin
    addr = 0;
    wdata = 0;
    we = 0;
    be = 0;

    #1;
    if (rdata !== 32'd0)
      $fatal(1, "memory did not start at zero");

    write_word(32'h0, 32'h1122_3344);

    addr = 32'h0;
    #1;
    if (rdata !== 32'h1122_3344)
      $fatal(1, "word write failed");

    addr = 32'h0;
    wdata = 32'h0000_00aa;
    be = 4'b0001;
    we = 1'b1;
    @(posedge clk);
    #1;
    we = 1'b0;

    if (rdata !== 32'h1122_33aa)
      $fatal(1, "byte write failed: %h", rdata);

    addr = 32'h0;
    wdata = 32'h0000_bb00;
    be = 4'b0010;
    we = 1'b1;
    @(posedge clk);
    #1;
    we = 1'b0;

    if (rdata !== 32'h1122_bbaa)
      $fatal(1, "second byte write failed: %h", rdata);

    $display("tb_dmem: PASS");
    $finish;
  end

endmodule