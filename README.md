# packer-ubuntu-focal

## Background

This repo provides a [HashiCorp](https://hashicorp.com) [Packer](https://packer.io) template for building machine image(s) based on [Ubuntu 20.04 (Ubuntu Focal)](https://releases.ubuntu.com/focal/).

Packer allows you to deliver identical images for multiple public and private cloud platforms from a common configuration.

The Packer template in this repo builds off of Ubuntu Focal, and delivers images on [AWS](https://aws.amazon.com) and [Azure](https://azure.microsoft.com). Note that by default, the Azure build is commented out.

The images that are built are registered in the HashiCorp Cloud Platform ([HCP](https://cloud.hashicorp.com)) Packer Registry.

### Provisioners

This Packer template uses the [Shell provisioner](https://developer.hashicorp.com/packer/docs/provisioners/shell) and [Ansible provisioner](https://developer.hashicorp.com/packer/integrations/hashicorp/ansible/latest/components/provisioner/ansible). The Ansible provisioner calls the [playbook.yaml](playbook.yaml) Ansible playbook to configure and install software in the image.

## Usage

### Prerequisites

#### Software

This Packer template has been tested with the following software on a Mac running macOS on Apple Silicon.

* [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli) version 1.10.0.
* [Ansible](https://www.ansible.com/) version 2.16.2.

For the Ansible provisioner, please add the following to your `.ansible.cfg` file:

```
[ssh_connection]
transfer_method = smart
```

#### Cloud Credentials

For provisioning to AWS, you will need AWS clould credentials. Set these as environment variables:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_SESSION_TOKEN` # if needed for your AWS account

For registering the image with the HCP Packer Registry, you will need HCP cloud credentials. Set these as environment variables as follows:

* `HCP_CLIENT_ID`
* `HCP_CLIENT_SECRET`

#### Packer Variables

Set the values for Packer variables. See [yash.pkrvars.hcl](yash.pkrvars.hcl) for an example.

### Running Packer

#### Initialize Packer

```
packer init -var-file=<variables file> .
```

#### Check and correct formatting of the Packer configuration

```
packer fmt -var-file=<variables file> .
```

#### Validate the Packer configuration

```
packer validate -var-file=<variables file> .
```

#### Build the machine image(s)

```
packer build -var-file=<variables file> .
```

### Example Run

<details>
  <summary>Initialize Packer</summary>

```
❯ packer init -var-file=yash.pkrvars.hcl .
Installed plugin github.com/hashicorp/amazon v1.2.9 in "/Users/demo/.config/packer/plugins/github.com/hashicorp/amazon/packer-plugin-amazon_v1.2.9_x5.0_darwin_arm64"
Installed plugin github.com/hashicorp/ansible v1.1.1 in "/Users/demo/.config/packer/plugins/github.com/hashicorp/ansible/packer-plugin-ansible_v1.1.1_x5.0_darwin_arm64"
```
</details>

<details>
  <summary>Format the Packer configuration</summary>

`packer fmt` will return no output if everything is properly formatted.
```
❯ packer fmt -var-file=yash.pkrvars.hcl .
yash.pkrvars.hcl
```
</details>

<details>
  <summary>Validate the Packer configuration</summary>

```
❯ packer validate -var-file=yash.pkrvars.hcl .
The configuration is valid.
```
</details>

<details>
  <summary>Build the machine image(s)</summary>

```
❯ packer build -var-file=yash.pkrvars.hcl .
Tracking build on HCP Packer with fingerprint "01HKQ9BRJX58JN28AWFG5E594Y"
amazon-ebs.ubuntu-us-east: output will be in this color.

==> amazon-ebs.ubuntu-us-east: Prevalidating any provided VPC information
==> amazon-ebs.ubuntu-us-east: Prevalidating AMI Name: ubuntu-focal-golden-image-1704809849
    amazon-ebs.ubuntu-us-east: Found Image ID: ami-027a754129abb5386
==> amazon-ebs.ubuntu-us-east: Creating temporary keypair: packer_659d5579-2a25-c7a2-6f02-dbec7d731087
==> amazon-ebs.ubuntu-us-east: Creating temporary security group for this instance: packer_659d557a-be33-9c4f-1a00-31777ac2f23c
==> amazon-ebs.ubuntu-us-east: Authorizing access to port 22 from [0.0.0.0/0] in the temporary security groups...
==> amazon-ebs.ubuntu-us-east: Launching a source AWS instance...
    amazon-ebs.ubuntu-us-east: Instance ID: i-022739d64eb0075ce
==> amazon-ebs.ubuntu-us-east: Waiting for instance (i-022739d64eb0075ce) to become ready...
==> amazon-ebs.ubuntu-us-east: Using SSH communicator to connect: 52.90.32.83
==> amazon-ebs.ubuntu-us-east: Waiting for SSH to become available...
==> amazon-ebs.ubuntu-us-east: Connected to SSH!
==> amazon-ebs.ubuntu-us-east: Provisioning with Ansible...
    amazon-ebs.ubuntu-us-east: Setting up proxy adapter for Ansible....
==> amazon-ebs.ubuntu-us-east: Executing Ansible: ansible-playbook -e packer_build_name="ubuntu-us-east" -e packer_builder_type=amazon-ebs --ssh-extra-args '-o IdentitiesOnly=yes' -e ansible_ssh_private_key_file=/var/folders/yn/2hjf3t295l51m1l7spyhqkvr0000gn/T/ansible-key2179621744 -i /var/folders/yn/2hjf3t295l51m1l7spyhqkvr0000gn/T/packer-provisioner-ansible3109275682 /Users/demo/src/git/github.com/ykhemani/packer-ubuntu-focal/playbook.yaml
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: PLAY [Provision image] *********************************************************
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Gathering Facts] *********************************************************
    amazon-ebs.ubuntu-us-east: ok: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Add HashiCorp GPG Key] ***************************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Add HashiCorp repo] ******************************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Install HashiCorp software] **********************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Install docker prerequisites] ********************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Add Docker GPG key] ******************************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Add Docker repo] *********************************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Install Docker] **********************************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Add Helm GPG Key] ********************************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Add Helm repo] ***********************************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Install Helm] ************************************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Install misc] ************************************************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: TASK [Update all packages to their latest version] *****************************
    amazon-ebs.ubuntu-us-east: changed: [default]
    amazon-ebs.ubuntu-us-east:
    amazon-ebs.ubuntu-us-east: PLAY RECAP *********************************************************************
    amazon-ebs.ubuntu-us-east: default                    : ok=13   changed=12   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
    amazon-ebs.ubuntu-us-east:
==> amazon-ebs.ubuntu-us-east: Provisioning with shell script: /var/folders/yn/2hjf3t295l51m1l7spyhqkvr0000gn/T/packer-shell2988963392
==> amazon-ebs.ubuntu-us-east:   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
==> amazon-ebs.ubuntu-us-east:                                  Dload  Upload   Total   Spent    Left  Speed
==> amazon-ebs.ubuntu-us-east: 100 47.4M  100 47.4M    0     0  94.6M      0 --:--:-- --:--:-- --:--:-- 94.4M
==> amazon-ebs.ubuntu-us-east:   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
==> amazon-ebs.ubuntu-us-east:                                  Dload  Upload   Total   Spent    Left  Speed
==> amazon-ebs.ubuntu-us-east: 100    97  100    97    0     0   3233      0 --:--:-- --:--:-- --:--:--  3233
==> amazon-ebs.ubuntu-us-east:   0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
==> amazon-ebs.ubuntu-us-east: 100 6304k  100 6304k    0     0  50.4M      0 --:--:-- --:--:-- --:--:-- 50.4M
==> amazon-ebs.ubuntu-us-east:   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
==> amazon-ebs.ubuntu-us-east:                                  Dload  Upload   Total   Spent    Left  Speed
==> amazon-ebs.ubuntu-us-east: 100    75  100    75    0     0    609      0 --:--:-- --:--:-- --:--:--   609
==> amazon-ebs.ubuntu-us-east: 100 63.5M  100 63.5M    0     0  83.2M      0 --:--:-- --:--:-- --:--:--  126M
    amazon-ebs.ubuntu-us-east: export PATH=$PATH:/usr/local/go/bin
==> amazon-ebs.ubuntu-us-east:   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
==> amazon-ebs.ubuntu-us-east:                                  Dload  Upload   Total   Spent    Left  Speed
==> amazon-ebs.ubuntu-us-east: 100 28.9M  100 28.9M    0     0  65.4M      0 --:--:-- --:--:-- --:--:-- 65.4M
    amazon-ebs.ubuntu-us-east: Selecting previously unselected package minikube.
    amazon-ebs.ubuntu-us-east: (Reading database ... 62488 files and directories currently installed.)
    amazon-ebs.ubuntu-us-east: Preparing to unpack .../src/minikube_latest_amd64.deb ...
    amazon-ebs.ubuntu-us-east: Unpacking minikube (1.32.0-0) ...
    amazon-ebs.ubuntu-us-east: Setting up minikube (1.32.0-0) ...
==> amazon-ebs.ubuntu-us-east:   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
==> amazon-ebs.ubuntu-us-east:                                  Dload  Upload   Total   Spent    Left  Speed
==> amazon-ebs.ubuntu-us-east:   0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
==> amazon-ebs.ubuntu-us-east: 100 17.7M  100 17.7M    0     0  73.5M      0 --:--:-- --:--:-- --:--:-- 73.5M
==> amazon-ebs.ubuntu-us-east: Stopping the source instance...
    amazon-ebs.ubuntu-us-east: Stopping instance
==> amazon-ebs.ubuntu-us-east: Waiting for the instance to stop...
==> amazon-ebs.ubuntu-us-east: Creating AMI ubuntu-focal-golden-image-1704809849 from instance i-022739d64eb0075ce
    amazon-ebs.ubuntu-us-east: AMI: ami-021773fff04989aeb
==> amazon-ebs.ubuntu-us-east: Waiting for AMI to become ready...
==> amazon-ebs.ubuntu-us-east: Skipping Enable AMI deprecation...
==> amazon-ebs.ubuntu-us-east: Adding tags to AMI (ami-01234567890abcdef)...
==> amazon-ebs.ubuntu-us-east: Tagging snapshot: snap-01234567890abcdef
==> amazon-ebs.ubuntu-us-east: Creating AMI tags
    amazon-ebs.ubuntu-us-east: Adding tag: "ttl": "-1"
    amazon-ebs.ubuntu-us-east: Adding tag: "Name": "Ubuntu Focal (20.04) Golden Image - yash 1704809849"
    amazon-ebs.ubuntu-us-east: Adding tag: "config-as-code": "packer"
    amazon-ebs.ubuntu-us-east: Adding tag: "owner": "yash"
    amazon-ebs.ubuntu-us-east: Adding tag: "repo": "ykhemani/packer-ubuntu-focal"
==> amazon-ebs.ubuntu-us-east: Creating snapshot tags
==> amazon-ebs.ubuntu-us-east: Terminating the source AWS instance...
==> amazon-ebs.ubuntu-us-east: Cleaning up any extra volumes...
==> amazon-ebs.ubuntu-us-east: No volumes to clean up, skipping
==> amazon-ebs.ubuntu-us-east: Deleting temporary security group...
==> amazon-ebs.ubuntu-us-east: Deleting temporary keypair...
Build 'amazon-ebs.ubuntu-us-east' finished after 9 minutes 56 seconds.

==> Wait completed after 9 minutes 57 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.ubuntu-us-east: AMIs were created:
us-east-1: ami-01234567890abcdef

--> amazon-ebs.ubuntu-us-east: Published metadata to HCP Packer registry packer/ubuntu-focal-golden-image/iterations/01HKQ9BRZ2CM949X5HFYGJ3SSE
```
</details>
