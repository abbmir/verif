//Can anyone plz help me with this constraint question...
//Take a rand variable with array size 10,need to get unique values in each location without using unique keyword 
//and for any of 2 locations we need to get same value?

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"

  initial begin
    byte loop = 5;
    
    repeat (loop) begin
      $display("hello, %0d", loop); // 5, 4, 3, 2, 1
      loop -= 1;
    end
  end
  
endmodule
