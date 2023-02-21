# This file is for user convenience only and is not used by the model
# Changes to this file will be ignored and overwritten
# Changes to the environment should be made in env_mach_specific.xml
# Run ./case.setup --reset to regenerate this file
. /usr/share/lmod/lmod/init/sh
module reset 
module load PrgEnv-cray craype-accel-amd-gfx90a rocm/5.1.0 cce/14.0.2 cray-python/3.9.13.1 subversion/1.14.1 git/2.36.1 cmake/3.21.3 cray-hdf5-parallel/1.12.2.1 cray-netcdf-hdf5parallel/4.9.0.1 cray-parallel-netcdf/1.12.3.1
export NETCDF_PATH=/opt/cray/pe/netcdf-hdf5parallel/4.9.0.1/crayclang/14.0
export PNETCDF_PATH=/opt/cray/pe/parallel-netcdf/1.12.3.1/crayclang/14.0
export MPIR_CVAR_GPU_EAGER_DEVICE_MEM=0
export MPICH_GPU_SUPPORT_ENABLED=1
export PNETCDF_HINTS=romio_cb_read=disable
export OMP_STACKSIZE=128M
export OMP_PROC_BIND=spread
export OMP_PLACES=threads