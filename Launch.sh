#!/bin/bash
dos2unix in.txt
bison -o Hm.tab.c -d Hm.y
flex -o Hm.lex.c -l Hm.l
g++ -o Hm.out Hm.lex.c Hm.tab.c -lm -lfl

./Hm.out < in.txt

./Clean.sh
