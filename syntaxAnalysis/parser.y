%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define YYSTYPE char *
extern char* yytext;

extern FILE *inFile;
FILE * outFile;

%}

%token REAL CHAR STRING BOOL VOID
%token WHILE FOR DO
%token IF ELSE BREAK 
%token NUM ID
%token MAIN DECLARE SET
%token ADD SUB MULTI DIV POWER TRUE_ FALSE_ MODULUS CHAR_CONSTANT CONSTANT


%right ASGN
%left LOR
%left LAND
%left BOR
%left BXOR
%left BAND
%left LNOT
%left EQ NE 
%left LE GE LT GT
%left ADD SUB 
%left MULTI DIV MODULUS
%right POWER
%right UMINUS

%%

start_program		: declare_statement  MAIN  statement_start  {printf("start_program\n");}
				;

statement_start 		: '$' statement_body '$'        {printf("statement_start\n");}
                |
				;

statement_body			: statement  statement_body     {printf("statement_body\n");}
				|
				;

statement 			: declare_statement         {printf("statement\n");}
				| assign_statement  
				| if_statement
				| while_statement
				| for_statement
				| do_statement
				| ';'
				;

for_statement		:  FOR '(' assign_statement_2 ';'  expression ';'  assign_statement_2 ')' whilebody   {printf("for_statement\n");}
				;

do_statement         : DO  do_while_body  WHILE '(' expression  ')' ';'         {printf("do_while_statement\n");}
                ;

if_statement 		: IF '(' expression ')'  statement_start else_statement         {printf("ifelse_statement\n");}
				;
else_statement		: ELSE  statement_start 
				| 	
				;

while_statement		: WHILE '(' expression ')'  whilebody           {printf("while_statement\n");}
				;

do_while_body    : statement_start      {printf("doWhile_body\n");}
                |statement 
                 ;

whilebody		: statement_start           {printf("whilebody\n");}
				| statement 
				
				;

declare_statement 	: DECLARE TYPE   ID  ids        {printf("declare_statement\n"); countVars();}
                    |
                ;

ids 			: ';'           
				| ','  ID {countVars();} ids 
				;

assign_statement		: SET ID ASGN	expression	 ';'        {printf("assignment_statement\n");}
            
                ;

assign_statement_2      : SET ID	ASGN	expression	{printf("assignment_statement_2\n");}
                ;

expression 			: expression ADD	  expression        {printf("arithmetic_ADD\n");}
				| expression SUB   expression               {printf("arithmetic_SUB\n");}
				| expression MULTI   expression             {printf("arithmetic_MULTI\n");}
				| expression DIV  expression                {printf("arithmetic_DIVISION\n");}
				| expression MODULUS  expression            {printf("arithmetic_MODULUS\n");}
				| expression POWER   expression             {printf("POWER\n");}
                | expression  LT   expression               {printf("relop_LT\n");}
				| expression  LE   expression               {printf("relop_LE\n");}
				| expression  GT   expression               {printf("relop_GT\n");}
				| expression  GE   expression               {printf("relop_GE\n");}
				| expression  NE   expression               {printf("relop_NE\n");}
				| expression  EQ   expression               {printf("relop_EQ\n");}
                | expression   LOR  expression              {printf("logical_OR\n");}
				| expression   LAND expression              {printf("logical_AND\n");}
				| expression   BOR  expression              {printf("logical_BITWISE_OR\n");}
				| expression   BXOR expression              {printf("logical_BITWISE_XOR\n");}
				| expression   BAND expression              {printf("logical_BITWISE_AND\n");}
				| '-' expression %prec UMINUS               {printf("Unary_MINUS\n");}
				| LNOT expression                           {printf("logical_NOT\n");}
				| '(' expression ')'                        {printf("(expr)\n");}
				| expression '+' '(' '-'  expression ')'    
				| ID  {$$=$1;  }                            {printf("Identifier\n");}
				| NUM {$$=$1; }                             {printf("Number\n");}
				;


				
TYPE			: REAL  {printf("dataType_REAL\n");}
				|CHAR   {printf("dataType_CHAR\n");}
				|STRING     {printf("dataType_STRING\n");}
				|BOOL          {printf("dataType_BOOL");}
				;


%%


#include"lex.yy.c"

int varCount = 0;

int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	outFile=fopen("result.txt","w");
	
    printf("\n\n\nParsing levels:----------------- %s :\n\n\n", argv[1]);
   if(!yyparse())
		printf("\nParsing successful:)---------------------------------\n");
	else
	{
		printf("\nParsing unsuccessful:(\n");
		exit(0);
	}

    printf("Number of variables declarations = %d\n", varCount);
    printf("Number of lines = %d\n", yylineno);
	
	fclose(yyin);
	fclose(outFile);
	
    return 0;
}
         
yyerror(char *s) {
	printf("Syntex Error in line number : %d : %s %s\n", yylineno, s, yytext );
}

void countVars(){
    varCount++;
}