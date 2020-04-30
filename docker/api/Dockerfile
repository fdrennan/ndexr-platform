FROM trestletech/plumber
MAINTAINER Docker User <docker@user.org>

RUN apt-get update --allow-releaseinfo-change -qq && apt-get install -y \
  git-core \
  libssl-dev \
  libcurl4-openssl-dev \
  libxml2-dev \
  pandoc \
  libpq-dev \
  python3.6 \
  virtualenv \
  python3-pip \
  python3-venv


RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('reticulate')"
RUN R -e 'devtools::install_github("fdrennan/biggr")'

ARG DUMMY=unknown
RUN R -e 'devtools::install_github("fdrennan/redditor")'
RUN R -e 'library(reticulate); \
          library(biggr); \
          use_python("/usr/bin/python3", required = TRUE); \
          install_python(envname="redditor")'

EXPOSE 8000
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb(commandArgs()[4]); pr$run(host='0.0.0.0', port=8000)"]
CMD ["/app/plumber.R"]
