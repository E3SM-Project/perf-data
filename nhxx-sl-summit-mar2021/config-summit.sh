HOMME=/ccs/home/ambradl/repo/E3SM/components/homme
suffix=-gpumpi
MACH=$HOMME/cmake/machineFiles/summit${suffix}.cmake
nlev=128
qsize=10

rm -rf CMakeFiles CMakeCache.txt
cmake -C $MACH \
    -DQSIZE_D=$qsize -DPREQX_PLEV=$nlev -DPREQX_NP=4  \
    -DBUILD_HOMME_SWEQX=FALSE \
    -DPREQX_USE_ENERGY=FALSE \
    -DCMAKE_CXX_FLAGS="--expt-relaxed-constexpr" \
    -DKokkos_ENABLE_CUDA_ARCH_LINKING=OFF \
    -DCMAKE_CXX_COMPILER="/ccs/home/ambradl/repo/E3SM/externals/kokkos/bin/nvcc_wrapper" \
    $HOMME
