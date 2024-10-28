#!/bin/bash
set -e

R CMD INSTALL /gwr-cuda/gwr-cuda.tar.gz  --configure-args=--enable-cuda=yes