packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    # azure = {
    #   source  = "github.com/hashicorp/azure"
    #   version = "~> 1"
    # }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

build {
  hcp_packer_registry {
    bucket_name = var.bucket_name
    description = var.bucket_description

    bucket_labels = {
      "os" = "linux"
    }

    build_labels = {
      "build-time" = timestamp()
    }
  }

  sources = [
    "source.amazon-ebs.ubuntu-us-east",
    #"source.amazon-ebs.ubuntu-us-west",
    #"source.azure-arm.ubuntu-azure-us-east"
  ]

  provisioner "ansible" {
    playbook_file = "./playbook.yaml"
  }

  provisioner "shell" {
    inline = [
      "sudo curl -L \"https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl\" -o /usr/local/bin/kubectl",
      "sudo chmod +x /usr/local/bin/kubectl",
      "sudo curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64",
      "sudo chmod +x /usr/local/bin/kind",
      "sudo curl -Lo /tmp/go1.21.3.linux-amd64.tar.gz https://go.dev/dl/go1.21.3.linux-amd64.tar.gz",
      "sudo tar -C /usr/local -xzf /tmp/go1.21.3.linux-amd64.tar.gz",
      "export PATH=$PATH:/usr/local/go/bin",
      "echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/go.sh",
      "sudo mkdir -p /data/src",
      "sudo curl -Lo /data/src/minikube_latest_amd64.deb https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb",
      "sudo dpkg -i /data/src/minikube_latest_amd64.deb",
      "sudo curl -Lo /data/src/k9s_Linux_amd64.tar.gz https://github.com/derailed/k9s/releases/download/v0.27.4/k9s_Linux_amd64.tar.gz",
      "sudo mkdir -p /data/src/k9s",
      "sudo tar -C /data/src/k9s -xzf /data/src/k9s_Linux_amd64.tar.gz",
      "sudo chmod +x /data/src/k9s/k9s",
      "sudo mv /data/src/k9s/k9s /usr/local/bin/k9s",
      "sudo curl -sL \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "sudo curl -Lo /data/src/nodesetup https://deb.nodesource.com/setup_20.x",
      "sudo bash /data/src/nodesetup",
      "sudo apt-get install -y nodejs",
      "sudo apt install mongodb-clients -y",
      "sudo npm install express",
      "sudo npm install mongodb",
      "sudo npm install @faker-js/faker",
      "sudo docker pull hashicorp/vault-enterprise:1.15.4-ent",
      "sudo docker pull mysql:5.7",
      "sudo docker pull mongo:7.0.5",
      "sudo docker pull bitnami/openldap:2.6.6"
    ]
  }
}
