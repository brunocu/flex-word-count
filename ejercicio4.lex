%{

#pragma warning(disable: 4996 6011 6385)

//#include <malloc.h> 
#include <stdlib.h> 
#include <stdio.h>

unsigned int cantidad_palabras = 0;

%}

%option outfile="ejercicio4.c"
%option noyywrap

LETRA [A-Za-z]
VOCAL [aeiou]

%%

{LETRA}+   		cantidad_palabras++;

%%

int main(int argc, char * argv[])
{
    	++argv;
    	--argc;  
    	if (argc > 0)
            yyin = fopen( argv[0], "r" );
    	else
            yyin = stdin;
    
    	yylex();
    	printf("Palabras totales en el archivo: %d \n",cantidad_palabras);
    	return(0);
}



