//------------------------------------------------------------------------------
//File       : digital_clock.sv
//Author     : Ananya Bairy (1BM23EC319)
//Created    : 2026-02-10
//Module     : digital_clock
//Project    : SystemVerilog and Verification (23EC6PE2SV),
//Faculty    : Prof. Ajaykumar Devarapalli
//Description: Basic Digital Clock used for basic functional coverage example.
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module digital_clock(
  input  logic clk,
  input  logic rst,
  output logic [5:0] sec,
  output logic [5:0] min
);

  // Seconds Logic
  always_ff @(posedge clk) begin
    if (rst)
      sec <= 0;
    else if (sec == 59)
      sec <= 0;
    else
      sec <= sec + 1;
  end

  // Minutes Logic
  always_ff @(posedge clk) begin
    if (rst)
      min <= 0;
    else if (sec == 59) begin
      if (min == 59)
        min <= 0;
      else
        min <= min + 1;
    end
    else
      min <= min;   
  end

endmodule
