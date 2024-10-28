FROM rstudio-server-cuda

RUN apt-get update && apt-get install \
					libudunits2-dev \
					libproj-dev \
					libgdal-dev \
					-y

RUN apt-get update && apt-get install \
                    curl \
                    iputils-ping \
					-y

RUN Rscript -e "install.packages(c('spgwr', 'sf', 'readxl', 'sp'), repos='https://cloud.r-project.org/')"
RUN Rscript -e "install.packages(c('robustbase', 'spacetime', 'spdep', 'spatialreg', 'FNN', 'RcppArmadillo', 'RcppEigen'), repos='https://cloud.r-project.org/')"

RUN mkdir /gwr-cuda
COPY ./gwmodel/GWmodel-2.4-1.tar.gz /gwr-cuda/gwr-cuda.tar.gz

COPY ./patches/install_gwr.sh /rocker_scripts

