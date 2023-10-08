// Code your testbench here
// or browse Examples

//Write SV constraints- 
//for randomization.
//            	    R  C
//rand bit array_2d[8][8];
//8 x 8 grid  - 64 elements
//1). -> place 8 "1" in "array_2d"
//2). Max number of ones in Each COL = 1 	
//3). Max number of ones in Each ROW = 1 

module top;
  
  class constraint1;
    
    rand bit array_2d[8][8];
    
    //constraint c_vld{
    //  array_2d.sum(D1) with (D1.sum(D2) with (32'(D2)))==1;
    //}

    constraint C2{
      foreach(array_2d[i]) // traverse rows
        //The array manipulation methods iterate over elements in one dimension of an array. 
        // item is each element in that dimension
        //array_2d[i].sum() with (int'(item)) == 1 ;  // rows a[i][0] + a[i][1] + ...
        array_2d.sum() with (int'(array_2d[i][item.index])) == 1 ;  // rows a[i][0] + a[i][1] + ...
    }
    
    constraint C3{ // traverse columns 
      foreach(array_2d[,j]) 
        // item.index is the value of the index for that item.
        array_2d.sum() with (int'(array_2d[item.index][j])) == 1; // cols a[0][j] + a[1][j] + ...
    }

  endclass

  initial begin
    
    constraint1 m_vec = new();
    
    for (int i=0; i < 1; i++) begin
      void'(m_vec.randomize());
        $display("\t %p ", m_vec);
    end

    //foreach(m_vec.array_2d[i]) // traverse rows
    //  //The array manipulation methods iterate over elements in one dimension of an array. 
    //  // item is each element in that dimension
    //  $display ("[%0d]=%0d", m_vec.array_2d[i].sum() with (int'(item)) );  // rows a[i][0] + a[i][1] + ...

    //foreach(m_vec.array_2d[,j]) 
    //  // item.index is the value of the index for that item.
    //  $display ("%0d", m_vec.array_2d.sum() with (int'(m_vec.array_2d[item.index][j])) ); // cols a[0][j] + a[1][j] + ...

  end
  
endmodule
                               
 
                               
                               
                              