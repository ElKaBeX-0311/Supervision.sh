#!/bin/sh
###
### Crée par ElKaBeX-0311.
### Date: 05/04/2022
###

shload_setup() {

  shload_percent=$1
  shload_symbol="$2"

  shload_width=100
  shload_delimiter=$shload_percent
  while [ $(($shload_width + 120)) -gt $(tput cols) ]; do
    shload_width=$(($shload_width / 2))
    shload_delimiter=$(($shload_delimiter * 2))
  done

  shload_count=$shload_width
  while [ $1 -lt $shload_count ]; do
    shload_delimiter=$(($shload_delimiter * 2))
    shload_symbol="$shload_symbol$shload_symbol"
    shload_count=$(($shload_count / 2))
  done


  shload_bar=""
  shload_completion_old=0

  printf "\033[1;4mProgression:\033[0m\033[s [\033[${shload_width}C] 0%%"

  shload_width=$(($shload_width + 1))
}


shload_update() {
  shload_count=$(($1 * 100))
  shload_completion=$(($shload_count / $shload_percent))

  if [ $shload_completion -ne $shload_completion_old ]; then
    if [ $shload_completion -lt 100 ]; then

      shload_bar=$(printf "%0.s${shload_symbol}" $(seq -s " " 1 $(($shload_count / $shload_delimiter))))
    else
      shload_completion=100
      shload_bar=$(printf "%0.s${shload_symbol}" $(seq -s " " 1 $(($((shload_percent * 100)) / shload_delimiter))))
    fi
    shload_completion_old=$shload_completion
  fi

  printf "\033[u [$shload_bar\033[u \033[${shload_width}C] $shload_completion%%"
}
