// Consider a simple poker game where we have the following specifications:
// A standard deck of cards with 52 unique cards is used.A standard 52-card French-suited deck 
// comprises 13 ranks in each of the four suits: clubs (♣), diamonds (♦), hearts (♥) and spades (♠).
// Each player is dealt 5 cards at the start.
// The design has an interface where you can send a command to deal a card and the design will respond with the card value.
// Your task is to design a UVM vseq to:
// Deal 5 cards for a single player.


module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 extends uvm_sequence_item;
    
    rand bit [5:0] cards[];
    //rand bit [7:0] var2;
    //     bit [3:0] rand_var2 [$];
    
    
    `uvm_object_utils_begin(constraint1)
    `uvm_field_sarray_int(cards, UVM_HEX | UVM_ALL_ON)
    //`uvm_field_array_int(rand_q, UVM_HEX | UVM_ALL_ON)
    `uvm_object_utils_end
    
    constraint c_vld1 {
      foreach (cards[i])
        cards[i] inside {[0:52]};
      unique{cards};
    }

    
    constraint c_vld2 {
      cards.size() == 5;
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
