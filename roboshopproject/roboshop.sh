#!/bin/bash

ID=$(id -u)
if [ $ID -ne 0 ];then
  echo -e "\e [1;31m you should be toot uesr to execute this script....\e[om"
  exit
  fi
  if  [ -f components/$1.sh ];then
    bash components/$1.sh

    else
      echo -e "\e [1;31m invalid input\e[om"
      fi