#!/bin/bash

sum() {
  total=0
  for arg in "$@"; do
    expr "$arg" + 0 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      echo "not int"
    fi
    total=$(expr "$total" + "$arg")
  done
  echo "$total"
}

read line1
read line2

read -ra arr1 <<< "$line1"
read -ra arr2 <<< "$line2"

sum1=$(sum "${arr1[@]}")
if [ "$sum1" = "not int" ]; then
  sum1=0
fi

sum2=$(sum "${arr2[@]}")
if [ "$sum2" = "not int" ]; then
  sum2=0
fi

if [ "$sum1" = "$sum2" ]; then
  echo "Equal"
else
  echo "Not equal"
fi
