%{
#include <stdio.h>

int palabras = 0;
%}
%option pointer
%option noyywrap

LETRA   [[:alpha:]]
%%
{LETRA}+    {
    palabras++;
    char *word = yytext;
    for(int i = 0; i < (yyleng-1); i++)
    {
        if (*word == *(word+1))
            printf("%s\n", yytext);

        word++;
    }
}
.|\n    

%%
int main(int argc, char * argv[])
{
    	++argv;
    	--argc;  
    	if (argc > 0)
            yyin = fopen( argv[0], "r" );
    	else
            return(1);
    
    	yylex();
        printf("palabras: %d", palabras);
    	return(0);
}
