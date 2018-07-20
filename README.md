# Cloud9 Bootstrap

## Cloud9 Setup

Cloud9 Bootstrap will guide you in setting up a Cloud9 instance for a CivilCode project based on
our [reference application](https://github.com/civilcode/magasin-platform).

### Setup an EC2 instance

Login to Amazon AWS, choose Cloud9 service and in `your environments` tab choose
to `Create environment.`

When prompted for the environment settings choose:
- `Create a new instance for environment(EC2)`
- `m4.large` as instance type as you will be using Docker exclusively
- leave cost saving setting set to 30 mins (default)

### Installation script

The script will configure the environment to for Docker.

    cd
    wget https://raw.githubusercontent.com/civilcode/cloud9-bootstrap/master/install.sh
    sh ./install.sh

### Share environment with the team

In the right top corner there is a share button which allows you to give access to the
Cloud9 environment.

## Setting up Docker

### Configure the project

Replace the `Dockerfile.dev` file with the `Dockerfile` contained in this repository. Customize as
necessary. Follow the standard instructions for setting up a development environment with Docker.

https://github.com/civilcode/magasin-platform#development-setup

### About the Dockerfile

The Dockerfile will produce an image with a full development environment (i.e. zsh, git, hub) and
configure with [`dotfiles`](https://github.com/civilcode/dotfiles). This allows us to work within
a running container. To do this, connect to the `application` container for the project:

    docker-compose up -d # ensure containers are running
    docker-compose exec application zsh
