%{
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <regex.h>

int palabras = 0;

// C regex
int reg_ret;

const char PAT_VOWEL[] = "[aeiou]+";
regex_t *re_vowel = NULL;

const char PAT_Y[] = "[^y].*y.*";
regex_t *re_y = NULL;
%}
%option array
%option noyywrap

LETRA   [[:alpha:]]
%%
{LETRA}+    {
    // no word repeats a letter more than 2 times
    char *word = yytext;
    for(int i = 0; i < (yyleng - 2); i++)
    {
        if (word[0] == word[1] && word[1] == word[2])
            REJECT;
        word++;
    }
    bool has_vowel = false;
    // All words have at least 1 vowel
    reg_ret = regexec(re_vowel, yytext, 0, NULL, 0);    // /[aeiou]+/i
    if (reg_ret != 0)
    {
        // edge case: y
        reg_ret = regexec(re_y, yytext, 0, NULL, 0);    // /[^y].*y.*/i
        if (reg_ret != 0)
            REJECT; // all hope is truly lost
    }
    // yytext is (hopefully) a word :)
    palabras++;
}
.|\n    /* ignore all others */

%%
int main(int argc, char * argv[])
{
    	++argv;
    	--argc;  
    	if (argc > 0)
            yyin = fopen( argv[0], "r" );
    	else
            return(1);

        // Compile regex exprs
        //  exit on failed compilation
        re_vowel = (regex_t *) malloc(sizeof(regex_t));
        if (!re_vowel)
            return(1);
        
        reg_ret = regcomp(re_vowel, PAT_VOWEL, REG_EXTENDED|REG_ICASE|REG_NOSUB);
        if (reg_ret != 0)
            return(1);

        re_y = (regex_t *) malloc(sizeof(regex_t));
        if (!re_vowel)
            return(1);
        
        reg_ret = regcomp(re_y, PAT_Y, REG_EXTENDED|REG_ICASE|REG_NOSUB);
        if (reg_ret != 0)
            return(1);

        yylex();
        printf("palabras: %d\n", palabras);
        
        // free regex compile
        regfree(re_vowel);
        regfree(re_y);
        // free allocations
        free(re_vowel);
        free(re_y);
    	return(0);
}
