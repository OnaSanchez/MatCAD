#!/bin/bash

################################################################################

  # Shell Script to count the number of random values that P(|X| > |x| ) ≤ p
  # @Version: 1.0
  #
  # @Authors:
  #           --> Ona Sánchez -- 1601181
  #           --> Gerard Lahuerta -- 1601350
  #
  # @Copyright (c) 2022 All Right Reserved
  #
  # Information about the program in:

################################################################################

# Declaration of the variables
mu=0
sigma=1
inter=300
n=10
seed=0
contador=0
opt=1

# Input management
if [ $# \< 1 ]; then
  echo "Argument of the probability p is missing"
  exit -1
fi
if [ $1 \< 0 -o $1 \> 1 ]; then
  echo " Argument of the probability has to be between 0 and 1"
  exit -1
fi
if [ $# \> 2 ]; then
  mu=$2
  echo "Mu value has been introduced correctly"
  echo "Sigma value has been introduced correctly"
fi
if [ $# \> 3 ]; then
  n=$4
  echo "The number samples has been introduced correctly"
  opt=2
fi
if [ $# \> 4 ]; then
  seed=$5
  echo "The seed has been introduced correctly"
  opt=3
fi
if [ $# \> 5 ]; then
  if [ $6 \> "0" ]; then
    inter=$6
    echo "The number of intervals has been introduced correctly"
  fi
fi

# Execution of the sub-program and creation of the file with the random sample
case $opt in
  1 )
    ./generador $mu $sigma > random_sample.txt
    ;;
  2 )
    ./generador $mu $sigma $n > random_sample.txt
    ;;
  3 )
    ./generador $mu $sigma $n $seed> random_sample.txt
    ;;
esac

# Creation of the auxiliar text file x.txt
cut -d ' ' -f 3 random_sample.txt > x.txt
for (( c = 0; c < $opt; c++ )); do
  sed -i "1d" random_sample.txt
  sed -i "1d" x.txt
done

# Creation of the auxiliar text file p.txt
while IFS= read -r line
do
  ./gauss $mu $sigma $line $inter >> p.txt
done < x.txt

# Counting of the samples
while IFS= read -r line
do
  if [ $line \< $1 -o $line \= $1 ]; then
    let contador=$contador+1
  fi
done < p.txt

# Output messatge
echo "The number of samples x with probability P(|X| > |x| ) ≤ p is $contador"

# Elimination of the auxiliar text files
rm x.txt
rm p.txt
