//square matrix with odd number size
//each row should have only one max element and rest less than max and can be repetitive
//Max elements of each row should be unique, meaning no two rows should have same max element

class C;
    rand int unsigned index;
    rand int unsigned arr[][]; 
    rand int unsigned max[];
    
  constraint max_c { index inside {[3:7]}; index%2 != 0;}

    constraint arr_c {
      max.size() == index;
      foreach(max[j]) max[j] inside {[1:index*index]}; 
      unique {max};

      arr.size() == index;   
      foreach(arr[i]) {arr[i].size() == index;}  
      foreach(arr[i,j]) arr[i][j] inside {[1:index*index]};   

      foreach(arr[i]) {arr[i].sum() with(item == max[i]) == 1;}
      foreach(arr[i]) {arr[i].sum() with(int'(item < max[i])) == index-1;}
   }
endclass

module top;
   C c=new();

   initial begin
     void'(c.randomize());
     $display("c=%p", c);
   end
endmodule