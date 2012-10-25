## Dilawar, dilawar@ee.iitb.ac.in
## Oct 26, 2012
## Bluespec makefile.

# Tell me puny Earthling! which file I must simulate.
file=Data.bsv

BSC=bsc
BSCFLAGS=
# We are using verilog simulator to compile our verilog code.
VSIM=iverilog

# If topmodule is not passed from  command line, then use the default one.
top=$(patsubst %.bsv, mk%, $(file))

VERILOGSRC = $(top).v

EXE = $(patsubst %.bsv,%,$(file))
# compile to Verilog
all : $(EXE)
	./$(EXE) +bscvcd+ $(top).vcd

$(EXE) : $(VERILOGSRC) $(file)
	$(BSC) -verilog -e $(top) -vsim $(VSIM) -o $@ $<

$(VERILOGSRC) : $(file)
	$(BSC) $(BSCFLAGS) -verilog -u $<

# invoke iverilog directly and link with main.v, and run it

.PHONY: clean
clean:
	rm -f *.bi *.bo  *.vcd *~ $(top).v $(EXE)

