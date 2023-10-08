//Can anyone plz help me with this constraint question...
//Take a rand variable with array size 10,need to get unique values in each location without using unique keyword 
//and for any of 2 locations we need to get same value?

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    rand int addr[];
         int addr_q[$];
    rand int idx1, idx2;    
    
    `uvm_object_utils_begin(constraint1)
      `uvm_field_array_int(addr, UVM_DEC | UVM_ALL_ON)
      `uvm_field_sarray_int(addr_q, UVM_DEC | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld {
      addr.size == 10; // Construct the array size
      foreach (addr[i]) 
        addr[i] inside {[0:100]};
      foreach (addr[i]) 
        if (i > 0)
          addr[i-1] < addr[i]; // generate random ascending array elements
      idx1 inside {[0:9]};
      idx2 inside {[0:9]};
      idx1 != idx2;
    }

    function void post_randomize();
      foreach(addr[i])
        addr_q.push_back(addr[i]);
      
      addr_q.shuffle();
      addr_q[idx1] = addr_q[idx2];
    endfunction 
    
  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 1; i++) begin
      
      void'(m_vec.randomize());
      //$display("RAND %p", m_vec.sprint());
      $display("RAND\n %p", m_vec);
      
    end
    
  end
  
endmodule
