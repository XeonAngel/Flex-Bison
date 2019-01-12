#!/bin/bash
dos2unix in.txt
bison --warnings='none' -o Hm.tab.c -d Hm.y 
flex -o Hm.lex.c -l Hm.l
g++ -o Hm.out Hm.lex.c Hm.tab.c -lm -lfl

echo
echo "First Input"
echo
./Hm.out < in.txt

echo
echo "Second Input"
echo
./Hm.out < in2.txt
echo

./Clean.sh
