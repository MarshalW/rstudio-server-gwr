#!/bin/bash

git clone https://github.com/rocker-org/rocker-versioned2.git

cp patches/dockerfiles/rstudio.Dockerfile rocker-versioned2/dockerfiles/my-rstudio.Dockerfile
cp patches/install_R_source.sh rocker-versioned2/scripts

cd rocker-versioned2

docker build . -f dockerfiles/my-rstudio.Dockerfile -t rstudio-server-cuda
