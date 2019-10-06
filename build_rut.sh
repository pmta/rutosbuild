#!/bin/sh

if [ "${LOCALBUILDDIR}x" != "x" ]
then
  echo "Using LOCALBUILDDIR ${LOCALBUILDDIR}"
  cd ${LOCALBUILDDIR}
else
  echo "LOCALBUILDDIR not set??"
fi

# configure with old settings (defaults)
yes "" | make oldconfig
if [ $? -ne 0 ]
then
  echo "Error make config "
  # Even without generating config it should 
  # be possible to compite with (old) defaults
  # So not going to exit here
fi


# Build
if [ "${NPROC}x" != "x" ]
then
  if [ ${NPROC} -le 0 ]
  then
    echo "Overriding NPROC ENV variable ${NPROC} with 1, need at least 1 job (CPU)."
    NPROC=1
  else
    echo "Using ${NPROC} jobs for compilation (as defined by NPROC ENV variable)"
  fi
  jobs=${NPROC}
else
  # Number of CPUs + 2 jobs (so there is always more work for them..)
  cores=`nproc`
  jobs=`expr ${cores} + 2`
  echo "Using ${jobs} jobs for compilation (${cores} CPUs + 2)"
fi

nice -n 19 make -j ${jobs}
if [ $? -ne 0 ]
then
  echo "Build error"
  exit 1
else
  echo "Build successful"
  exit 0
fi

