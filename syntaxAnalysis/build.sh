lex lexer.l
yacc -d parser.y
gcc y.tab.c -ll -lm -w
./a.out test1.txt
#./a.out test2.txt