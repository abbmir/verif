//
//There are 5 component ( COMP0, COMP1, COMP2, COMP3, COMP4) and 3 DMA ( DMA0, DMA1, DMA2)engine.
//
//Any number of DMA engine can be enabled.
//Enabled DMA should select at least 1 COMP.
//
//rand bit[2:0] dma_en;
//rand comp[3][];
//
//dma_en[i] -> {}; 

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1; //extends uvm_sequence_item;
    
    rand bit[2:0] dma_en;
    rand bit comp[3][5];
    
    //`uvm_object_utils_begin(constraint1)
    //`uvm_field_int(var1, UVM_HEX | UVM_ALL_ON)
    ////`uvm_field_array_int(rand_q, UVM_HEX | UVM_ALL_ON)
    //`uvm_object_utils_end
    
    constraint c_vld {
      dma_en == 1;
      foreach(comp[i]){ // traverse rows
        //The array manipulation methods iterate over elements in one dimension of an array. 
        // item is each element in that dimension
        //comp[i].sum() with (int'(item)) == 1 ;  // rows a[i][0] + a[i][1] + ...
        //dma_en[i] -> comp.sum() with (int'(comp[i][item.index])) == 1 ;  // rows a[i][0] + a[i][1] + ...
        !dma_en[i] -> comp.sum() with (int'(comp[i][item.index])) == 0 ;
      }
    }
    
    constraint C3{ // traverse columns 
      foreach(comp[,j]) 
        // item.index is the value of the index for that item.
        comp.sum() with (int'(comp[item.index][j])) == 1; // cols a[0][j] + a[1][j] + ...
    }

   //function void post_randomize();
   //   rand_q.push_back(rand_var);
   //endfunction 
    
  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 1; i++) begin
      
      void'(m_vec.randomize());
      $display("RAND %p", m_vec);
      
    end
    
  end
  
endmodule
