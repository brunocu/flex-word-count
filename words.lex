%{
// C declarations
%}
%option pointer
%option noyywrap


%%
/* rules */

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
    	return(0);
}
