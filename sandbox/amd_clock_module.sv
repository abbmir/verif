// Code your testbench here
// or browse Examples


// REF clk pll will generate the clock
`timescale 1ns/1ps

module clock_module (output reg clock);
  
  parameter FREQ = 100000; // KHz
  parameter PHASE = 0;     // degress
  parameter DUTY = 25;     // in %
  parameter JITTER = 4;       //will generate random value between -4 to 4

  real clk_per = 1.0/(FREQ * 1e3) * 1e9;
  real dly = PHASE / 90;
  
  
  real clk_on = DUTY/ 100.0 * clk_per;
  real clk_off = (100 - DUTY) / 100.0 * clk_per;


  reg start_clk;
  
  initial begin
     clock = 0;
     start_clk = 1;
  end
  
  always begin 
    #(dly) start_clk = 1;
    #(dly) start_clk = 0;
  end

  always @(posedge start_clk)
    if (start_clk) begin
      clock = 1;

      while (start_clk) begin
        #(clk_on) clock = 0;
        #(clk_off) clock = 1;
      end
    end
  // Add a JITTER
  // #(period/2 + $random %(JITTER)) clk <= ~clk; 
  //always #(80+$dist_uniform(seed,-JITTER,JITTER)/1000.0) clk0=~clk0;
  
endmodule

module top();
  reg clk;
  
  clock_module DUT(clk);

  initial begin
    
    #100us;
    $finish ;
  end
endmodule

