/* scanner that identifies lexical components of a program written in pseudocode */

%{
/* insert libraries here*/
#include <stdlib.h>
%}
%option outfile="ejercicio6.c"

/*constants*/
RESERVED    (?-i:"inicio")|(?-i:"fin")|(?-i:"mod")

%%
{RESERVED}  {
                printf("I've found an reserved word: %s",yytext);
            }
%%

int main( int argc, char **argv )
{
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
    else
        yyin = stdin;
    yylex();
}
