#!/bin/bash

echo -n "Enter your name: "

read name

if [ -z "$name" ]; then
    echo "Hello, tmpuser?"
else
    echo "Hello, $name!"
fi