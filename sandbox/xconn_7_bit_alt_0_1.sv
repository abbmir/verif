module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    //rand int unsigned addr[];
    rand bit [31:0] addr;
    //rand int unsigned end_addr;
    
    
    `uvm_object_utils_begin(constraint1)
    `uvm_field_int(addr, UVM_BIN | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld {
      $countones(addr) == 7;
      foreach(addr[i])
        if (addr[i])
          if (i>0)
            addr[i] != addr[i-1];
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