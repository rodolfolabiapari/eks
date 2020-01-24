#!/bin/bash

usage() { 
    echo -e "\n  Usage: $0 [-h] [-p <./>]" 1>&2; exit 1; 
    exit
}

path="./"

echo -e "FMT: Formatando os arquivos para adequacao ao Canonical"
terraform fmt -diff -recursive
if [ $? -eq 0 ]; then
    echo -e "FMT: Formatação concluida com sucesso"
else
    echo -e "FMT: Formatação concluida com ERROS"
    exit
fi


while getopts "hp:" option; do
    case "${option}" in
        h) 
            usage
            ;;
        p) 
            path=$OPTARG
            ;;
        *)
            ;;
    esac
done

echo -e "\nUtilizando o path ${path}"

echo -e "\nINIT: Inicializando os modulos do Terraform"
terraform init ${path}
if [ $? -eq 0 ]; then
    echo -e "INIT: Inicializacao concluida com sucesso"
else
    echo -e "INIT: Inicializacao concluida com ERROS"
    exit
fi


echo -e "\nPLAN: Planejando o provisionamento (para ver os .logs, execute 'less -E arquivo.log')"
terraform plan -var-file ${path}/terraform.tfvars ${path} #| tee plan.log
if [ $? -eq 0 ]; then
    echo -e "PLAN: Planejamento finalizado com sucesso"
else
    echo -e "PLAN: Planejamento finalizado com ERROS"
    exit
fi


echo -e "\nAPPLY: Iniciando o PROVISIONAMENTO definitivo"
terraform apply -var-file ${path}/terraform.tfvars ${path} #| tee apply.log
if [ $? -eq 0 ]; then
    echo -e "APPLY: Provisionamento finalizado com sucesso"
else
    echo -e "APPLY: ProvisionamentoVou finalizado com ERROS"
    exit
fi


echo -e "\nProcesso finalizado com sucesso"