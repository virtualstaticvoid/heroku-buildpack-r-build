FROM r-base:3.3.2

MAINTAINER Chris Stefano <virtualstaticvoid@gmail.com>

RUN /usr/bin/R -e "install.packages('shiny')"

