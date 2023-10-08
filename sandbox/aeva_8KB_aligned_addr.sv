// Code your testbench here
// or browse Examples


// Constraint 7 consecutive bits
// 8GB of memory
// simple reads and writes 
// 8K boundary aligned
// +/- 10 

//1G 30 bits
//4G 32 bits
//8G 33 bits


module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    //rand int unsigned addr[];
    rand bit [32:0] addr;
    //rand int unsigned end_addr;
    
    
    `uvm_object_utils_begin(constraint1)
    `uvm_field_int(addr, UVM_HEX | UVM_ALL_ON)
    //`uvm_field_int(end_addr, UVM_HEX | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld {
      addr inside {[addr-10:addr+10]};
      addr[12:0] == 0; // 8KB aligned
      
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
