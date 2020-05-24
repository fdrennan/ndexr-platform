FROM rocker/shiny-verse

RUN apt-get update -qq && apt-get install -y \
  git-core \
  libssl-dev \
  default-jdk \
  libcurl4-openssl-dev \
  curl \
  libxml2-dev \
  libpq-dev -y

RUN R CMD javareconf

RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('shinydashboard')"
RUN R -e "install.packages('scales')"
RUN R -e "install.packages('future')"
ARG DUMMY=rando
WORKDIR /app/
COPY ./redditor-api /app/redditor-api
RUN R -e "setwd('/app/redditor-api'); devtools::install()"