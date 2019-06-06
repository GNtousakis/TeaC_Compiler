%{
#include <stdlib.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include "teaclib.h"			
#include "cgen.h"

extern int yylex(void);
extern int line_num;
%}

%union
{
	char* crepr;
}

%token <crepr> IDENT
%token <crepr> REAL 
%token <crepr> STRING
%token <crepr> DIGIT
%token <crepr> POSINT 
%token <crepr> DECIMAL

%token      KW_INT
%token      KW_TRUE
%token      KW_FALSE
%token      KW_BOOL
%token      KW_STRING         
%token      KW_IF
%nonassoc   KW_THEN               
%nonassoc   KW_ELSE                   
%token      KW_FI
%token      KW_WHILE
%token      KW_LOOP
%token      KW_POOL
%token      KW_CONST
%token      KW_LET
%token      KW_RETURN
%right      KW_NOT
%left       KW_AND
%left       KW_OR
%token      KW_START
%token      KW_ARROW
%token      KW_REAL


%left 		KW_PLUS
%left 		KW_DASH
%left 		KW_STAR
%left 		KW_SLASH
%left  		KW_MOD
%left  		KW_ASSIGN

%left  		KW_EQUAL
%left  		KW_LESS
%left 	 	KW_LESS_EQUALS
%left  		KW_NOT_EQUALS

%left  	 	KW_SEMICOLON
%right  	KW_LEFT_BRACKET
%left   	KW_RIGHT_BRACKET
%left  		KW_LEFT_SQR_BRACKET
%left 		KW_RIGHT_SQR_BRACKET
%left  		KW_COMMA
%left  		KW_COLON

%start 		program

%type 		<crepr> expressions
%type 		<crepr> body
%type 		<crepr> begin_main
%type 		<crepr> functions
%type 		<crepr> variab
%type 		<crepr> main_actions
%type 		<crepr> commands
%type 		<crepr> name_of_variables
%type 		<crepr> possible_type
%type 		<crepr> name
%type 		<crepr> func_decl
%type 		<crepr> func_variables
%type 		<crepr> func_actions
%type 		<crepr> func_var_name
%type 		<crepr> control_commands
%type 		<crepr> ifstatement
%type 		<crepr> variab_decl
%type 		<crepr> returnCommand
%type 		<crepr> func_commands


%%

program: %empty
|body {printf("%s",$1);}
;

body: begin_main {$$ = template("%s",$1);}
|functions begin_main {$$ = template ("%s \n\n%s",$1,$2);}
|variab functions begin_main {$$=template("%s \n%s \n\n%s",$1,$2,$3);}
|variab begin_main {$$=template ("%s \n%s",$1,$2);}
;

variab: variab_decl {$$ =template ("%s",$1);}
| variab variab_decl {$$ = template ("%s %s", $1,$2);}
;

variab_decl: KW_CONST expressions KW_COLON possible_type KW_SEMICOLON {$$=template ("const %s=%s; \n",$4,$2);}
|KW_CONST IDENT KW_ASSIGN expressions KW_COLON  possible_type KW_SEMICOLON {$$=template ("const %s %s = %s; \n",$6,$2,$4);}	
|KW_CONST expressions KW_ASSIGN expressions KW_COLON  possible_type KW_SEMICOLON {$$=template ("const %s %s = %s; \n",$6,$2,$4);}
|KW_CONST name_of_variables KW_COLON possible_type KW_SEMICOLON {$$= template  ("const %s %s;\n",$4,$2);}
|KW_CONST control_commands KW_COMMA control_commands KW_COLON possible_type KW_SEMICOLON {$$=template ("const %s %s,%s;\n",$6,$2,$4);}
|KW_CONST commands KW_COLON possible_type KW_SEMICOLON {$$=template ("const %s;\n",$2);}
|KW_LET name_of_variables KW_COLON possible_type KW_SEMICOLON {$$=template ("%s=%s;\n",$4,$2);}
|KW_LET name_of_variables KW_ASSIGN expressions KW_COLON  possible_type KW_SEMICOLON {$$=template ("%s %s = %s;\n",$6,$2,$4);}
|KW_LET expressions KW_COLON possible_type KW_SEMICOLON {$$= template  ("%s %s;\n",$4,$2);}
|KW_LET control_commands KW_COMMA control_commands KW_COLON possible_type KW_SEMICOLON {$$=template ("%s %s,%s;\n",$6,$2,$4);}
|KW_LET commands KW_COLON possible_type KW_SEMICOLON {$$=template ("%s;\n",$2);}
|IDENT KW_ASSIGN expressions KW_SEMICOLON {$$= template ("%s = %s;\n",$1,$3);}
|IDENT expressions KW_SEMICOLON { $$ = template ("%s %s;\n",$1,$2);}
;

functions: func_decl {$$=template ("%s",$1);}
|functions func_decl {$$=template ("%s\n\n%s",$1,$2);}
;

func_decl: KW_CONST IDENT KW_ASSIGN KW_LEFT_BRACKET func_variables KW_RIGHT_BRACKET KW_COLON possible_type  KW_ARROW '{' func_actions '}'KW_SEMICOLON { $$ = template("%s %s (%s) {\n %s};",$8,$2,$5,$11);}
;

func_variables: func_var_name {$$= template ("%s",$1);}
|func_var_name KW_COMMA func_variables {$$=template  ("%s,%s",$1,$3);}
;

func_var_name: name_of_variables KW_COLON possible_type {$$=template("%s %s",$3,$1);}
| IDENT KW_LEFT_SQR_BRACKET KW_LEFT_SQR_BRACKET KW_COLON possible_type {$$=template ("%s* %s",$5,$1);}
;

func_actions: func_commands {$$ = template ("\t%s",$1);} 
|func_commands func_actions {$$ = template ("\t%s %s",$1,$2);}
;

func_commands: variab_decl {$$ = template ("%s",$1);}
|control_commands {$$ = template ("%s",$1);}
|returnCommand {$$ = template ("%s",$1);}
;

begin_main: KW_CONST KW_START KW_ASSIGN KW_LEFT_BRACKET KW_RIGHT_BRACKET KW_COLON KW_INT KW_ARROW '{' main_actions '}' {$$ = template("int main() {\n %s}\n",$10);}
;

main_actions: commands {$$ = template ("\t%s",$1);} 
|commands main_actions {$$ = template ("\t%s %s",$1,$2);}
|returnCommand {$$ = template ("\t%s",$1);}
;

commands: ';' { $$ = template(";\n");}
|control_commands {$$ = template ("%s",$1);}
|variab_decl {$$ = template ("%s",$1);}
;


expressions: IDENT  
| POSINT 
| STRING 
| REAL
| KW_FALSE {$$ = template ("false");}
| KW_TRUE {$$ = template ("true");}
| KW_NOT  {$$=template ("not ");}
| KW_DASH expressions {$$=template ("- %s",$2);}
| expressions KW_STAR expressions {$$=template ("%s * %s",$1,$3);}
| expressions KW_COMMA expressions {$$=template ("%s,%s",$1,$3);}
| expressions KW_SLASH expressions {$$=template  ("%s / %s",$1,$3);}
| expressions KW_MOD expressions {$$=template  ("%s % %s",$1,$3);}
| expressions KW_PLUS expressions {$$=template ("%s + %s",$1,$3);}
| expressions KW_DASH expressions {$$=template ("%s - %s",$1,$3);}
| expressions KW_EQUAL expressions {$$=template ("%s == %s",$1,$3);}
| expressions KW_LESS expressions {$$=template ("%s < %s",$1,$3);}
| expressions KW_LESS_EQUALS expressions {$$=template ("%s <= %s",$1,$3);}
| expressions KW_NOT_EQUALS expressions {$$=template ("%s != %s",$1,$3);}
| expressions KW_ASSIGN expressions {$$=template ("%s = %s",$1,$3);}
| expressions KW_AND expressions {$$=template ("%s and %s",$1,$3);}
| expressions KW_OR expressions {$$=template ("%s or %s",$1,$3);}
| KW_LEFT_BRACKET expressions KW_RIGHT_BRACKET { $$ = template("(%s)", $2); }
| expressions KW_LEFT_BRACKET expressions KW_RIGHT_BRACKET { $$ = template ("%s(%s)",$1,$3);}
| expressions KW_LEFT_BRACKET  KW_RIGHT_BRACKET { $$ = template ("%s( )",$1);}

;

control_commands: commands KW_ASSIGN commands {$$=template ("%s = %s",$1,$3);}
| ifstatement  {$$=template ("%s",$1);}
| KW_WHILE expressions KW_LOOP main_actions KW_POOL KW_SEMICOLON{$$= template ("while (%s) {\n%s\t}\n",$2,$4);}
;


ifstatement: KW_IF expressions KW_THEN main_actions KW_FI KW_SEMICOLON {$$=template("if (%s) \n\t{\n %s\t}\n",$2,$4);}
|KW_IF expressions KW_THEN main_actions KW_ELSE main_actions  {$$=template("if (%s) \n\t{\n %s\t}else \n %s",$2,$4,$6);}
|KW_IF expressions KW_THEN main_actions KW_ELSE control_commands KW_FI KW_SEMICOLON {$$=template("if (%s) \n\t{\n %s\n\t}else\n\t{\n %s\t}\n",$2,$4,$6);}
;

name_of_variables: name {$$=template("%s",$1);}
|name KW_COMMA name_of_variables {$$= template("%s, %s",$1,$3);}
;

name: IDENT { $$ = $1; } 
| IDENT KW_LEFT_SQR_BRACKET POSINT KW_LEFT_SQR_BRACKET {$$= template("%s[%s]",$1,$3);}
;

possible_type: KW_INT {$$=template("int");}
|KW_REAL {$$=template("double");}
|KW_BOOL {$$=template("int");}
|KW_STRING {$$=template("string");}
;

returnCommand: KW_RETURN expressions KW_SEMICOLON {$$ = template ("return %s;\n", $2);}
;

%%

int main () {
  if ( yyparse() == 0 )
    printf("Accepted!\n");
  else
    printf("Rejected!\n");
}




 

