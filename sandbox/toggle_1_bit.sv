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
    rand bit [3:0] addr[];
    //rand int unsigned end_addr;
    
    
    `uvm_object_utils_begin(constraint1)
    `uvm_field_array_int(addr, UVM_BIN | UVM_ALL_ON)
    //`uvm_field_int(end_addr, UVM_HEX | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld {
      addr.size == 32;
      foreach (addr[i]) {
        if (i>0)
          $countones (addr[i] ^ addr[i-1]) == 1;
      }
      
    }
    
  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 1; i++) begin
      
      void'(m_vec.randomize());
      $display("RAND %p", m_vec.sprint());
      
    end
    
  end
  
endmodule
