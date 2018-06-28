#!/bin/bash

# This script creates a Docker environment which can build acemd2, mounts the parent directory, and starts the build 
# in an environment very similar to the one assumed in the Makefile (Toni feb '18)


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


build_cmd="
    yum install -y libtool git gcc-c++
    cd /boinc
    ./_autosetup
    ./configure --disable-client --disable-manager --disable-server --enable-boinczip
    make -j8
    make -C samples/wrapper
"

crossbuild_cmd="
    yum install -y epel-release
    yum install -y mingw64-gcc-c++ mingw64-gcc
    
"



docker create --mount type=bind,source=$DIR/..,destination=/boinc \
	-it --name boinc-build \
	centos:6
	
docker start boinc-build

docker exec -it boinc-build /bin/bash -c "$build_cmd"

