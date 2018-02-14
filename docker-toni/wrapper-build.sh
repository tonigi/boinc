#!/bin/bash

# This script creates a Docker environment which can build acemd2, mounts the parent directory, and starts the build 
# in an environment very similar to the one assumed in the Makefile (Toni feb '18)


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


wrapper_build="
    yum install -y libtool make
    cd /boinc
    ./_autosetup
    ./configure --disable-client --disable-manager --disable-server
    yum install -y epel-release
    yum install -y mingw64-gcc-c++ mingw64-gcc 
    cd /boinc/lib
    make -j4 -f Makefile.mingw MINGW=x86_64-w64-mingw32 all boinc_zip wrapper
"



docker create --mount type=bind,source=$DIR/..,destination=/boinc -it --name wrapper-build \
	centos:latest
	
docker start wrapper-build

docker exec -it wrapper-build /bin/bash -c "$wrapper_build"

