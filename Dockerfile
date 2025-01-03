## Start with the tidyverse docker image
FROM rocker/tidyverse:latest

WORKDIR /home/rstudio

RUN apt-get update

### Get R package libraries
RUN apt-get install -y \
     libnetcdf-dev \
     && apt-get clean

RUN install2.r --error \
    here \
    TSclust

ADD . /home/rstudio/main_project

RUN chmod -R a+rwX /home/rstudio/main_project

WORKDIR /home/rstudio/main_project

## RUN Rscript -e 'devtools::install_dev_deps()'
