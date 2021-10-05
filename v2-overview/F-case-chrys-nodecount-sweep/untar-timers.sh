prefix=v2-overview-fcase-chrysalis-r0

for i in $prefix.F2010-CICE.ne30pg2_ne30pg2.* $prefix.FC5AV1C-L.ne30_ne30.*; do
    (cd $i/run; tar xvfz timing*gz);
done
