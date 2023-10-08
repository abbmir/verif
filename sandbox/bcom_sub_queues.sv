// Given an queue of fixed size 16: int given_q[$] = {0..15}; 
// 
// split this given q, into sub-queues g[$][$] randomly. 
// each sub-queue g[$] will randomly be of size {1,2,4,8,16} only. 
// 
// Each element of given_q is assigned sequentially to each sub-queue, based on the size of each sub-queue. 
// 
// Key thing is each sub-queue should be of random size, but the total number of elements in all the sub-queues is equal to given_q.size=16. 

// For example: 
// 
// sub_queue_sizes[$]={8,8} 
// g[0]={0..7}, g[1]={8..15} 
// 
// sub_queue_sizes[$]={4,4,8} 
// g[0]={0..3}, g[1]={4..7}, g[2]={8..15} 
// 
// sub_queue_sizes[$]={8,8,4} 
// g[0]={0..7}, g[1]={8..11}, g[2]={12..15} 
// 
// sub_queue_sizes[$]={2, 2, 4,8} 
// g[0]={0,1}, g[1]={2..3}, g[2]={4..7}, g[3]={8..15} 
// 
// sub_queue_sizes[$]={4, 4, 4, 4} 
// g[0]={0..3}, g[1]={4..7}, g[2]={8..11}, g[3]={12..15} 
// 
// sub_queue_sizes[$]={8, 4, 2, 2} 
// g[0]={0..7}, g[1]={8..11}, g[1]={12,13}, g[3]={14,15}
// For example: 
// 
// sub_queue_sizes[$]={8,8} 
// g[0]={0..7}, g[1]={8..15} 
// 
// sub_queue_sizes[$]={4,4,8} 
// g[0]={0..3}, g[1]={4..7}, g[2]={8..15} 
// 
// sub_queue_sizes[$]={8,8,4} 
// g[0]={0..7}, g[1]={8..11}, g[2]={12..15} 
// 
// sub_queue_sizes[$]={2, 2, 4,8} 
// g[0]={0,1}, g[1]={2..3}, g[2]={4..7}, g[3]={8..15} 
// 
// sub_queue_sizes[$]={4, 4, 4, 4} 
// g[0]={0..3}, g[1]={4..7}, g[2]={8..11}, g[3]={12..15} 
// 
// sub_queue_sizes[$]={8, 4, 2, 2} 
// g[0]={0..7}, g[1]={8..11}, g[1]={12,13}, g[3]={14,15}

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    int given_q[$] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
    int g[$][$];
    rand int sub_queue_sizes [$];
    
    
    `uvm_object_utils_begin(constraint1)
      `uvm_field_sarray_int(sub_queue_sizes, UVM_HEX | UVM_ALL_ON)
      //`uvm_field_sarray_int(g, UVM_HEX | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld {

      sub_queue_sizes.size() inside {[1:16]};
      foreach (sub_queue_sizes[i]) 
        sub_queue_sizes[i] inside {1,2,4,8,16};
      
      // This is explained in section 7.12.3 Array reduction methods of the 1800-2017 LRM.  
      //sub_queue_sizes.sum() with (32'(item)) == 32'h0000_0010 ;  //hex equivalent of dec 16 
      
      sub_queue_sizes.sum() == 16;
    }

    constraint sum_c { 
      
      //sub_queue_sizes.size == 10;
      // You need to cast
      //sub_queue_sizes.sum() with (4'(item)) == 4'h6; 
    }
    
    function void post_randomize();
        for (int i=0; i<sub_queue_sizes.size; i++)
          for (int j=0; j<sub_queue_sizes[i]; j++)
             g[i][j] = given_q[i+j];

    endfunction
  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 15; i++) begin
      
      void'(m_vec.randomize());
      $display("RAND %p", m_vec.sprint());
      
    end
    
  end
  
endmodule