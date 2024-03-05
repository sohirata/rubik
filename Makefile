OBJS1 = 2x2x2.o

OBJS2 = 2x2x2a.o

OBJS3 = 2x2x2b.o

FC      = gfortran
CFLAGS1 = -c -fno-range-check
LFLAGS1 = -fno-range-check

.SUFFIXES: .f90 .o

2x2x2: $(OBJS1)
	$(FC) $(LFLAGS1) -o 2x2x2 $(OBJS1)

2x2x2a: $(OBJS2)
	$(FC) $(LFLAGS1) -o 2x2x2a $(OBJS2)

2x2x2b: $(OBJS3)
	$(FC) $(LFLAGS1) -o 2x2x2b $(OBJS3)

.f90.o:
	$(FC) $(CFLAGS1) $*.f90
