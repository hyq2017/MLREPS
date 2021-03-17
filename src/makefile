all: fragment.x cal_energy_pes.x runfrag-pes.x 
IF=ifort

fragment.o: fragment.f90
	$(IF) -c $<
fragment.x: fragment.o
	$(IF) fragment.o -o $@

cal_energy_pes.o: cal_energy_pes.f90
	$(IF) -c $<
cal_energy_pes.x: cal_energy_pes.o
	$(IF) cal_energy_pes.o -o $@

runfrag-pes.o: runfrag-pes.f90
	$(IF) -c $<
runfrag-pes.x: runfrag-pes.o
	$(IF) runfrag-pes.o -o $@

clean:
	rm -f *.o fragment.x cal_energy_pes.x runfrag-pes.x
