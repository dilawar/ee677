(* synthesize *)
module mkTb (Empty);
   Empty m3 <- mkM3;
endmodule

// ----------------------------------------------------------------

(* synthesize *)
module mkM3 (Empty);

   Reg#(int) x   <- mkReg (10);
   M1_ifc    m1b <- mkM1 (20);
   M2_ifc    m2  <- mkM2 (30);

   rule justonce;
      $display ("x = %0d, m1b/x = %0d, m2/x = %0d, m2/m1a/x = %0d",
                 x, m1b.read_local_x, m2.read_local_x, m2.read_sub_x);
      $finish (0);
   endrule

endmodule

// ----------------------------------------------------------------

interface M2_ifc;
   method int read_local_x ();
   method int read_sub_x ();
endinterface

(* synthesize *)
module mkM2 #(parameter int init_val) (M2_ifc);

   M1_ifc  m1a <- mkM1 (init_val + 10);
   Reg#(int) x <- mkReg (init_val);

   method int read_local_x ();
      return x;
   endmethod

   method int read_sub_x ();
      return m1a.read_local_x;
   endmethod

endmodule: mkM2

// ----------------------------------------------------------------

interface M1_ifc;
   method int read_local_x ();
endinterface

(* synthesize *)
module mkM1 #(parameter int init_val) (M1_ifc);

   Reg#(int) x <- mkReg (init_val);

   method int read_local_x ();
      return x;
   endmethod

endmodule: mkM1

