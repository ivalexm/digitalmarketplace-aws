# Digital Marketplace AWS

This repository contains configuration and utility tools we use for setting up our infrastructure
and manage our release process.

## Structure

There are a few independent tools we're using that are configured and run from this repo:

* [Terraform](https://www.terraform.io/) (modules and configuration files in `terraform/`) is used
  to create and manage AWS resources (EC2 instances, ELBs, CloudWatch logs, S3 buckets etc.)
* [packer](https://www.packer.io/) (configuration templates in `packer/`) is used to build AMIs
  for servers we're running in AWS EC2 (like nginx and elasticsearch)
* [Ansible](https://docs.ansible.com/ansible/index.html) (configuration and roles in `playbooks/`) is
  used by packer to set up the software and configuration of the AMIs
* `scripts` contains executable scripts we use to manage our PaaS environments
* `dmaws` contains some helper python functions used by some of the scripts
* `paas` contains PaaS manifest templates that are rendered by `make generate-manifest`
* `vars` contains environment specific variables used in the PaaS manifest generation

## Setup

### Set up python dependencies
Install dependencies with [virtualenv](https://virtualenv.pypa.io/en/latest/)
and [pip](https://pip.pypa.io/en/latest/installing.html).

```
make requirements
```

## Terraform

For Terraform setup and usage please check the separate ([README](terraform/README.md)).

## Creating AMIs with packer

`elasticsearch` and `nginx` stacks require custom AMIs with preinstalled packages.
In order to create new versions of these AMIs you'll need to use the provided
[packer](https://www.packer.io) templates. Running

    `make {nginx|elasticsearch}`

will create a new AMI image using the AWS credentials from the default credentials file
or the environment variables.

You can get the ID of the created AMI from the packer command output or the AWS console,
however Terraform will automatically pick up the IDs of the newest AMIs when planning/applying.
It will then apply the new AMI to the AutoScaling groups, so that new EC2 instances will use the new AMI.

Packer or Terraform won't automatically remove old AMI versions, so this has to be
done manually. There is a script, which can be run with

  `make clean`

which will fetch the IDs of all AMIs who's names match either `nginx*` or `terraform*`. It then
deregisters their image and deletes their snapshot. This script should *only* be used if the newest
AMIs are being used in *all three* environments. If not the AMIs for one or more environments will be
removed and the AutoScaling groups will no longer be able to scale.

AMIs can be deleted from the EC2 console by deregestering the AMI and
deleting the related EBS snapshot.

## Deploying AWS Lambda functions

Lambda functions are created by the CloudFormation stack, but rerunning the stack won't updated
the function code. Instead, functions can be updating using the `lambda-release` command:

```
dmaws lambda-release preview cloudwatch_logs_lambda
```

This will package function code from `lambdas/cloudwatch_logs`, upload the archive to S3 and update
the function code in AWS Lambda.

This command can also be used to upload the initial function code archive to S3 before running the
function stack for the first time. In this case, updating the function code will fail, since the
function doesn't exist yet, but an archive will be uploaded to S3 and CloudFormation will use it
when creating the function stack.

## SSHing into instances

You can SSH onto instaces using the private key set up previously (SSH key pair).

```
ssh -i path/to/private.pem ec2-user@public-dns
```

SSH into ElasticBeanstalk instances with the user `ec2-user`.
SSH into all other EC2 instances with the user `ubuntu`.
