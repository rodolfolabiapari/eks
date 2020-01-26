# AWS Credentials

aws-vault exec --assume-role-ttl=1h linuxplaceqas

# Provisionando o VPC

Entre no diretório do git (eu sempre tenho uma pasta git)

``` bash
cd ~/git/eks/
```

Entre no diretório VPC, e construa a rede e bastion para o EKS.

``` bash
cd 1-vpc
./build.sh
cd ..
```


# Provisionando o EKS

Após provisionado a rede, provisione o EKS.

``` bash
cd 2-eks
./build.sh 
cd ..
```

# Configurando permissões para acesso a API Kubernetes

## AWS-iam-authenticator

Referência: https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

``` bash
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator

chmod +x ./aws-iam-authenticator

mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin

#echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
echo 'export PATH=$PATH:$HOME/bin' >> ~/.zshrc

aws-iam-authenticator help
```

## AWS Cli

Tem que testar

### Versão 2

``` bash
curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip

./aws/install --install-dir $HOME/bin/

aws2 --version
```


### Vesão 1

#### Sem ambiente virtual

``` bash
pip3 install awscli --upgrade --user

aws --version
```

#### Com Ambiente Virtual

```
pip install --user virtualenv
virtualenv ~/cli-ve
source ~/cli-ve/bin/activate
pip install --upgrade awscli
aws --version
```


aws eks update-kubeconfig --name rodolfosk8s

kubectl config view

kubectl cluster-info


# Dashboard 
Ref: https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

``` bash
wget -O v0.3.6.tar.gz https://codeload.github.com/kubernetes-sigs/metrics-server/tar.gz/v0.3.6
tar -xzf v0.3.6.tar.gz
kubectl apply -f metrics-server-0.3.6/deploy/1.8+/
kubectl get deployment metrics-server -n kube-system

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml

# get de token
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

kubectl proxy

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login
```

apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-admin
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: eks-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: eks-admin
  namespace: kube-system


# Adicionando permissão de workers integrarem ao cluster

Vá até a a página do nodegroup do eks, copie a role do nodegroup

cole em .data.mapRoles.rolearn como a seguir:

``` text
data:
  mapAccounts: |
    []
  mapRoles: |+
    - rolearn: arn:aws:iam::831336094762:role/rodolfosk8s20200122190721243100000001
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
    - rolearn: arn:aws:eks:us-east-1:831336094762:nodegroup/rodolfosk8s/rodolfosk8s-example-ace-porpoise/3eb7e753-847e-99e8-845c-7d2563f0fd9d
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
```

```
kubectl -n kube-system edit cm aws-auth
```

# Add-ons

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

kubectl apply -f sa.yaml crb.yaml

aws-iam-authenticator -i rodolfosk8s token

kubectl proxy --address 0.0.0.0 --accept-hosts '.*' &

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
```


```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml
```