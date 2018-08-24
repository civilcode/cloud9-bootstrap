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
