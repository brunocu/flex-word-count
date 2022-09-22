%{
#include "word_list.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <regex.h>

#define MAX_FILE_DEPTH 2

int num_fields = 0;
list_list artist_list;
list_list genre_list;
word_list *curr_artist;
word_list *curr_genre;

YY_BUFFER_STATE file_stack[MAX_FILE_DEPTH];
int file_stack_ptr = 0;

// C regex
int reg_ret;

const char PAT_VOWEL[] = "[aeiou]+";
regex_t *re_vowel = NULL;

const char PAT_Y[] = "([^y].*y.*)|(^y$)";
regex_t *re_y = NULL;
%}
%option array
%option noyywrap
%option caseless

%x SONG

LETRA   [[:alpha:]]
%%
 /* index rules */
[^,\r\n]+       {
    // FIELD
    switch(num_fields) {
        case 0:  // nombre
            curr_artist = lazy_get_word_list(&artist_list, yytext);
            break;
        case 1:  // genero
            curr_genre = lazy_get_word_list(&genre_list, yytext);
            break;
        case 2: // titulo
            // iunno
            break;
        case 3: // archivo
            if (file_stack_ptr >= MAX_FILE_DEPTH)
                exit(1);

            file_stack[file_stack_ptr++] = YY_CURRENT_BUFFER;
            yyin = fopen( yytext , "r" );
            if(!yyin)
                exit(1);
            yy_switch_to_buffer(yy_create_buffer( yyin, YY_BUF_SIZE ) );
            BEGIN(SONG);
            break;
        default:
            puts("too many fields");
            break;
    }
}
,               ++num_fields;
\r\n|\n\r|\r|\n num_fields=0;

 /* song rules */
<SONG>{LETRA}+    {
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
    add_word(curr_artist, yytext);
    add_word(curr_genre, yytext);
}
<SONG>.|\n    /* ignore all others */
<<EOF>> {
		if ( --file_stack_ptr < 0 )
		    yyterminate();
		else
		{
			yy_delete_buffer( YY_CURRENT_BUFFER );
			yy_switch_to_buffer( file_stack[file_stack_ptr] );
            BEGIN(INITIAL);
		}
	}

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

        // stuff
        init_list(&artist_list);
        init_list(&genre_list);

        yylex();
        // TODO TEST PRINT, CHANGE TO OUTPUT FILE
        printf("---ARTISTS---\n");
        print_list_list(&artist_list);
        printf("---GENRES---\n");
        print_list_list(&genre_list);

        // TODO FREE LIST MEMORY
        // free regex compile
        regfree(re_vowel);
        regfree(re_y);
        // free allocations
        free(re_vowel);
        free(re_y);
    	return(0);
}
