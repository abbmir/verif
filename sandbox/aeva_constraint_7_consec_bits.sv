// Code your testbench here
// or browse Examples


// Constraint 7 consecutive bits
//#   addr             integral     32    'b11111110000000000000000
//#   addr             integral     32    'b11111110000000000000000000


module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    //rand int unsigned addr[];
    rand bit [31:0] addr;
    rand int N;
    //rand int unsigned end_addr;
    
    
    `uvm_object_utils_begin(constraint1)
    `uvm_field_int(addr, UVM_BIN | UVM_ALL_ON)
    `uvm_field_int(N, UVM_DEC | UVM_ALL_ON)
    //`uvm_field_int(end_addr, UVM_HEX | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld {
      N inside {[0:25]};
      addr == 'h7f << N;
      
    }
    
  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 10; i++) begin
      
      void'(m_vec.randomize());
      $display("RAND %p", m_vec.sprint());
      
    end
    
  end
  
endmodule
