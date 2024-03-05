OBJS = 2x2x2.o

FC      = gfortran
CFLAGS1 = -c -fno-range-check
LFLAGS1 = -fno-range-check

.SUFFIXES: .f90 .o

2x2x2: $(OBJS)
	$(FC) $(LFLAGS1) -o 2x2x2 $(OBJS)

.f90.o:
	$(FC) $(CFLAGS1) $*.f90

clean:
	rm -f *.o *.mod 2x2x2
