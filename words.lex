%{
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>

int N1,N2;
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
    	if (argc < 4)
        {
            puts("Use:\tflex-ej2 <archivo-entrada> <archivo-salida> <N1> <N2>\n");
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
        char *end;
        N1 = strtol(argv[2], &end, 10);
        if (argv[2] == end)
        {
            errno = EINVAL;
            perror("<N1> debe ser un entero");
            return(errno);
        }
        N2 = strtol(argv[3], &end, 10);
        if (argv[3] == end)
        {
            errno = EINVAL;
            perror("<N2> debe ser un entero");
            return(errno);
        }

    
    	yylex();
    	return(0);
}
