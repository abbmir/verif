// Code your testbench here
// or browse Examples


// 1-bit toggle
// addr[0] = 'h0001
// addr[1] = 'h8000
module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    //rand int unsigned addr[];
    rand bit [3:0] data[];
    
    `uvm_object_utils_begin(constraint1)
    `uvm_field_array_int(data, UVM_HEX | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld {
      data.size == 15;
      foreach (data[i]) {
        if (i>0)
          data[i] > data[i-1];
      }
      
    }

    function void post_randomize();
        data.shuffle();
    endfunction
    
  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 1; i++) begin
      
      void'(m_vec.randomize());
      $display("RAND %p", m_vec.sprint());
      
    end
    
  end
  
endmodule
