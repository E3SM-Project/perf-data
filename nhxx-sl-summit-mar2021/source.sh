module purge
module load cuda/10.1.243 gcc/7.4.0 netlib-lapack/3.8.0 cmake/3.18.2 spectrum-mpi/10.3.1.2-20200121 netcdf/4.6.2 netcdf-fortran/4.4.4 hdf5/1.10.4
module load python/3.6.6-anaconda3-5.3.0

export PAMI_ENABLE_STRIPING=1
export PAMI_IBV_ADAPTER_AFFINITY=1
export PAMI_IBV_DEVICE_NAME="mlx5_0:1,mlx5_3:1"
export PAMI_IBV_DEVICE_NAME_1="mlx5_3:1,mlx5_0:1"
export PAMI_CUDA_AWARE_THRESH=320000
