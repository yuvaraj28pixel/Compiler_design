lex lexer.l
yacc -d parser.y
gcc y.tab.c -ll -lm -w
./a.out sampleInput.txt
python3 commonSubElimination.py result_IC.txt
python3 constantFold.py result_of_cse.txt

echo "Check result_of_folding.txt file for the final optimized intermediate 3-address code :}"