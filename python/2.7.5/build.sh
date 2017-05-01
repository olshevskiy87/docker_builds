#!/usr/bin/env bash

which docker > /dev/null 2>&1

if [ "$?" != "0" ]; then
    echo "docker is not found"
    exit 1
fi

image_name=py_build_centos

if [ "$1" ]; then
    image_name="$1"
fi

sudo docker build -t $image_name .
