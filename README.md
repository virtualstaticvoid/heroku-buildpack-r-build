# Building the R binaries for the [heroku-buildpack-r][1] buildpack

Scripts for building the R buildpack for Heroku

## Prerequisites

* AWS Account for S3
* Configured AWS credentials as per [Standardized Way to Manage Credentials][2], using `heroku-buildpack-r` for the profile name
* Docker
* The [`heroku/cedar:14`][3] docker image
* Heroku Account

## Usage

The binaries for the buildpack are built using docker.

The `build_with_docker` script supports specifying the R version and optionally the build version number to use.

  E.g.

  To build R version `3.0.4`, run

  `$ build_with_docker 3.0.4`

  or, with a build version of `20150301_4123`

  `$ build_with_docker 3.0.4 20150301_4123`

[1]: https://github.com/virtualstaticvoid/heroku-buildpack-r
[2]: https://aws.amazon.com/blogs/security/a-new-and-standardized-way-to-manage-credentials-in-the-aws-sdks/
[3]: https://hub.docker.com/r/heroku/cedar/
