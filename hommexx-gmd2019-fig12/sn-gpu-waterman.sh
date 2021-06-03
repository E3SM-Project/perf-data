#!/bin/bash
#BSUB -W 4:00
#BSUB -n 1
#BSUB -q rhel7W
#BSUB -o sn-gpu-wm.out
#BSUB -e sn-gpu-wm.err
#BSUB -J sn-gpu-wm
. /ascldap/users/ambradl/climate/source-waterman.sh
cd sn-gpu-run
echo "AMB> gpuw qsize 40 ne  2 nrank  1 nthr   1 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne  2 nrank 24 nthr   1 nmax  8001"
sed -e s/NE/2/ -e s/QSIZE/40/ -e s/NMAX/8001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne  3 nrank  1 nthr   1 nmax  3558"
sed -e s/NE/3/ -e s/QSIZE/40/ -e s/NMAX/3558/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne  4 nrank  1 nthr   1 nmax  2001"
sed -e s/NE/4/ -e s/QSIZE/40/ -e s/NMAX/2001/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne  5 nrank  1 nthr   1 nmax  1281"
sed -e s/NE/5/ -e s/QSIZE/40/ -e s/NMAX/1281/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne  6 nrank  1 nthr   1 nmax   891"
sed -e s/NE/6/ -e s/QSIZE/40/ -e s/NMAX/891/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne  7 nrank  1 nthr   1 nmax   654"
sed -e s/NE/7/ -e s/QSIZE/40/ -e s/NMAX/654/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne  8 nrank  1 nthr   1 nmax   501"
sed -e s/NE/8/ -e s/QSIZE/40/ -e s/NMAX/501/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne  9 nrank  1 nthr   1 nmax   396"
sed -e s/NE/9/ -e s/QSIZE/40/ -e s/NMAX/396/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne 10 nrank  1 nthr   1 nmax   321"
sed -e s/NE/10/ -e s/QSIZE/40/ -e s/NMAX/321/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne 11 nrank  1 nthr   1 nmax   267"
sed -e s/NE/11/ -e s/QSIZE/40/ -e s/NMAX/267/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize 40 ne 16 nrank  1 nthr   1 nmax   126"
sed -e s/NE/16/ -e s/QSIZE/40/ -e s/NMAX/126/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne  2 nrank  1 nthr   1 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne  2 nrank 24 nthr   1 nmax 40005"
sed -e s/NE/2/ -e s/QSIZE/0/ -e s/NMAX/40005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne  3 nrank  1 nthr   1 nmax 17790"
sed -e s/NE/3/ -e s/QSIZE/0/ -e s/NMAX/17790/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne  4 nrank  1 nthr   1 nmax 10005"
sed -e s/NE/4/ -e s/QSIZE/0/ -e s/NMAX/10005/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne  5 nrank  1 nthr   1 nmax  6405"
sed -e s/NE/5/ -e s/QSIZE/0/ -e s/NMAX/6405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne  6 nrank  1 nthr   1 nmax  4455"
sed -e s/NE/6/ -e s/QSIZE/0/ -e s/NMAX/4455/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne  7 nrank  1 nthr   1 nmax  3270"
sed -e s/NE/7/ -e s/QSIZE/0/ -e s/NMAX/3270/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne  8 nrank  1 nthr   1 nmax  2505"
sed -e s/NE/8/ -e s/QSIZE/0/ -e s/NMAX/2505/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne  9 nrank  1 nthr   1 nmax  1980"
sed -e s/NE/9/ -e s/QSIZE/0/ -e s/NMAX/1980/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne 10 nrank  1 nthr   1 nmax  1605"
sed -e s/NE/10/ -e s/QSIZE/0/ -e s/NMAX/1605/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne 11 nrank  1 nthr   1 nmax  1335"
sed -e s/NE/11/ -e s/QSIZE/0/ -e s/NMAX/1335/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne 16 nrank  1 nthr   1 nmax   630"
sed -e s/NE/16/ -e s/QSIZE/0/ -e s/NMAX/630/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne 20 nrank  1 nthr   1 nmax   405"
sed -e s/NE/20/ -e s/QSIZE/0/ -e s/NMAX/405/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne 24 nrank  1 nthr   1 nmax   285"
sed -e s/NE/24/ -e s/QSIZE/0/ -e s/NMAX/285/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

echo "AMB> gpuw qsize  0 ne 32 nrank  1 nthr   1 nmax   165"
sed -e s/NE/32/ -e s/QSIZE/0/ -e s/NMAX/165/ -e s/TSTEP/1/ ../xx-template.nl > input.nl
mpiexec -n 1 /ascldap/users/ambradl/climate/hxx/build-waterman/test_execs/prtcB_flat_c/prtcB_flat_c < input.nl &> /dev/null
head -n 50 HommeTime*

