all: runfrag-pesmpi.x 
MP=mpif90
	
runfrag-pesmpi.o: runfrag-pesmpi.f90
	$(MP) -c $<
runfrag-pesmpi.x: runfrag-pesmpi.o
	$(MP) runfrag-pesmpi.o -o $@

clean:
	rm -f *.o fragment.x cal_energy_pes.x runfrag-pesmpi.x 
