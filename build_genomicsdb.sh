#!/bin/bash

CMAKE_BUILD_TYPE=Debug
CMAKE_INSTALL_PREFIX=$HOME

check_rc() {
  if [[ $# -eq 1 ]]; then
    if [[ -z $1 ]]; then
      echo "make returned $1. Quitting GenomicsDB Build"
      exit $1
    fi
  fi
}

source ~/env-protobuf-3.0.x.sh

cd $HOME

if [[ "$PROTOBUF_LIBRARY" = "" ]]; then
  echo "PROTOBUF_LIBRARY env variable not defined. Exiting build."
  exit 1
else
  echo "PROTOBUF_LIBRARY env variable set to $PROTOBUF_LIBRARY"
fi

# GenomicsDB
echo 
echo "Installing GenomicsDB..."
git clone --recursive https://github.com/nalinigans/GenomicsDB.git
cd GenomicsDB
git submodule update --recursive --init
mkdir build
cd build

echo "Building GenomicsDB without Cloud Storage support"
cmake -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE -DCMAKE_INSTALL_PREFIX=$CMAKE_INSTALL_PREFIX -DBUILD_JAVA=1 -DPROTOBUF_LIBRARY=${PROTOBUF_LIBRARY} ..

check_rc $!
make -j4 && make install
check_rc $!

echo "Installing GenomicsDB DONE"

