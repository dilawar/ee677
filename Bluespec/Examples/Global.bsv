
// We can write different interfaces for different modules of use one for both.
// Note that we'll some functions in one module and others in another module.
interface Ifc_type;
  method Action loadBit(Bit#(1) done);
  method Bit#(1) readBit();

  method Action loadCount(int count);
  method int readCount();
  method int read();
endinterface 


interface Ifc_global;
  interface Ifc_type ifc;
endinterface


// This module keeps all global registers. Its state act as control signals for
// other modules.
module globalVar(Ifc_global);
   
  // Global registers.
  Reg#(int) g1 <-mkReg(0);
  Reg#(Bit#(1)) done <- mkReg(0);
  Reg#(int) count <- mkReg(0);

  interface Ifc_type ifc;
    method Action loadCount(int newCount);
      count <= newCount;
    endmethod 
    
    method Action loadBit(Bit#(1) finished);
      done <= finished;
    endmethod

    method Bit#(1) readBit();
      return done;
    endmethod

    method int readCount();
      return count;
    endmethod 
  endinterface 
  
endmodule

// Another module which uses the same interface as GlobalVar. Notice that it
// uses some of the function declared in interface.
module mkA (Ifc_global);
  
  Ifc_global if1 <- globalVar;

  Reg#(int) r1 <- mkReg(0);

  interface Ifc_type ifc;
    method Action loadCount(int newval);
      if (if1.ifc.readBit() == 0) r1 <= newval;
    endmethod

    method int read();
      return r1;
    endmethod
  endinterface

endmodule 


(* synthesize *)
module mkTb(Empty);

  Ifc_global ifc <- mkA;
  Ifc_global ifc1 <- globalVar;

  rule r0 (ifc1.ifc.readCount()  == 0);
    $display("Loading 1 into globalVar module");
    ifc1.ifc.loadBit(1);
    ifc.ifc.loadCount(17);
  endrule

  rule r1 (ifc1.ifc.readCount() > 0);
    ifc1.ifc.loadCount(ifc1.ifc.readCount() + 1);
    ifc.ifc.loadCount(ifc.ifc.readCount() + 9);
  endrule

  rule finish (ifc1.ifc.readCount() == 5);
    $display(" Value of r1 in mkA : %d ", ifc.ifc.read());
    $display("Goodbye cruel wold!");
    $finish(0);
  endrule

endmodule

