#!/bin/bash

usage() { 
    echo -e "\n  Usage: $0 [-h] " 1>&2; exit 1; 
    exit
}

echo -e "FMT: Formatando os arquivos para Canonical"
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
        *)
            ;;
    esac
done

echo -e "\nINIT: Atualizando os modulos do Terraform"
terraform init 
if [ $? -eq 0 ]; then
    echo -e "INIT: Atualizacao concluida com sucesso"
else
    echo -e "INIT: Atualizacao concluida com ERROS"
    exit
fi

echo -e "\nPLAN: Planejando a arvore de dependencia"
terraform plan -var-file terraform.tfvars   #| tee plan.log
if [ $? -eq 0 ]; then
    echo -e "PLAN: Planejamento finalizado com sucesso"
else
    echo -e "PLAN: Planejamento finalizado com ERROS"
    exit
fi

echo -e "\nAPPLY: Montando a DESTRUICAO (processo NAO automatico, aguarde)"
terraform destroy -var-file terraform.tfvars   #| tee apply.log
if [ $? -eq 0 ]; then
    echo -e "APPLY: Destruicao finalizada com sucesso"
else
    echo -e "APPLY: Destruicao finalizada com ERROS"
    exit
fi


echo -e "\nProcesso finalizado com sucesso"
