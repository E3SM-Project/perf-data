#!/bin/bash -f
#SBATCH --account=fy190158
####SBATCH -p regular # note for debug que chaining (script to submit a script) is not allowed
#SBATCH --error=slurm-NAME-%j # do not use custom output file?
#SBATCH --output=slurm-NAME-%j
#SBATCH --nodes=NNODE
#SBATCH -t 00:120:00  # who knows how much....
#SBATCH --job-name=NUMEeNNODE # format to shrink job name
######################## GPU

# bsub -gpu num=4 -Is -n 40 bash

nmax=500
wdir=`pwd`

if true; then

xx=${wdir}/../bldxx/test_execs/theta-nlev128-kokkos
exexx=theta-nlev128-kokkos
xff=${xx}/CMakeFiles/${exexx}.dir/flags.make

whichdir=${xx}
echo "Running from $whichdir "
ls -la ${whichdir}/$exexx

#for ne in 2; do
for ne in 2 3 4 6 10 15 16 18 20; do
#for nth in 1 2; do

   nlname=xxinput-ne${ne}-nmax${nmax}.nl
   sed -e s/NE/${ne}/ -e s/NMAX/${nmax}/  \
        xxinput-theta.nl > ${nlname};   

     NN=$(( ne*ne*6 ))

     if [ $NN -gt 64 ] ; then
       NN=64
     fi

     echo "NN is $NN, ne is $ne "

     mpiexec -np 1 --bind-to core ${whichdir}/$exexx \
     < ${nlname} |& grep -v "IEEE_UNDERFLOW_FLAG"

   ff=time-thetaxx-ne${ne}-nmax${nmax}.${LSB_JOBID}
   cp ${nlname} $ff
   head -n 50 HommeTime_stats >> $ff
   head -n 50 ${xff} >> $ff
   rm HommeTime_stats
#done
done

fi



