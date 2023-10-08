// Code your testbench here
// or browse Examples


// Only 5 bits are 1 in the entire array

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    //rand int unsigned addr[];
    rand bit data[];
    
    `uvm_object_utils_begin(constraint1)
    `uvm_field_array_int(data, UVM_BIN | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld {
      data.size == 10;
                      // You need to cast
      data.sum() with (4'(item)) == 4'h5; // This is explained in section 7.12.3 Array reduction methods of the 1800-2017 LRM.
      
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
