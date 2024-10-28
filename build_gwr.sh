#!/bin/bash

mkdir gwmodel
curl -L -o ./gwmodel/gwmodel.tar.gz https://github.com/cran/GWmodel/archive/refs/tags/2.4-1.tar.gz

tar -xzvf ./gwmodel/gwmodel.tar.gz -C ./gwmodel

sed -i 's/-gencode arch=compute_35,code=sm_35 \\/#-gencode arch=compute_35,code=sm_35 \\/' gwmodel/GWmodel-2.4-1/src/Makevars.in
sed -i 's/-gencode arch=compute_37,code=sm_37 \\/#-gencode arch=compute_37,code=sm_37 \\/' gwmodel/GWmodel-2.4-1/src/Makevars.in
sed -i 's/-gencode arch=compute_75,code=sm_75/-gencode arch=compute_75,code=sm_75 \\/' gwmodel/GWmodel-2.4-1/src/Makevars.in
sed -i '/-gencode arch=compute_75,code=sm_75 \\/a \
-gencode arch=compute_80,code=sm_80 \\\
-gencode arch=compute_89,code=sm_89 \\\
-gencode arch=compute_90,code=sm_90 \\\
-gencode arch=compute_95,code=sm_95 ' gwmodel/GWmodel-2.4-1/src/Makevars.in


tar -czvf gwmodel/GWmodel-2.4-1.tar.gz -C gwmodel GWmodel-2.4-1

docker build . -t rstudio-server-gwr