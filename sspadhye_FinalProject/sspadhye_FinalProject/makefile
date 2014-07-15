
include make.inc
F2k = $(F95)

runit: driver.o kindlytypes.mod elapsedtime.o \
		getparameters.o setmatrix.o timedmatvec.o 
	$(F2k) -o runit driver.o kindlytypes.o elapsedtime.o \
		getparameters.o setmatrix.o timedmatvec.o $(LIBS) $(INC) 

elapsedtime.o: elapsedtime.f90
	$(F2k) $(OPTFLAGS) -c elapsedtime.f90

kindlytypes.mod: kindlytypes.f90 
	$(F2k) $(OPTFLAGS) -c kindlytypes.f90

driver.o: driver.f90 kindlytypes.mod formats 
	$(F2k) $(OPTFLAGS) -c driver.f90

setmatrix.o: setmatrix.f90 kindlytypes.mod formats
	$(F2k) $(OPTFLAGS) -c setmatrix.f90

timedmatvec.o: timedmatvec.c 
	$(CC) $(OPTFLAGS) -c timedmatvec.c

getparameters.o: getparameters.f90 kindlytypes.mod formats
	$(F2k) $(OPTFLAGS) -c getparameters.f90

clean:
	/bin/rm -f *.o *.mod runit

kleen:
	/bin/rm -f *.o *.mod runit log results poop

realclean:
	/bin/rm -f *.o *.mod runit log results
