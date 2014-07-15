# EXTRALIBS = -L/opt/SUNWspro/lib -lF77 -lM77 -lsunmath  -lfsu

# LAPACK = -L/home/bramley/lib -llapack95
# BLAS = -L/home/bramley/lib -lblas95
# F95= /usr/local/intel/compiler60/ia32/bin/ifc
# OPTS= -O -w
# LIBS = $(LAPACK) $(BLAS)

#------------------------------------------------------------------------
# To allow maximal laziness via tab-completion, the executable is called
# "runLU" although the program file's name is luDriver.f90
#------------------------------------------------------------------------
include make.inc


runLU: luDriver.o LU8.o LU4.o rowswp.o elapsedtime.o kinds.mod \
	utilities.o swaps.o checkLU.o WriteParameters.o 
	$(F95) $(INCS) -o runLU $(OPTS) luDriver.o LU8.o LU4.o kinds.o \
		utilities.o swaps.o elapsedtime.o WriteParameters.o checkLU.o \
		rowswp.o $(LIBS)
luDriver.o: luDriver.f90 kinds.mod 
	$(F95) $(OPTS) -c luDriver.f90
LU4.o: LU4.c
	$(CC) $(INCS) $(OPTS) -c LU4.c
LU8.o: LU8.c
	$(CC) $(INCS) $(OPTS) -c LU8.c
rowswp.o: rowswp.f90 kinds.mod
	$(F95) $(OPTS) -c rowswp.f90
WriteParameters.o: WriteParameters.f90 
	$(F95) $(OPTS) -c WriteParameters.f90
kinds.mod: kinds.f90 
	$(F95) $(OPTS) -c kinds.f90
elapsedtime.o: elapsedtime.f90 
	$(F95) $(OPTS) -c elapsedtime.f90
checkLU.o: checkLU.f90 kinds.mod 
	$(F95) $(OPTS) -c checkLU.f90
swaps.o: swaps.f90 kinds.mod 
	$(F95) $(OPTS) -c swaps.f90
utilities.o: utilities.f90 kinds.mod
	$(F95) $(OPTS) -c utilities.f90

clean:
	/bin/rm -f *.o *.mod runLU log

kleen:
	/bin/rm -f *.o *.mod runLU log results



