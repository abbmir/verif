// Code your testbench here
// or browse Examples


// rand to randc
// value should not repeat until all values are see
module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    rand bit [3:0] rand_var;
         bit [3:0] rand_q [$];
    
    
    `uvm_object_utils_begin(constraint1)
    `uvm_field_int(rand_var, UVM_HEX | UVM_ALL_ON)
    `uvm_field_array_int(rand_q, UVM_HEX | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld {
      foreach (rand_q[i]) 
        rand_var != rand_q[i];
    }

    function void post_randomize();
       rand_q.push_back(rand_var);
    endfunction 
    
  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 16; i++) begin
      
      void'(m_vec.randomize());
      $display("RAND %p", m_vec.sprint());
      
    end
    
  end
  
endmodule
