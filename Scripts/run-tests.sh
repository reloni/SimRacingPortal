#!/bin/bash

swift test

if [ $? -eq 0 ]
then
  printf "\e[32m SUCCESS \e[0m\n"
  exit 0
else
  printf "\e[1;31m FAIL \e[0m\n"
  exit 1
fi