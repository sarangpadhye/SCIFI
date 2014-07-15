
# make.inc defines the compiler, include path(s), and compiler options.
include make.inc

# Creates the executable "to", short for "timeroverhead". Saves on 
# typing. 

to: findoverhead.o overhead.o elapsedtime.o flopop.o
	$(CC) $(OPTS) $(INCS) -o to findoverhead.o overhead.o elapsedtime.o \
		flopop.o $(LIBS)
findoverhead.o: findoverhead.c 
	$(CC) $(OPTS) $(INCS) -c findoverhead.c 
overhead.o: overhead.c 
	$(CC) $(OPTS) $(INCS) -c overhead.c
elapsedtime.o: elapsedtime.c
	$(CC) $(OPTS) $(INCS) -c elapsedtime.c
flopop.mod: flopop.c  
	$(CC) $(OPTS) $(INCS) -c flopop.c

clean:
	rm -f  *.o  to  

# Beware: the next two targets remove *all* results files
realclean:
	rm -f  *.o  to  timings.m
kleen:
	rm -f  *.o  to  timings.m

run: 
	./to

