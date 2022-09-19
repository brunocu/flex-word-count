%{
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>

const int N1 = 5;
const int N2 = 4;
%}
%option pointer
%option noyywrap

DIGITO [0-9]
%%
[^\n]{DIGITO}+/[[:blank:]\n]   {
    char *end;
    int num = strtol(yytext, &end, 10);
    if (yytext == end)
        REJECT;
    
    if ( (num % N2) == 0)
        fprintf(yyout, " %d", (num + N1));
    else
        ECHO;
}

%%
int main(int argc, char * argv[])
{
    	++argv;
    	--argc;  
    	if (argc < 2)
        {
            puts("Use:\tflex-ej1 <archivo-entrada> <archivo-salida>\n");
            return(EINVAL);
        }

        // parse arguments
        yyin = fopen( argv[0], "r" );
        if (yyin == NULL)
        {
            errno = EIO;
            return(errno);
        }
        yyout = fopen( argv[1], "w" );
        if (yyout == NULL)
        {
            errno = EIO;
            return(errno);
        }

    
    	yylex();
    	return(0);
}
