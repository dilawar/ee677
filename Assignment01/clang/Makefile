CC = gcc 
CFLAGS = -c -g
OBJ = main.o methods.o
LDFLAGS = -lm

all : qm.bin

run :
	./qm.bin

qm.bin : $(OBJ)
	$(CC) $(OBJ) -o $@ $(LDFLAGS)
	./qm.bin

%.o : %.c globals.h
	$(CC) $(CFLAGS) $< -o $@

clean :
	rm -rf *.o *~ qm.bin
