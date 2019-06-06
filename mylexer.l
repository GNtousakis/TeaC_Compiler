%{
#include <assert.h>
#include <stdio.h>
#include "myanalyzer.tab.h"
#include "cgen.h"

int line_num = 1;


%}

IDENT [a-zA-Z_][0-9a-zA-Z_]*
DIGIT  [0-9]
NUMBER  {DIGIT}{DIGIT}*
DECIMAL ("."{NUMBER})|({NUMBER}("."{NUMBER}?)?)
REAL    {DECIMAL}([eE][+-]?{NUMBER})?
STRING  '[^'\n]*'|\"[^'\n]*\"


%x comment
%x macro
%x line_comment
%%


int						return KW_INT;
bool 					return KW_BOOL;
string 					return KW_STRING;
real               		return KW_REAL;

true 					return KW_TRUE;
false					return KW_FALSE;

if						return KW_IF;
then					return KW_THEN;
else					return KW_ELSE;
fi 						return KW_FI;

while					return KW_WHILE;
loop					return KW_LOOP;
pool					return KW_POOL;

const 					return KW_CONST;
let 					return KW_LET;

not 					return KW_NOT;
and 					return KW_AND;
or						return KW_OR;

return					return KW_RETURN;

start					return KW_START;



{IDENT}  	    		{ yylval.crepr = strdup(yytext); return IDENT; }
{NUMBER}				{ yylval.crepr = strdup(yytext); return POSINT; }
{REAL}					{ yylval.crepr = strdup(yytext); return REAL; }
{STRING}				{ yylval.crepr = strdup(yytext); return STRING; }


"+"						return KW_PLUS;
"-"						return KW_DASH;
"*"						return KW_STAR;
"/"						return KW_SLASH;
"%"						return KW_MOD;
"<-"                    return KW_ASSIGN;

"="						return KW_EQUAL;
"<"						return KW_LESS;
"<="					return KW_LESS_EQUALS;
"=>"					return KW_ARROW;
"!="		 			return KW_NOT_EQUALS;

";"						return KW_SEMICOLON;
"("						return KW_LEFT_BRACKET;
")"						return KW_RIGHT_BRACKET;
"["						return KW_LEFT_SQR_BRACKET;
"{"						return '{';
"}"						return '}';
"]"						return KW_RIGHT_SQR_BRACKET;
","						return KW_COMMA;
":"						return KW_COLON;

"--"[^\n]*  	/* eat line comments */

"(*"					BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*)\n]*   /* eat up '*'s not followed by ')'s */
<comment>\n             ++line_num;
<comment>"*"+")"        BEGIN(INITIAL);


[ \r\t]				/* skip whitespace */
\n 						++line_num;
<<EOF>> 			return EOF;

.             { yyerror("lexical error: unrecognized literal '%s'\n", yytext); }


%%
