// Write a constraint to generate a dist of covid vaccine

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  typedef enum {AZ, BNT, Moderna} vaccine_type;

  class constraint1;
    rand vaccine_type vaccine;
    rand bit [3:0] citizen_number [9];

    
   // `uvm_object_utils_begin(constraint1)
   //   `uvm_field_sarray_int(citizen_number, UVM_HEX | UVM_ALL_ON)
   // `uvm_object_utils_end
    
   constraint c_vld {
     foreach(citizen_number[i])
       citizen_number[i] inside {[0:9]};

     //citizen_number.sum() with (citizen_number[6:8]) == 0; 
     citizen_number[8] == 0 && citizen_number[7] == 0 && citizen_number[6] == 0;

     (citizen_number[8] == 0 && citizen_number[7] == 0 && citizen_number[6] == 0) -> vaccine inside {Moderna, AZ};

   }

  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 16; i++) begin
      
      void'(m_vec.randomize());
      $display("RAND %p", m_vec);
      
    end
    
  end
  
endmodule
