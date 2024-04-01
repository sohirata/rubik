OBJS = 5x5x5.o

FC      = gfortran
CFLAGS1 = -c -fno-range-check
LFLAGS1 = -fno-range-check

.SUFFIXES: .f90 .o

4x4x4: $(OBJS)
	$(FC) $(LFLAGS1) -o 5x5x5 $(OBJS)

.f90.o:
	$(FC) $(CFLAGS1) $*.f90

clean:
	rm -f *.o *.mod 5x5x5
