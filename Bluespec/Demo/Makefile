## Dilawar, dilawar@ee.iitb.ac.in
## Oct 26, 2012
## Bluespec makefile.

# Tell me puny Earthling! which file I must simulate.
file=Data.bsv

BSC=bsc
BSCFLAGS =
# We are using verilog simulator to compile our verilog code.
VSIM=iverilog

# If topmodule is not passed from  command line, then use the default one.
ifdef $1
TOPMODULE=$1
else
TOPMODULE=$(patsubst %.bsv, mk%, $(file))
endif 

VERILOGSRC = $(TOPMODULE).v

EXE = $(patsubst %.bsv,%,$(file))
# compile to Verilog
all : $(EXE)
	./$(EXE) +bscvcd+ $(TOPMODULE).vcd

$(EXE) : $(VERILOGSRC)
	$(BSC) -verilog -e $(TOPMODULE) -vsim $(VSIM) -o $@ $+

$(VERILOGSRC) : $(file)
	$(BSC) $(BSCFLAGS) -verilog -u $<

# invoke iverilog directly and link with main.v, and run it

.PHONY: clean
clean:
	rm -f *.bi *.bo  *.vcd *~ $(TOPMODULE).v $(EXE)

