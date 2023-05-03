%{
    #include<string.h>
    #include<stdio.h>
    #include<math.h>
    int id_n=0;
    int key_n=0;
    int op= 0;

   FILE *fp;
%}

letter [a-zA-Z]
digit [0-9]
delimiter [, | ; | ( | ) | $]

%%

[ \t]		;
[ \n]   { yylineno = yylineno + 1;}

"..--."	    {key_n++;printf("%s - REAL\n", yytext);}
"..---"	    {key_n++;printf("%s - CHAR\n", yytext);}
".-..-" 	{key_n++;printf("%s - STRING\n", yytext);}
"---.."		{ key_n++;printf("%s - BOOL\n", yytext);}

"true"				    { key_n++;printf("%s - TRUE_\n", yytext);}
"false"				    {key_n++;printf("%s - FALSE_\n", yytext);}


".-.-." 	{key_n++;printf("%s - BREAK\n",yytext);}
".----" {key_n++;printf("%s - VOID\n", yytext);}
"..-.."	{key_n++;printf("%s - WHILE\n", yytext);}
"....-"	{key_n++;printf("%s - IF\n", yytext);}
"...--"   {key_n++;printf("%s - FOR\n", yytext);}
"...-."		{key_n++;printf("%s - ELSE\n", yytext);}
".--.."    {key_n++;printf("%s - DO\n", yytext);}

"AS"     {key_n++;printf("%s - ASGN\n", yytext);}
"MAIN" {key_n++;printf("%s - MAIN\n", yytext);}
"DECLARE" {key_n++; printf("%s - DECLARE\n", yytext);}
"SET" {key_n++;printf("%s - SET\n", yytext);}


"-..."   {op++;printf("%s - LE\n", yytext);}
".---"    {op++;printf("%s - GE\n",yytext);}
"...."    {op++;printf("%s - EQ\n", yytext);}
"--.."    {op++;printf("%s - NE\n", yytext);}
"-..-"	{op++;printf("%s - GT\n", yytext);}
"-.-."	{op++;printf("%s - LT\n", yytext);}
"---."	 	{op++;printf("%s - LOR\n", yytext);}
"----"  	{op++;printf("%s - LAND\n", yytext);}
"-.--"	    { op++;printf("%s - LNOT\n", yytext);}
"---." 	{op++;printf("%s - BOR\n", yytext);}
"--.-"	{op++;printf("%s - BAND\n", yytext);}


"---"			{op++;printf("%s - ADD\n", yytext);}
"--."			{op++; printf("%s - SUB\n", yytext);}
".-."			{op++; printf("%s - BXOR\n", yytext);}
"-.-"			{op++;printf("%s - MULTI\n", yytext);}
".--"			{op++;printf("%s - DIV\n", yytext);}
"-.." 			{ op++;printf("%s - MODULUS\n", yytext);}
"..."          {op++; printf("%s - POWER\n", yytext);}

{digit}+                        { 
                                    int i,var=0,j=0;
				                    for(i=yyleng-1;i>=0;i--)
				                    {	
				                        var = var +(*(yytext+j)-48)*pow(10,i);
				                        j++;	
				                    }
                                    printf("%s - NUM\n", yytext);
                                }
            
{letter}({letter}|{digit})*       { 
                                    printf("%s - ID\n", yytext);
                                }



[\']{letter}[\']		{printf("%s - CHAR_CONSTANT\n", yytext);}
[\"]{letter}*[\"]		{printf("CONSTANT\n");}
"//"(.)*[\n]			{printf("single-line comment\n");}
"/*"(.|\n)*"*/"			{printf("multiline comment\n");}

\/\/.* ;
\/\*(.*\n)*.*\*\/ ;
{delimiter}  {printf("%s - DELIMITER\n", yytext);}
(.)      printf("%s\n", "ERROR");
%%

int main(int argc, char *argv[]) 
  
{ 
    FILE *g;
    g=fopen(argv[1], "r");
    yyin=g;

    printf("\n\nLexical Analysis for --- %s :\n\n", argv[1]);
    yylex();
    
    printf("\nTotal no. of token = %d\n", key_n+op+id_n);   
       
} 

int yywrap(void)
{ 
    return 1;
}
