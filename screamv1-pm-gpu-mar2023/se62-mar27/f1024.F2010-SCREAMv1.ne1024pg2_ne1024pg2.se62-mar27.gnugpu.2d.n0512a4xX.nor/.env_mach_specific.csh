# This file is for user convenience only and is not used by the model
# Changes to this file will be ignored and overwritten
# Changes to the environment should be made in env_mach_specific.xml
# Run ./case.setup --reset to regenerate this file
source /usr/share/lmod/8.3.1/init/csh
module unload cray-hdf5-parallel cray-netcdf-hdf5parallel cray-parallel-netcdf PrgEnv-gnu PrgEnv-nvidia PrgEnv-cray PrgEnv-aocc cudatoolkit craype-accel-nvidia80 craype-accel-host perftools-base perftools darshan
module load PrgEnv-gnu/8.3.3 gcc/11.2.0 cudatoolkit/11.5 craype-accel-nvidia80 cray-libsci/23.02.1.1 craype/2.7.19 cray-mpich/8.1.24 cray-hdf5-parallel/1.12.2.3 cray-netcdf-hdf5parallel/4.9.0.3 cray-parallel-netcdf/1.12.3.3 cmake/3.24.3
setenv MPICH_ENV_DISPLAY 1
setenv MPICH_VERSION_DISPLAY 1
setenv OMP_STACKSIZE 128M
setenv OMP_PROC_BIND spread
setenv OMP_PLACES threads
setenv HDF5_USE_FILE_LOCKING FALSE
setenv PERL5LIB /global/cfs/cdirs/e3sm/perl/lib/perl5-only-switch
setenv MPICH_COLL_SYNC MPI_Bcast
setenv MPICH_GPU_SUPPORT_ENABLED 1
setenv ADIOS2_DIR /global/cfs/cdirs/e3sm/3rdparty/adios2/2.8.3.patch/cray-mpich-8.1.15/gcc-11.2.0