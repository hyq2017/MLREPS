cd mpi
make
cd ..
./src/fragment.x
#mpirun -machinefile hostfile -np 22 ./runfrag-pesmpi.x
mpirun -np 10 ./mpi/runfrag-pesmpi.x >& pesmpi.log
./src/cal_energy_pes.x
