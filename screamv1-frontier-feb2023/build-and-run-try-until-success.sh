tag=rocm51
for i in 512 1024 2048 4096 8192; do
  bash run-${tag}.sh $i
  nohup bash try-until-success.sh frontier-v1-scaling1-${tag}-nnodes${i}.ne1024pg2_ne1024pg2.F2010-SCREAMv1 /gpfs/alpine/cli133/proj-shared/ambradl/e3sm_scratch/frontier/frontier-v1-scaling1-${tag}-nnodes${i}.ne1024pg2_ne1024pg2.F2010-SCREAMv1/run $i run.frontier-v1-scaling1-${tag}-nnodes > try.${tag}.${i}.txt &
done
