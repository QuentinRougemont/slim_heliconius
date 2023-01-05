#!/bin/bash

rep=$1 
mig=$2 
assortF=$3
LAF=$4

echo -e "----------- running slim with following parameters---------------"

echo rep is $rep
echo migration rate is $mig
echo assortForce if $assortF
echo localAdaptForce is $LAF

echo -e "slim -d mu=1e-6 -d MigRate=${mig} -d AssortForce=${assortF}  -d LocalAdaptForce=${LAF} -d Rep=${rep} ./00_scripts/assortative_mating.slim.sh"
slim -d mu=1e-6 -d MigRate=${mig} -d AssortForce=${assortF}  -d LocalAdaptForce=${LAF} -d Rep=${rep} ./00_scripts/disassortative_mating.slim.sh

echo -e "finish"

exit
###################################################################
#for mig in 1e-4 1e-6 1e-8 ; do
#    for assortF in 0 0.25 0.5 ; do
#         LAF=$assortF
         slim -d mu=1e-6 -d MigRate=${mig} -d AssortForce=${assortF}  -d LocalAdaptForce=${LAF} -d Rep=${rep} ./00_scripts/disassortative_mating.slim.sh
#    done 
#done
