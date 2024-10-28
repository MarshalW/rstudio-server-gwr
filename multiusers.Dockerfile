FROM rstudio-server-gwr

RUN useradd --create-home --shell /bin/bash testuser && echo 'testuser:password' | chpasswd
RUN usermod -aG staff testuser
