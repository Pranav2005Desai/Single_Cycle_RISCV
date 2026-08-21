// Hand-derived expected register state -- see test/derivation.md for the
// worked execution trace that produces every value below.
localparam int N_INST = 26;
localparam logic [31:0] EXPECTED_REGS [32] = '{
  32'h00000000, // x0  (hardwired zero)
  32'h00000005, // x1
  32'hfffffffe, // x2
  32'h00000003, // x3
  32'h00000007, // x4
  32'h00000004, // x5
  32'hffffffff, // x6
  32'hfffffffb, // x7
  32'h000000a0, // x8
  32'h07ffffff, // x9
  32'hffffffff, // x10
  32'h00000001, // x11
  32'h00000000, // x12
  32'h00000400, // x13
  32'h00000001, // x14
  32'h00000001, // x15
  32'h0000000a, // x16
  32'h0000000d, // x17
  32'h00000001, // x18
  32'h00000014, // x19
  32'h1fffffff, // x20
  32'hffffffff, // x21
  32'h00000040, // x22
  32'hfffffffe, // x23
  32'h000000fe, // x24
  32'h0000fffe, // x25
  32'h00000000, // x26 (unused)
  32'h00000000, // x27 (unused)
  32'h00000000, // x28 (unused)
  32'h00000000, // x29 (unused)
  32'h00000000, // x30 (unused)
  32'h00000000  // x31 (unused)
};
