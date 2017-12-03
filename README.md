# Terraform-Ansible-Docker-K8s

## Introduction

This repos contains a complete installation of Kubernetes (k8s) using terraform to provision EC2 instances on AWS, and Ansible playbooks to install docker, etcd, k8s masters and nodes.
You can manage number of masters and nodes in the terraforms variables (see master-count and node-count bellow)

For sake of simplicity, etcd will be installed on the same instance(s) than the master(s).

### Terraform configuration

* image-flavor: type of instance you want to create (for example "t2.micro") It is not possible at this time to have a different size of instance per type of server.
* key-pair: name of the public key you declared in AWS to connect to your insances
* aws-region: region of the AWS instance (for example "eu-west-1")
* tag-name: name of the instance
* tag-cpaccount: another tag (if you don't need it, remove it from terraform .tf)
* master-count: number of master instances you want to create
* node-count: number of nodes instances you want to create
* aws-ssh-key: Path to your private key (variable named key-pair) you attached to the instances.

### Ansible configuration

```
ansible
├── group_vars
├── inventories
│   └── test
└── roles
    ├── common
    │   ├── tasks
    │   └── templates
    └── docker
        ├── tasks
        │   └── docker.yml
        └── templates
```

## Configuration

### Install dependencies

#### Mac OS X

##### Ansible

```
% brew install ansible
```

##### Terraform

Download the appropriate package from https://www.terraform.io/downloads.html and install the binary :

```
% sudo mv ~/Downloads/terraform /usr/local/bin
```

### AWS role secrets

Copy aws-keys-example.sh to aws-keys.sh and replace __YOUR_KEY_ID__ and __YOUR_SECRET_KEY__ strings with your aws key id and access secret. 

```
export AWS_ACCESS_KEY_ID=__YOUR_KEY_ID__
export AWS_SECRET_ACCESS_KEY=__YOUR_SECRET_KEY__
```

Then execute:
```
% source  aws-keys.sh
```

### Terraform variables

Copy terraform-example.tfvars into terraform.tfvars and set variables according to your configuration.
In this example, the ami correspond to a ubuntu 16.04. Set the key pair that is provisioned in your aws account. It will be used by ansible to configure your instances.

```
ami="ami-785db401"
image-flavor="t2.micro"
key-pair="your-key-name"
region="eu-west-1"
tag-name="optionnal-aws-intance-name-tag"
tag-cpaccount="another-optionnal-tag"
```

### Initialize terraform providers

Execute:

```
% terraform init

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "null" (1.0.0)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 1.5"
* provider.null: version = "~> 1.0"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

This will create a local .terraform directory with required plugins:

```
.terraform
└── plugins
    └── darwin_amd64
        ├── lock.json
        ├── terraform-provider-aws_v1.5.0_x4
        └── terraform-provider-null_v1.0.0_x4
```

## Launch the plan

Check the terraform execution with:

```
% terraform plan
```

If everything is ok:

```
% terraform apply
```

## References

* https://rsmitty.github.io/Terraform-Ansible-Kubernetes/
