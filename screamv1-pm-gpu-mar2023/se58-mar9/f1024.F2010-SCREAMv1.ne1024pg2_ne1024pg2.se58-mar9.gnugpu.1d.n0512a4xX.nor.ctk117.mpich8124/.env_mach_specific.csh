# This file is for user convenience only and is not used by the model
# Changes to this file will be ignored and overwritten
# Changes to the environment should be made in env_mach_specific.xml
# Run ./case.setup --reset to regenerate this file
source /usr/share/lmod/8.3.1/init/csh
module unload cray-hdf5-parallel cray-netcdf-hdf5parallel cray-parallel-netcdf PrgEnv-gnu PrgEnv-nvidia cudatoolkit craype-accel-nvidia80 craype-accel-host perftools-base perftools darshan
module load PrgEnv-gnu/8.3.3 gcc/11.2.0 cudatoolkit/11.7 craype-accel-nvidia80 cray-libsci craype cray-mpich/8.1.24 cray-hdf5-parallel/1.12.2.1 cray-netcdf-hdf5parallel/4.9.0.1 cray-parallel-netcdf/1.12.3.1 cmake/3.22.0
setenv MPICH_ENV_DISPLAY 1
setenv MPICH_VERSION_DISPLAY 1
setenv OMP_STACKSIZE 128M
setenv OMP_PROC_BIND spread
setenv OMP_PLACES threads
setenv HDF5_USE_FILE_LOCKING FALSE
setenv PERL5LIB /global/cfs/cdirs/e3sm/perl/lib/perl5-only-switch
setenv MPICH_COLL_SYNC MPI_Bcast
setenv MPICH_GPU_SUPPORT_ENABLED 1