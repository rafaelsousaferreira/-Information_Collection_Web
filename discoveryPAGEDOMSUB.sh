#!/bin/bash

# Esse script em Bash varre páginas HTML para identificar domínios e subdomínios que estão linkados.

# Variáveis
DIR=$(pwd)
PAGE="index.html"
SUB="sub_dom_list.txt"

# Função de banner
function banner {
  echo -e ""
  echo -e "	 ╰╮╰╮╰╮"
  echo    "	╭━━━━━━━╮╱"
  echo    "	╰━━━━━━━╯╱"
  echo    "	┃╭╭╮┏┏┏┏┣━╮"
  echo    "	┃┃┃┃┣┣┣┣┃╱┃"
  echo    "	┃╰╰╯┃┃┗┗┣━╯"
  echo    "	╰━━━━━━━╯"
  echo -e ""
}

# Função para apagar arquivos antigos e reiniciar o teste
function reset_test {
  rm -f "$DIR/$PAGE" "$DIR/$SUB"
  wget -q "$1"

  grep --text href= "$PAGE" | cut -d "/" -f3 | cut -d '"' -f1 | cut -d "'" -f1 | grep '\.' \
  | egrep -v '"|#|\||%|<|>|=|_|\?|.css' | sort -u > "$SUB"

  echo -e "\nDomínios e subdomínios encontrados na página ($1):\n"
  cat "$SUB"
}

# Função para verificar se existem resultados antigos
function check_previous_results {
  echo -e "######################################"
  echo -e "Existe um Resultado de Teste Anterior:"
  echo -e "$DIR/$PAGE"
  echo -e "$DIR/$SUB"
  echo -e "--------------------------------------"
  echo -e "Digite 1 para APAGAR e RETOMAR o TESTE"
  echo -e "Digite 2 para SAIR"
  echo -e ""
  read -r op
  clear

  case $op in
    1) 
      banner
      reset_test "$1"
      ;;
    2)
      exit
      ;;
    *)
      echo "Opção inválida!"
      exit 1
      ;;
  esac
}

# Script principal
if [ -z "$1" ]; then
  echo "Exemplo: $0 dominio"
  exit 1
fi

banner

if [ -e "$DIR/$PAGE" ]; then
  check_previous_results "$1"
else
  wget -q "$1"
  
  grep --text href= "$PAGE" | cut -d "/" -f3 | cut -d '"' -f1 | cut -d "'" -f1 | grep '\.' \
  | egrep -v '"|#|\||%|<|>|=|_|\?|.css' | sort -u > "$SUB"

  echo -e "\nDomínios e subdomínios encontrados na página ($1):\n"
  cat "$SUB"
fi
