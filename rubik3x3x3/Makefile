OBJS = 3x3x3.o

FC      = gfortran
CFLAGS1 = -c -fno-range-check
LFLAGS1 = -fno-range-check

.SUFFIXES: .f90 .o

3x3x3: $(OBJS)
	$(FC) $(LFLAGS1) -o 3x3x3 $(OBJS)

.f90.o:
	$(FC) $(CFLAGS1) $*.f90

clean:
	rm -f *.o *.mod 3x3x3
