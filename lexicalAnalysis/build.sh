lex lexer.l
gcc lex.yy.c -lm -w
./a.out test1.txt