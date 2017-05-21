FROM heroku/heroku:16

ARG R_VERSION
ARG BUILD_NO
ARG FAKECHROOT_VER=2.19

ENV APP_DIR="/app"
ENV TOOLS_DIR="$APP_DIR/.tools"
ENV CHROOT_DIR="$APP_DIR/.root"
ENV FAKECHROOT_DIR="$TOOLS_DIR/fakechroot"
ENV PATH="$FAKECHROOT_DIR/sbin:$FAKECHROOT_DIR/bin:$PATH"

# install prerequisites
RUN apt-get -q update \
 && apt-get -qy install \
      xz-utils \
      fakeroot \
      autogen \
      autoconf \
      libtool \
      debootstrap

# install fakechroot
RUN git clone -b "$FAKECHROOT_VER" --single-branch --depth 1 https://github.com/dex4er/fakechroot.git \
 && cd fakechroot \
 && ./autogen.sh \
 && ./configure --prefix=$FAKECHROOT_DIR \
 && make \
 && make install

# install debootstrap linux
RUN fakechroot fakeroot debootstrap --variant=fakechroot --arch=amd64 xenial $CHROOT_DIR

# fix up bashrc inside chroot
ENV BASH_RC_FILE="$CHROOT_DIR/root/.bashrc"
RUN sed -i -e s/#force_color_prompt=yes/force_color_prompt=yes/ $BASH_RC_FILE

# configure apt for R packages
RUN fakechroot fakeroot chroot $CHROOT_DIR \
  /bin/sh -c 'echo "deb http://archive.ubuntu.com/ubuntu xenial main" > /etc/apt/sources.list' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'echo "deb http://archive.ubuntu.com/ubuntu xenial-updates main" >> /etc/apt/sources.list' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'echo "deb http://archive.ubuntu.com/ubuntu xenial universe" >> /etc/apt/sources.list' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'echo "deb http://archive.ubuntu.com/ubuntu xenial-updates universe" >> /etc/apt/sources.list' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'gpg --export E084DAB9 > /var/tmp/E084DAB9 && apt-key add /var/tmp/E084DAB9 && rm /var/tmp/E084DAB9' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     apt-get -q update

# install dependencies and R
RUN fakechroot fakeroot chroot $CHROOT_DIR \
  apt-get -qy install \
    build-essential \
    gfortran \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libgsl0-dev \
    libssl-dev \
    libxt-dev \
    pkg-config \
    r-base-dev=${R_VERSION}* \
    r-recommended=${R_VERSION}*

# install pandoc
RUN fakechroot fakeroot chroot $CHROOT_DIR \
  /bin/sh -c 'curl -s -L https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb -o pandoc.deb && dpkg -i pandoc.deb && rm pandoc.deb'

# install shiny (as it's the most used on Heroku)
RUN fakechroot fakeroot chroot $CHROOT_DIR \
  /usr/bin/R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"

# check
RUN fakechroot fakeroot chroot $CHROOT_DIR \
  /usr/bin/R -e "capabilities()"
