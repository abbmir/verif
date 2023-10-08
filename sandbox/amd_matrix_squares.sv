// Write a constraint in SV for the following.
//	Matrix size should be randomized with only odd numbers square matrix.
//	Each sub-square matrix should have only one max element and the rest less than the max (can be repetitive)
//  Maximum elements of each sub-matrix should be unique. The constraint should scale up to any size limited by 32 bits.

module top;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  class constraint1 /*extends uvm_sequence_item*/;
    
    rand int unsigned sub_square[][][];
    rand int data[][];
    rand int N; // Matrix size
    rand int K; // sub-square size
    rand int max_sub_square_element[];
    
    
    //`uvm_object_utils_begin(constraint1)
    //  `uvm_field_int(N, UVM_HEX | UVM_ALL_ON)
    //  `uvm_field_int(K, UVM_HEX | UVM_ALL_ON)
    //  `uvm_field_array_int(max_sub_square_element, UVM_HEX | UVM_ALL_ON)
    //`uvm_object_utils_end
    
    constraint c_vld {

      // sub-squares of size K x K in a given square matrix of size N x N
      K inside {7};
      K%2 == 1; // sub-square matrix size is odd to construct odd square matrix.

      max_sub_square_element.size inside {K*K}; 

      foreach(max_sub_square_element[i])
        max_sub_square_element[i] inside {[1:K*K*109]};
      
      unique{max_sub_square_element}; // Maximum elements of each sub-matrix should be unique

      // Construct sub-square matrix e.g. NxKxK
      sub_square.size inside {N}; // First array size is constructed.
      foreach (sub_square[i]) 
        sub_square[i].size inside {K}; // Second array size constructed with same size
      
      foreach (sub_square[i, j]) 
        sub_square[i][j].size inside {K}; // Third array size constructed with size x size

      N inside {K*K};
      N%2 == 1; // Matrix size should be randomized with only odd numbers square matrix.

      data.size inside {N}; // First array size is constructed.
      foreach (data[i]) 
        data[i].size inside {N}; // Second array size constructed with same size

      //foreach(data[i,j])
      // data[i][j] inside {[1:N*N]};    

      foreach(max_sub_square_element[i]){
        // This is explained in section 7.12.3 Array reduction methods of the 1800-2017 LRM.  
        //sub_square_matrix_sizes.sum() with (32'(item)) == int'(K*K); 
        // The constraint should scale up to any size limited by 32 bits.
        sub_square[i].sum(A) with(A.sum(B) with (int'(B == max_sub_square_element[i]))) == 1; // Each sub-square matrix should have only one max element
        sub_square[i].sum(A) with(A.sum(B) with (int'(B < max_sub_square_element[i]))) == K*K-1; // and the rest less than the max (can be repetitive)
        
      }    
    
    }

    function void post_randomize();
      // Building square matrix with multiple sub-square matrix
      foreach(data[i,j])
        data[i][j] = sub_square[(i/K)*K + j/K][i%K][j%K]; 
    endfunction


  endclass
    
  initial begin
    constraint1 m_vec = new();
    
    for (int i=0; i < 1; i++) begin
      void'(m_vec.randomize());
      //$display("RAND %p", m_vec.sprint());
      //foreach(m_vec.data[i,j]) 
      //  $display("\t data[%0d][%0d] = %0d",i,j,m_vec.data[i][j]);
      $display("\t %p ", m_vec);
    end
    
  end
  
endmodule

//'{sub_square:'{'{'{2, 1, 1}, 
//                 '{3, 3, 2}, 
//                 '{5, 0, 3}}, 
//               '{'{0, 0, 0},  
//                 '{1, 0, 0}, 
//                 '{0, 0, 0}}, 
//			         '{'{2, 5, 2}, 
//                 '{3, 5, 2}, 
//                 '{2, 6, 5}}, 
//			         '{'{3, 1, 2}, 
//                 '{1, 1, 2}, 
//                 '{2, 2, 0}}, 
//			         '{'{6, 7, 1}, 
//                 '{2, 6, 2}, 
//                 '{6, 0, 5}}, 
//			         '{'{5, 2, 0}, 
//                 '{5, 7, 6}, 
//                 '{4, 8, 2}}, 
//			         '{'{4, 1, 0}, 
//                 '{3, 2, 3}, 
//                 '{2, 0, 0}}, 
//			         '{'{0, 3, 8}, 
//                 '{3, 4, 2}, 
//                 '{9, 2, 1}}, 
//			         '{'{1, 0, 0}, 
//                 '{1, 0, 1}, 
//                 '{0, 2, 0}}}, 
//			   
//data:'{'{2, 1, 1, 0, 0, 0, 2, 5, 2}, 
//       '{3, 3, 2, 1, 0, 0, 3, 5, 2}, 
//	     '{5, 0, 3, 0, 0, 0, 2, 6, 5}, 
//       '{3, 1, 2, 6, 7, 1, 5, 2, 0}, 
//	     '{1, 1, 2, 2, 6, 2, 5, 7, 6}, 
//	     '{2, 2, 0, 6, 0, 5, 4, 8, 2}, 
//	     '{4, 1, 0, 0, 3, 8, 1, 0, 0}, 
//	     '{3, 2, 3, 3, 4, 2, 1, 0, 1}, 
//	     '{2, 0, 0, 9, 2, 1, 0, 2, 0}}, 
//	   
//	   N:9, K:3, 
//	   max_sub_square_element:'{5, 1, 6, 3, 7, 8, 4, 9, 2}}