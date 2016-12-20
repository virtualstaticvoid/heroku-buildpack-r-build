# Building the R binaries for the [heroku-buildpack-r][1] buildpack

The binaries for the build pack can be built using docker.

The scripts support specifying the R version and optionally the build version number to use.

  E.g.

  To build `R-3.0.4`, run

  `$ build_with_docker 3.0.4`

  or, with a build version of `20150301_4123`

  `$ build_with_docker 3.0.4 20150301_4123`

[1]: https://github.com/virtualstaticvoid/heroku-buildpack-r
