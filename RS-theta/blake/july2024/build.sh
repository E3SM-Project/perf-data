#!/bin/bash

source load-blake

suffix2=""

wdir=`pwd`             # run directory
HOMME=${HOME}/acme-master/components/homme                # HOMME svn checkout     
echo $HOMME
bld=$wdir/bldxx             # cmake/build directory

MACH=$HOMME/cmake/machineFiles/blake.cmake

mkdir -p $bld
cd $bld
conf=1
rm $bld/CMakeCache.txt    # remove this file to force re-configure

if [ $conf ]; then
   rm -rf CMakeFiles CMakeCache.txt src
   echo "running CMAKE to configure the model"

   cmake -C $MACH $HOMME
   make -j32 theta-nlev128-kokkos

   #now save build info
   cd ${wdir}
   rm -f gitstat-* CMakeCache.txt-* KokkosCore_config.h-* env-*

   gitstat=gitstat

   cd ${HOMME}
   pwd

   echo " running stats on clone ${which}"
   echo " status is ------------- " > ${gitstat}
   git status >> ${gitstat}
   echo " branch is ------------- " >> ${gitstat}
   git branch >> ${gitstat}
   echo " diffs are ------------- " >> ${gitstat}
   git diff >> ${gitstat}
   echo " last 10 commits are ------------- " >> ${gitstat}
   git log --first-parent  --pretty=oneline  HEAD~10..HEAD  >> ${gitstat}
   cd $wdir
   pwd

   tt=`date +%s`
   mv ${HOMME}/${gitstat} gitstat${suffix2}-${tt}

   cp ${bld}/CMakeCache.txt CMakeCache.txt${suffix2}-${tt}
   cp ${bld}/kokkos/build/KokkosCore_config.h KokkosCore_config.h${suffix2}-${tt}
   env > env${suffix2}-${tt}

fi


