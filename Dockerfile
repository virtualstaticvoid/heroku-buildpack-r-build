FROM heroku/heroku:16

ARG R_VERSION
ARG BUILD_NO
ARG FAKECHROOT_VER=2.19

ENV APP_DIR="/app"
ENV TOOLS_DIR="$APP_DIR/.tools"
ENV CHROOT_DIR="$APP_DIR/.root"
ENV FAKEROOT_DIR="$TOOLS_DIR/fakeroot"
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

# "install" fakeroot (since it's not included in heroku-16 base at runtime anymore)
# see https://devcenter.heroku.com/articles/stack-packages
RUN mkdir -p $FAKEROOT_DIR/bin $FAKEROOT_DIR/lib/x86_64-linux-gnu/libfakeroot \
 && cd $FAKEROOT_DIR \
 && cp /usr/bin/fakeroot bin/fakeroot \
 && cp /usr/bin/faked-sysv bin/faked-sysv \
 && cp /usr/bin/fakeroot-sysv bin/fakeroot-sysv \
 && cp /usr/lib/x86_64-linux-gnu/libfakeroot/libfakeroot-sysv.so lib/x86_64-linux-gnu/libfakeroot/libfakeroot-sysv.so \
 && sed -i "s#/usr#/app/.tools/fakeroot#g" bin/fakeroot

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
     /bin/sh -c 'echo "deb http://archive.ubuntu.com/ubuntu xenial main universe" > /etc/apt/sources.list' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'echo "deb http://archive.ubuntu.com/ubuntu xenial-security main universe" >> /etc/apt/sources.list' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'echo "deb http://archive.ubuntu.com/ubuntu xenial-updates main universe" >> /etc/apt/sources.list' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" >> /etc/apt/sources.list' \

 # postgres key
 && fakechroot fakeroot chroot $CHROOT_DIR \
     gpg --keyserver keyserver.ubuntu.com --recv-key ACCC4CF8 \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'gpg --export ACCC4CF8 > /var/tmp/ACCC4CF8 && apt-key add /var/tmp/ACCC4CF8 && rm /var/tmp/ACCC4CF8' \

 # cran key
 && fakechroot fakeroot chroot $CHROOT_DIR \
     gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     /bin/sh -c 'gpg --export E084DAB9 > /var/tmp/E084DAB9 && apt-key add /var/tmp/E084DAB9 && rm /var/tmp/E084DAB9' \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     apt-get -q update \

 && fakechroot fakeroot chroot $CHROOT_DIR \
     apt-get -qy upgrade

# install dependencies and R
RUN fakechroot fakeroot chroot $CHROOT_DIR \
  apt-get -qy install \
    build-essential \
    gfortran \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libgsl0-dev \
    libssl-dev \
    libxml2-dev \
    libxt-dev \
    pkg-config \
    software-properties-common \
    r-base-dev=${R_VERSION}* \
    r-recommended=${R_VERSION}*

# install pandoc
RUN fakechroot fakeroot chroot $CHROOT_DIR \
  /bin/sh -c 'curl -s -L https://github.com/jgm/pandoc/releases/download/1.19.2.1/pandoc-1.19.2.1-1-amd64.deb -o pandoc.deb && dpkg -i pandoc.deb && rm pandoc.deb'

# install shiny (as it's the most used on Heroku)
RUN fakechroot fakeroot chroot $CHROOT_DIR \
  /usr/bin/R -e "install.packages('shiny', repos='http://cran.rstudio.com/')"
