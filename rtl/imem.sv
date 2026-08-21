`timescale 1ns / 1ps

module imem (
  input  logic [31:0] addr,
  output logic [31:0] rdata
);

  logic [31:0] mem [1024];

  initial begin
    for (int i = 0; i < 1024; i++)
      mem[i] = 32'h0000_0013;

    $readmemh("test/prog.hex", mem);
  end

  assign rdata = mem[addr[11:2]];

  always_comb begin
    if (addr[1:0] != 2'b00)
      $error("imem: misaligned fetch at 0x%08h", addr);
  end

endmodule
