#!/bin/bash
#SBATCH -N 1
#SBATCH -t 4:00:00
#SBATCH -o sn-hsw.out
cd sn-hsw-run
echo "AMB> hsw qsize 40 ne  2 nrank  1 nthr  32 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank  1 nthr  64 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank  2 nthr  16 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank  2 nthr  32 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank  4 nthr   8 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank  4 nthr  16 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank  8 nthr   4 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank  8 nthr   8 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank 16 nthr   2 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank 16 nthr   4 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank 24 nthr   1 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 24 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  2 nrank 24 nthr   2 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 24 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank  1 nthr  32 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank  1 nthr  64 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank  2 nthr  16 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank  2 nthr  32 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank  4 nthr   8 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank  4 nthr  16 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank  8 nthr   4 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank  8 nthr   8 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank 16 nthr   2 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank 16 nthr   4 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank 32 nthr   1 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  3 nrank 32 nthr   2 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank  1 nthr  32 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank  1 nthr  64 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank  2 nthr  16 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank  2 nthr  32 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank  4 nthr   8 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank  4 nthr  16 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank  8 nthr   4 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank  8 nthr   8 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank 16 nthr   2 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank 16 nthr   4 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank 32 nthr   1 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  4 nrank 32 nthr   2 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank  1 nthr  32 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank  1 nthr  64 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank  2 nthr  16 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank  2 nthr  32 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank  4 nthr   8 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank  4 nthr  16 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank  8 nthr   4 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank  8 nthr   8 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank 16 nthr   2 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank 16 nthr   4 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank 32 nthr   1 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  5 nrank 32 nthr   2 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank  1 nthr  32 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank  1 nthr  64 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank  2 nthr  16 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank  2 nthr  32 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank  4 nthr   8 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank  4 nthr  16 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank  8 nthr   4 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank  8 nthr   8 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank 16 nthr   2 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank 16 nthr   4 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank 32 nthr   1 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  6 nrank 32 nthr   2 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank  1 nthr  32 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank  1 nthr  64 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank  2 nthr  16 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank  2 nthr  32 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank  4 nthr   8 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank  4 nthr  16 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank  8 nthr   4 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank  8 nthr   8 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank 16 nthr   2 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank 16 nthr   4 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank 32 nthr   1 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  7 nrank 32 nthr   2 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank  1 nthr  32 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank  1 nthr  64 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank  2 nthr  16 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank  2 nthr  32 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank  4 nthr   8 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank  4 nthr  16 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank  8 nthr   4 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank  8 nthr   8 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank 16 nthr   2 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank 16 nthr   4 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank 32 nthr   1 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  8 nrank 32 nthr   2 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank  1 nthr  32 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank  1 nthr  64 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank  2 nthr  16 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank  2 nthr  32 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank  4 nthr   8 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank  4 nthr  16 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank  8 nthr   4 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank  8 nthr   8 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank 16 nthr   2 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank 16 nthr   4 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank 32 nthr   1 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne  9 nrank 32 nthr   2 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank  1 nthr  32 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank  1 nthr  64 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank  2 nthr  16 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank  2 nthr  32 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank  4 nthr   8 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank  4 nthr  16 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank  8 nthr   4 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank  8 nthr   8 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank 16 nthr   2 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank 16 nthr   4 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank 32 nthr   1 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 10 nrank 32 nthr   2 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank  1 nthr  32 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank  1 nthr  64 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank  2 nthr  16 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank  2 nthr  32 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank  4 nthr   8 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank  4 nthr  16 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank  8 nthr   4 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank  8 nthr   8 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank 16 nthr   2 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank 16 nthr   4 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank 32 nthr   1 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 11 nrank 32 nthr   2 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank  1 nthr  32 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank  1 nthr  64 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank  2 nthr  16 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank  2 nthr  32 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank  4 nthr   8 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank  4 nthr  16 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank  8 nthr   4 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank  8 nthr   8 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank 16 nthr   2 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank 16 nthr   4 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank 32 nthr   1 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 16 nrank 32 nthr   2 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank  1 nthr  32 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank  1 nthr  64 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank  2 nthr  16 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank  2 nthr  32 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank  4 nthr   8 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank  4 nthr  16 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank  8 nthr   4 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank  8 nthr   8 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank 16 nthr   2 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank 16 nthr   4 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank 32 nthr   1 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 20 nrank 32 nthr   2 nmax    81"
sed -e s/NE/20/ -e s/QSIZE/40/ -e s/NMAX/81/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank  1 nthr  32 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank  1 nthr  64 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank  2 nthr  16 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank  2 nthr  32 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank  4 nthr   8 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank  4 nthr  16 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank  8 nthr   4 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank  8 nthr   8 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank 16 nthr   2 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank 16 nthr   4 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank 32 nthr   1 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 24 nrank 32 nthr   2 nmax    57"
sed -e s/NE/24/ -e s/QSIZE/40/ -e s/NMAX/57/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank  1 nthr  32 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank  1 nthr  64 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank  2 nthr  16 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank  2 nthr  32 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank  4 nthr   8 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank  4 nthr  16 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank  8 nthr   4 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank  8 nthr   8 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank 16 nthr   2 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank 16 nthr   4 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank 32 nthr   1 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize 40 ne 32 nrank 32 nthr   2 nmax    33"
sed -e s/NE/32/ -e s/QSIZE/40/ -e s/NMAX/33/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank  1 nthr  32 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank  1 nthr  64 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank  2 nthr  16 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank  2 nthr  32 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank  4 nthr   8 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank  4 nthr  16 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank  8 nthr   4 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank  8 nthr   8 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank 16 nthr   2 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank 16 nthr   4 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank 24 nthr   1 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 24 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  2 nrank 24 nthr   2 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 24 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank  1 nthr  32 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank  1 nthr  64 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank  2 nthr  16 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank  2 nthr  32 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank  4 nthr   8 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank  4 nthr  16 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank  8 nthr   4 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank  8 nthr   8 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank 16 nthr   2 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank 16 nthr   4 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank 32 nthr   1 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  3 nrank 32 nthr   2 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank  1 nthr  32 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank  1 nthr  64 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank  2 nthr  16 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank  2 nthr  32 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank  4 nthr   8 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank  4 nthr  16 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank  8 nthr   4 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank  8 nthr   8 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank 16 nthr   2 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank 16 nthr   4 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank 32 nthr   1 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  4 nrank 32 nthr   2 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank  1 nthr  32 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank  1 nthr  64 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank  2 nthr  16 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank  2 nthr  32 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank  4 nthr   8 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank  4 nthr  16 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank  8 nthr   4 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank  8 nthr   8 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank 16 nthr   2 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank 16 nthr   4 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank 32 nthr   1 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  5 nrank 32 nthr   2 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank  1 nthr  32 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank  1 nthr  64 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank  2 nthr  16 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank  2 nthr  32 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank  4 nthr   8 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank  4 nthr  16 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank  8 nthr   4 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank  8 nthr   8 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank 16 nthr   2 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank 16 nthr   4 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank 32 nthr   1 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  6 nrank 32 nthr   2 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank  1 nthr  32 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank  1 nthr  64 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank  2 nthr  16 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank  2 nthr  32 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank  4 nthr   8 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank  4 nthr  16 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank  8 nthr   4 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank  8 nthr   8 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank 16 nthr   2 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank 16 nthr   4 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank 32 nthr   1 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  7 nrank 32 nthr   2 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank  1 nthr  32 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank  1 nthr  64 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank  2 nthr  16 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank  2 nthr  32 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank  4 nthr   8 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank  4 nthr  16 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank  8 nthr   4 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank  8 nthr   8 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank 16 nthr   2 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank 16 nthr   4 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank 32 nthr   1 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  8 nrank 32 nthr   2 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank  1 nthr  32 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank  1 nthr  64 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank  2 nthr  16 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank  2 nthr  32 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank  4 nthr   8 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank  4 nthr  16 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank  8 nthr   4 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank  8 nthr   8 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank 16 nthr   2 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank 16 nthr   4 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank 32 nthr   1 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne  9 nrank 32 nthr   2 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank  1 nthr  32 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank  1 nthr  64 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank  2 nthr  16 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank  2 nthr  32 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank  4 nthr   8 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank  4 nthr  16 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank  8 nthr   4 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank  8 nthr   8 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank 16 nthr   2 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank 16 nthr   4 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank 32 nthr   1 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 10 nrank 32 nthr   2 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank  1 nthr  32 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank  1 nthr  64 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank  2 nthr  16 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank  2 nthr  32 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank  4 nthr   8 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank  4 nthr  16 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank  8 nthr   4 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank  8 nthr   8 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank 16 nthr   2 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank 16 nthr   4 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank 32 nthr   1 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 11 nrank 32 nthr   2 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank  1 nthr  32 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank  1 nthr  64 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank  2 nthr  16 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank  2 nthr  32 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank  4 nthr   8 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank  4 nthr  16 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank  8 nthr   4 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank  8 nthr   8 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank 16 nthr   2 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank 16 nthr   4 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank 32 nthr   1 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 16 nrank 32 nthr   2 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank  1 nthr  32 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank  1 nthr  64 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank  2 nthr  16 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank  2 nthr  32 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank  4 nthr   8 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank  4 nthr  16 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank  8 nthr   4 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank  8 nthr   8 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank 16 nthr   2 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank 16 nthr   4 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank 32 nthr   1 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 20 nrank 32 nthr   2 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank  1 nthr  32 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank  1 nthr  64 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank  2 nthr  16 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank  2 nthr  32 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank  4 nthr   8 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank  4 nthr  16 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank  8 nthr   4 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank  8 nthr   8 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank 16 nthr   2 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank 16 nthr   4 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank 32 nthr   1 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 24 nrank 32 nthr   2 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank  1 nthr  32 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank  1 nthr  64 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=64
srun --cpu_bind=cores -N 1 -n 1 -c 64 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank  2 nthr  16 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank  2 nthr  32 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=32
srun --cpu_bind=cores -N 1 -n 2 -c 32 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank  4 nthr   8 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank  4 nthr  16 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=16
srun --cpu_bind=cores -N 1 -n 4 -c 16 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank  8 nthr   4 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank  8 nthr   8 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=8
srun --cpu_bind=cores -N 1 -n 8 -c 8 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank 16 nthr   2 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank 16 nthr   4 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=4
srun --cpu_bind=cores -N 1 -n 16 -c 4 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank 32 nthr   1 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=1
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw-serial/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> hsw qsize  0 ne 32 nrank 32 nthr   2 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
export KMP_AFFINITY=balanced
export OMP_NUM_THREADS=2
srun --cpu_bind=cores -N 1 -n 32 -c 2 /home/ambradl/climate/hommexx-dev/build-mutrino-hsw/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

