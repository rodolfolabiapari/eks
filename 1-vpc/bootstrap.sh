#!/bin/bash
sudo yum update -y

# installing kubectl
echo -e "kubectl"
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
kubectl version --short --client
rm ./kubectl
echo -e "\ngit"
yum install git -y
git version


curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin
#echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$HOME/bin' >> ~/.zshrc
aws-iam-authenticator help

echo -e "\nterraform"
curl -O https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip
sudo unzip terraform_0.11.1_linux_amd64.zip -d $HOME/bin/
sudo rm *.zip
terraform -v

echo -e "clone the eks repository"
mkdir -p $HOME/git
git clone https://github.com/rodolfolabiapari/eks.git $HOME/git


echo -e "bootstrap done"
