prefix=v2-overview-wccase-chrysalis-r0

for i in $prefix.A_WCYCL1850S_CMIP6.ne30_oECv3.* $prefix.WCYCL1850.ne30pg2_EC30to60E2r2.*; do
    (cd $i/run; tar xvfz timing*gz);
done
