## Dilawar, dilawar@ee.iitb.ac.in
## Oct 26, 2012
## Bluespec makefile.

# Tell me puny Earthling! which file I must simulate.
file=Data.bsv

BSC=bsc
BSCFLAGS=

# Instead of using Bluespec simulator and burdening the licence server, let's
# use verilog simulator.
VSIM=iverilog

# If topmodule is not passed from  command line, then use the default one.
top=$(patsubst %.bsv, mk%, $(file))

VERILOGSRC = $(top).v

EXE = $(patsubst %.bsv,%,$(file))
all : $(EXE)
	./$(EXE) +bscvcd+ $(top).vcd

# convert bluespec to Verilog
$(EXE) : $(VERILOGSRC) $(file)
	$(BSC) -verilog -e $(top) -vsim $(VSIM) -o $@ $<

# compile generated verilog
$(VERILOGSRC) : $(file)
	$(BSC) $(BSCFLAGS) -verilog -u $<

# invoke iverilog directly and link with main.v, and run it

.PHONY: clean
clean:
	rm -f *.bi *.bo  *.vcd *~ $(top).v $(EXE)

