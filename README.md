# Building the R binaries for the [heroku-buildpack-r][1] buildpack

*NOTE: This repository is NO LONGER SUPPORTED. Please use [heroku-buildpack-r-build2](https://github.com/virtualstaticvoid/heroku-buildpack-r-build2) instead.*

The binaries for the build pack can be built using an Heroku application.

The scripts support specifying the R version and optionally the build version number to use.

  E.g.

  To build `R-3.0.4` on Heroku

  `$ build_with_heroku 3.0.4`

  or, build `R-3.1.2` on Heroku, specifying the stack

  `$ build_with_heroku 3.1.2 cedar-14`

  or, build `R-3.1.2` on Heroku, cedar-14 stack, with a build version of `20150301_4123`

  `$ build_with_heroku 3.1.2 cedar-14 20150301_4123`

## Building R on Heroku

`$ build_with_heroku [R_VERSION [BUILD_NO STACK]]`

  R_VERSION     R version to build.
                Defaults to 3.2.4

  STACK         Heroku stack to use for building R binaries
                Valid values include "cedar" and "cedar-14"
                Defaults to "cedar-14" which is the Heroku default

  BUILD_NO      Build number for the output files.
                Defaults to the date in %Y%m%d-%H%M format.

[1]: https://github.com/virtualstaticvoid/heroku-buildpack-r
