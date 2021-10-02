for i in F2010-CICE.ne30pg2_ne30pg2.* FC5AV1C-L.ne30_ne30.*; do
    (cd $i/run; tar xvfz timing*gz);
done
