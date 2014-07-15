CC = cc
OPTS = -O0
go: elapsedtime.o resol.o gettimings.o dosomething.o
	$(CC) $(OPTS) -o go elapsedtime.o resol.o  gettimings.o dosomething.o
elapsedtime.o: elapsedtime.c
	$(CC) $(OPTS) -c elapsedtime.c
resol.o: resol.c
	$(CC) $(OPTS) -c resol.c
gettimings.o: gettimings.c
	$(CC) $(OPTS) -c gettimings.c
dosomething.o: dosomething.c
	$(CC) $(OPTS) -c dosomething.c

# Beware that realclean and kleen also remove the output file,
# so only use if you really want to ditch it.

clean:
	rm -f *.o go
realclean:
	rm -f *.o go resulst
kleen:
	rm -f *.o go results

run:
	./go

tar:
	mkdir clock_resolution && cp *.c *.h sizes results* report* makefile clock_resolution && \
	    tar cf clock_resolution.tar clock_resolution && \
	    rm -rf clock_resolution

