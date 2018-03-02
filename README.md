# An example for debugging course images locally

This repository is deisgned to assist Curriculum Leads in the Content team get started testing `requirements.sh` files for their courses on their own machines (rather than breaking the build system).

## Getting set up

First, read the [main set of instructions](https://github.com/datacamp/image-management-backend/wiki/Setting-up-images) for debugging course image requirements.

In particular, you need to [install docker](https://docs.docker.com/docker-for-mac/install), and ask Filip for the credentials file to access DataCamp's Docker hub.

You'll also need a text editor and the terminal.

## Creating a course image to test

The course image needs two files. The names of these files are important (don't change them) and are case sensitive.

- `Dockerfile` contains the instructions for Docker to build the image.
- `requirements.sh` contains the instructions for installing any additional software or datasets into the image.

## `Dockerfile` contents

This file should contain code like

```docker
FROM dockerhub.datacamp.com:443/msft-sql-base-prod:32
ADD requirements.sh requirements.sh
RUN chmod u+x requirements.sh
RUN ./requirements.sh
```

Let's step through this line by line.

### `FROM dockerhub.datacamp.com:443/msft-sql-base-prod:32`

The first line says "derive this image *from* DataCamp's SQL Server base image, version 32". This is the only line that you want to change.

The base image that you want to derive from depends upon the technology that the course is built upon.

|Tech      |Image                                                                                |Example FROM field                                     |
|----------|-------------------------------------------------------------------------------------|-------------------------------------------------------|
|R         |[docker-r-base](https://github.com/datacamp/docker-r-base/releases)                  |`FROM dockerhub.datacamp.com:443/r-base-prod:30`         |
|Python    |[docker-python-base](https://github.com/datacamp/docker-python-base/releases)        |`FROM dockerhub.datacamp.com:443/python-base-prod:21`    |
|PostgreSQL|[docker-postgresql-base](https://github.com/datacamp/docker-postgresql-base/releases)|`FROM dockerhub.datacamp.com:443/postgresql-base-prod:22`|
|SQL Server|[docker-msft-sql-base](https://github.com/datacamp/docker-msft-sql-base/releases)    |`FROM dockerhub.datacamp.com:443/msft-sql-base-prod:32`  |
|Shell     |[docker-shell-base](https://github.com/datacamp/docker-shell-base/releases)          |`FROM dockerhub.datacamp.com:443/shell-base-prod:22`     |

### `ADD requirements.sh requirements.sh`

The second line says "add `requirements.sh` from its current location on disk (relative to the `Dockerfile`) to a location within the image".

### `RUN chmod u+x requirements.sh`

The third line says "run the chmod command to make requirements.sh executable by the user who owns it", so that Docker can run this script.

### `RUN ./requirements.sh`

The fourth line says run the "requirements.sh shell script".

## `requirements.sh` contents

This is where you get to experiment with doing whatever you need to do to add things to the image. Some things to bear in mind are:

### You are repl

DataCamp's build process specifies that the user that is building the image is called `repl`. The current working directory is `/home/repl`. See, for example, `docker-r-base`'s [`Dockerfile`](https://github.com/datacamp/docker-r-base/blob/master/Dockerfile#L38).

### You have access to standard-issue command line tools

In particular, you can download files from Amazon S3 to the image using [`wget`](https://www.gnu.org/software/wget/manual/wget.html) or [`curl`](https://curl.haxx.se/docs/manpage.html).

```sh
wget https://s3.amazonaws.com/assets.datacamp.com/production/course_9999/datasets/my_data.csv
```

(Though for local testing purposes, to save you downloading datasets over and over, it's best to just put any files in the same directory as the Dockerfile.)

### You can get additional tools using apt-get or pip

If you want to install additional software, use `apt-get` (Linux package installation) or `pip`/`pip3` (Python installer).

```sh
apt-get update && apt-get --yes install python-dev python-pip tar

pip install tensorflow==1.4.0
```

## Building the image

To build the image

1. Open a terminal.
1. Navigate to the directory containing the `Dockerfile` and `requirements.sh`.
1. Run `docker build --tag datacamp/test-image .`. 

To explain the last command:

- `docker`: Run the [Docker command line](https://docs.docker.com/engine/reference/commandline/cli) tool.
- `build`: You want to [build](https://docs.docker.com/engine/reference/commandline/build) a docker image.
- `--tag`: tag the image.
- `datacamp/test-image`: The [tag](https://docs.docker.com/engine/reference/commandline/tag/). Change this value to something more descriptive of your course.
- `.`: The directory containing your files, in this case the current directory.
