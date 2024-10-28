#!/bin/bash

git clone https://github.com/rocker-org/rocker-versioned2.git

cp patches/dockerfiles/rstudio.Dockerfile rocker-versioned2/dockerfiles/my-rstudio.Dockerfile

cd rocker-versioned2

docker build . -f dockerfiles/my-rstudio.Dockerfile -t rstudio-server-cuda
