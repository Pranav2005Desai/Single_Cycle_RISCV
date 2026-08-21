`timescale 1ns / 1ps

module pc_reg (
  input  logic        clk,
  input  logic        rst_n,
  output logic [31:0] pc
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      pc <= 32'h0000_0000;
    else
      pc <= pc + 32'd4;
  end

endmodule
