// Write a constraint to generate 34 to 43 without inside


module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    rand int var1;
         int iter;
         int var1_q[$];
    
    `uvm_object_utils_begin(constraint1)
    `uvm_field_int(var1, UVM_DEC | UVM_ALL_ON)
    `uvm_field_array_int(var1_q, UVM_HEX | UVM_ALL_ON)
    `uvm_object_utils_end
    
    //function void pre_randomize();
    //    var1_q.delete();
    //    for (int i=34; i <=43; i++)
    //        var1_q.push_back(i);
    //endfunction

    constraint c_vld {
        var1 >= 34 && var1 <= 43;
    }

   //function void post_randomize();
   //   rand_q.push_back(rand_var);
   //endfunction 
    
  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 16; i++) begin
      
      void'(m_vec.randomize());
      $display("RAND %p", m_vec.sprint());
      
    end
    
  end
  
endmodule
