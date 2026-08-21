`timescale 1ns / 1ps

module tb_imem;

  logic [31:0] addr;
  logic [31:0] rdata;

  imem dut (
    .addr  (addr),
    .rdata (rdata)
  );

  initial begin
    // imem always loads test/prog.hex, so check the first instructions.
    addr = 32'h0;
    #1;
    if (rdata !== 32'h0050_0093)
      $fatal(1, "word 0 is wrong: %h", rdata);

    addr = 32'h4;
    #1;
    if (rdata !== 32'hffe0_0113)
      $fatal(1, "word 1 is wrong: %h", rdata);

    addr = 32'hc;
    #1;
    if (rdata !== 32'h4020_8233)
      $fatal(1, "word 3 is wrong: %h", rdata);

    // The program is 26 words, so past that the NOP fill remains.
    addr = 32'd200;
    #1;
    if (rdata !== 32'h0000_0013)
      $fatal(1, "NOP fill is wrong: %h", rdata);

    $display("tb_imem: PASS");
    $finish;
  end

endmodule