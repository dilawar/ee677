
// We can write different interfaces for different modules of use one for both.
// Note that we'll some functions in one module and others in another module.
interface Ifc_type;
  method int readCount();
  method int read();
  method Bit#(1) readBit();
  method Action load(int newval);
  method Action loadBit(Bit#(1) newDone);
endinterface


// This module keeps all global registers. Its state act as control signals for
// other modules.
module globalVar(Ifc_type);
   
  // Global registers.
  Reg#(int) g1 <-mkReg(0);
  Reg#(Bit#(1)) done <- mkReg(0);
  Reg#(int) count <- mkReg(0);

  method Action load(int newCount);
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
  
endmodule

// Another module which uses the same interface as GlobalVar. Notice that it
// uses some of the function declared in interface.
module mkA (Ifc_type);
  
  Ifc_type if1 <- globalVar;

  Reg#(int) r1 <- mkReg(0);

  method Action load(int newval);
    if (if1.readBit() == 0) r1 <= newval;
  endmethod

  method int read();
    return r1;
  endmethod

endmodule 


(* synthesize *)
module mkTb(Empty);

  Ifc_type ifc <- mkA;
  Ifc_type ifc1 <- globalVar;

  rule r0 (ifc1.readCount()  == 0);
    $display("Loading 1 into globalVar module");
    ifc1.load(1);
    ifc.load(17);
  endrule

  rule r1 (ifc1.readCount() > 0);
    ifc1.load(ifc1.readCount() + 1);
    ifc.load(ifc.read() + 9);
  endrule

  rule finish (ifc1.readCount() == 5);
    $display(" Value of r1 in mkA : %d ", ifc.read());
    $display("Goodbye cruel wold!");
    $finish(0);
  endrule

endmodule

