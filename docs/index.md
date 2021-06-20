# fastest-integration-tests

[![Build Status](https://travis-ci.org/andreyors/fastest-integration-tests.svg?branch=master)](https://travis-ci.org/andreyors/fastest-integration-tests)
[![Built with](https://img.shields.io/badge/Built_with-Cookiecutter_Django_Rest-F7B633.svg)](https://github.com/agconti/cookiecutter-django-rest)

fastest integration. Check out the project's [documentation](http://andreyors.github.io/fastest-integration-tests/).

# Prerequisites

- [Docker](https://docs.docker.com/docker-for-mac/install/)

# Initialize the project

Start the dev server for local development:

```bash
docker-compose up
```

Create a superuser to login to the admin:

```bash
docker-compose run --rm web ./manage.py createsuperuser
```
