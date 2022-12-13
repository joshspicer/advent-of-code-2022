#!/bin/bash

set -e

DAY="$1"

mkdir $DAY
cd $DAY
touch main.rb README.txt example.txt input.txt
chmod +x main.rb

tee main.rb > /dev/null \
<< EOF
#!/usr/bin/env ruby

# Input file
FILENAME='example.txt'  # example.txt
input_file = File.new(FILENAME, "r")
EOF