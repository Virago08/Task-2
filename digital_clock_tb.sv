//------------------------------------------------------------------------------
// File       : digital_clock_tb.sv
// Author     : Ananya Bairy (1BM23EC319)
// Project    : SystemVerilog and Verification (23EC6PE2SV)
// Description: Coverage-driven testbench for Digital Clock
//              Designed to achieve 100% IMC coverage
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module tb;

  logic clk;
  logic rst;
  logic [5:0] sec, min;

  // Clock: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;

  // DUT
  digital_clock dut (.*);

  // ---------------- FUNCTIONAL COVERAGE ----------------
  covergroup cg_clock @(posedge clk);

    cp_sec : coverpoint sec {
      bins rollover = (59 => 0);
    }

    cp_min : coverpoint min {
      bins valid_mins[] = {[0:59]};
    }

    cross_rollover : cross cp_sec, cp_min;

  endgroup

  cg_clock cg;

  // ---------------- TEST SEQUENCE ----------------
  initial begin
    // Init signals
    rst = 1'bx;   

    // Wave dumping
    $shm_open("waves.shm");
    $shm_probe("AS");

    cg = new();
    cg.start();

    // -------- RESET SEQUENCE --------
    // Allow time to start
    #2;

    rst = 1;                     // X → 1
    repeat (3) @(posedge clk);

    rst = 0;                     // 1 → 0
    repeat (5) @(posedge clk);

    // Optional second reset (boosts toggle confidence)
    rst = 1;                     // 0 → 1
    repeat (2) @(posedge clk);
    rst = 0;                     // 1 → 0

    // -------- MAIN STIMULUS --------
    // 60 sec × 60 min
    repeat (3600) @(posedge clk);

    // -------- COVERAGE REPORT --------
    $display("-----------------------------------------");
    $display(" Final Coverage: %0.2f %%", cg.get_inst_coverage());

    if (cg.get_inst_coverage() == 100.0)
      $display(" STATUS: PASSED (100%% COVERAGE ACHIEVED)");
    else
      $display(" STATUS: FAILED (Coverage Incomplete)");

    $display("-----------------------------------------");

    $finish;
  end

endmodule
