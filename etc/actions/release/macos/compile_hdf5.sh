#!/bin/bash

set -e
set -x

PREFIX=$1
CC=$2
CXX=$3

sudo mkdir -p "$PREFIX/pkg"
cd "$PREFIX/pkg"

wget https://support.hdfgroup.org/releases/hdf5/v1_14/v1_14_6/downloads/hdf5-1.14.6.tar.gz
tar -zxf hdf5-1.14.6.tar.gz
cd hdf5-1.14.6
./configure --enable-cxx --prefix="$PREFIX" CC="$CC" CXX="$CXX"
make -j2
make install
