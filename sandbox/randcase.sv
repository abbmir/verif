// Write a constraint to generate a random value for a ver1[7:0] within 50
// and var2 with non repeated value in every randomization

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
    
  initial begin
    //constraint1 m_vec = new();
    
    for (int i=0; i < 16; i++) begin
      
      randcase
        1 : $display("1 Wt");
        5 : $display("5 Wt");
        3 : $display("3 Wt");
      endcase
    end
    
  end
  
endmodule
