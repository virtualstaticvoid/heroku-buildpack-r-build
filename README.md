# Building the R binaries for the [heroku-buildpack-r][1] buildpack

The binaries for the build pack can be built in several ways.

* [Heroku][2] - Creates a production build of R
* [Vagrant][3] - For development, debugging and testing scripts

In each case, the scripts support specifying the R version and optionally the build version number to use.

  E.g.

  To build `R-3.0.4` on Heroku

  `$ build_with_heroku 3.0.4`

  or, build `R-3.1.0` on Heroku, with a build version of `20140101_31`

  `$ build_with_heroku 3.1.0 20140101_31`

  or, build `R-3.1.0` on Heroku, with a build version of `20140101_31` and specifing the stack to use

  `$ build_with_heroku 3.1.0 20140101_31 cedar-14`

## Building R on Heroku

`$ build_with_heroku [R_VERSION [BUILD_NO STACK]]`

  R_VERSION     R version to build.
                Defaults to 3.1.0

  BUILD_NO      Build number for the output files.
                Defaults to the date in %Y%m%d-%H%M format.

  STACK         Heroku stack to use for building R binaries
                Valid values include "cedar" and "cedar-14"
                Defaults to "cedar-14" which is the Heroku default

## Building R on Vagrant

**Note**: This method hasn't been implemented yet.

This method uses a Vagrant virtual machine, which runs a [cedar like stack][4] so that you can develop, debug
and test the build scripts in an interactive way before building using the Heroku method.

`$ build_with_vagrant [R_VERSION [BUILD_NO]]`

[1]: https://github.com/virtualstaticvoid/heroku-buildpack-r
[2]: https://www.heroku.com
[3]: http://www.vagrantup.com
[4]: https://github.com/ejholmes/vagrant-heroku
