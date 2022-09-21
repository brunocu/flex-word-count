%{
#include <stdio.h>

int word_count = 0;
int line_count = 0;
int char_count = 0;
%}
%option pointer
%option noyywrap

LETRA   [[:alpha:]]
%%
{LETRA}+    {
    word_count++;
    char *word = yytext;
    for(int i = 0; i < (yyleng-1); i++)
    {
        if (*word == *(word+1))
            printf("%s\n", yytext);

        word++;
    }
}
\n    ++char_count; ++line_count;  
.     ++char_count;


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
        printf("Caracteres: %d\n", char_count);
        printf("Palabras: %d\n", word_count);
        printf("Líneas: %d\n", line_count);
        
    	return(0);
}
