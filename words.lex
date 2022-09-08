%{
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <regex.h>

int palabras = 0;
regex_t *reg_vowel = NULL;
%}
%option pointer
%option noyywrap

LETRA   [[:alpha:]]
%%
{LETRA}+    {
    palabras++;
    char *word = yytext;
    bool has_vowel = false;
    // there are no words without vowels
    for(int i = 0; i < (yyleng); i++)
    {
        // null terminated string
        char letter[2] = {*word, '\0'};
        if (regexec(reg_vowel, letter, 0, NULL, 0) == 0)
            has_vowel = true;
        word++;
    }
    // TODO PHONETIC Y (i)
    if (!has_vowel)
        printf("%s\n", yytext);
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

        // Compile regex expr
        //  exit on failed compilation
        reg_vowel = malloc(sizeof(regex_t));
        if (reg_vowel)
        {
            int reg_ret = regcomp(reg_vowel, "[aeiou]", REG_ICASE|REG_NOSUB);
            if (reg_ret != 0)
                return(1);
        }
        else
            return(1);
    
    	yylex();
        printf("palabras: %d", palabras);
    	return(0);
}
