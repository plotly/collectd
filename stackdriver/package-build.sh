#!/bin/bash -xe
VERSION=5.5.2

if [ "x$BRANCH" == "x" ]
then
    BRANCH=stackdriver-agent-$VERSION
fi

if [ "x$PKGFORMAT" == "xdeb" ]
then
    # debian denotes 64 arches with amd64
    [ "x$ARCH" == "xx86_64" ] && ARCH="amd64" || true
    git clone git@github.com:Stackdriver/agent-packaging.git --branch $BRANCH
    pushd agent-packaging
    mv deb/* .
    mv collectd.conf debian/
    make clean
    make DISTRO="$DISTRO" ARCH="$ARCH" VERSION="$VERSION" BUILD_NUM="$BUILD_NUM" build || exit $?
    popd
elif [ "x$PKGFORMAT" == "xrpm" ]
then
    git clone git@github.com:Stackdriver/agent-packaging.git --branch $BRANCH
    pushd agent-packaging
    mv rpm/* .
    make clean
    make DISTRO="$DISTRO" ARCH="$ARCH" VERSION="$VERSION" BUILD_NUM="$BUILD_NUM" build || exit $?
    popd
else
    echo "I don't know how to handle label '$PKGFORMAT'. Aborting build"
    exit 1
fi

