`timescale 1ns / 1ps

module dmem (
  input  logic        clk,
  input  logic [31:0] addr,
  input  logic [31:0] wdata,
  input  logic        we,
  input  logic [3:0]  be,
  output logic [31:0] rdata
);

  logic [31:0] mem [1024];
  logic [9:0]  idx;

  assign idx = addr[11:2];

  initial begin
    for (int i = 0; i < 1024; i++)
      mem[i] = 32'd0;
  end

  assign rdata = mem[idx];

  always_ff @(posedge clk) begin
    if (we) begin
      for (int b = 0; b < 4; b++) begin
        if (be[b])
          mem[idx][8*b +: 8] <= wdata[8*b +: 8];
      end
    end
  end

endmodule
