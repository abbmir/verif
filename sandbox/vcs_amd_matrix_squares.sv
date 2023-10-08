class total;
  
  rand int unsigned sub_square[][][];
  rand int data[][];
  rand int N; // Matrix size
  rand int K; // sub-square size
  rand int max_sub_square_element[];

  rand bit [7:0] a [0:2][0:2];
  rand bit[7:0] s[3]; // 3 is the number of rows

  constraint c1 {
    foreach (a[i]) {
        a[i].sum with(item>0?item:0)== s[i]; 
    }
    s.sum with (item > 0 ?item:0) == 9;
    unique{s};
  } 
    //`uvm_object_utils_begin(constraint1)
    //  `uvm_field_int(N, UVM_HEX | UVM_ALL_ON)
    //  `uvm_field_int(K, UVM_HEX | UVM_ALL_ON)
    //  `uvm_field_array_int(max_sub_square_element, UVM_HEX
    //`uvm_object_utils_end
    
    constraint c_vld {

      // sub-squares of size K x K in a given square matrix of size N x N
      K inside {3};
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


  function void display ();
    foreach(data[i,j]) begin 
      $write("%0d ",data[i][j]);
      if(j==2)
        $display();
    end
  endfunction
endclass

module top;
  total m1;
  initial begin
    m1=new ();
    m1.randomize();
    m1.display();
    $display("\t %p ", m1);
  end
endmodule