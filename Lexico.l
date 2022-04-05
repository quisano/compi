%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdbool.h>
	#include <string.h>
	#include <float.h>
    #include "y.tab.h"
	FILE  *yyin;
	int yylex();
	void yyerror(const char *s);
%}

%option noyywrap
%option yylineno

DIGITO_CON_CERO			[0-9]
DIGITO_SIN_CERO			[1-9]
LETRA					[a-zA-Z]
ID						{LETRA}({LETRA}|{DIGITO_CON_CERO}|_)*
CTE_INT					"-"{DIGITO_SIN_CERO}+|{DIGITO_CON_CERO}+
CTE_FLOAT				"-"{DIGITO_CON_CERO}+"."{DIGITO_CON_CERO}*|{DIGITO_CON_CERO}*"."{DIGITO_CON_CERO}+|{DIGITO_CON_CERO}+"."{DIGITO_CON_CERO}*
TEXTO         			"\""({CARACTER}|{ESPACIO})*"\""
CARACTER        		[a-z,A-Z,0-9,=,>,<,!,:,+,-,*,/,@]
ESPACIO         		[" "]
A_COMENTARIO			"-/"
C_COMENTARIO			"/-"
COMENTARIOS     		{A_COMENTARIO}({LETRA}|{DIGITO_CON_CERO}|.)+{C_COMENTARIO}
TEXTO_INVALIDO  		[^{CARACTER} 	\n]
%%

if|IF					{ return IF; }
else|ELSE				{ return ELSE; }
endif|ENDIF				{ return ENDIF; }
while|WHILE				{ return WHILE; }
do|DO					{ return DO; }
endwhile|ENDWHILE		{ return ENDWHILE; }
inlist|INLIST			{ return INLIST; }
avg|AVG					{ return AVG; }

int|INT					{ return INT; }
float|FLOAT				{ return FLOAT; }
string|STRING			{ return STRING; }





"+"						{ return OP_SUM; }
"-"						{ return OP_RES; }
"/"						{ return OP_DIV; }
"*"						{ return OP_MUL; }
"%"						{ return OP_MOD; }
":="					{ return OP_ASIG; }
"="						{ return OP_IGUAL; }
":"						{ return OP_DOSP; }
","						{ return CAR_COMA; }
";"						{ return CAR_PYC; }
"("						{ return CAR_PA; }
")"						{ return CAR_PC; }
"["						{ return CAR_CA; }
"]"						{ return CAR_CC; }
"{"						{ return CAR_LA; }
"}"						{ return CAR_LC; }
">"						{ return CMP_MAYOR; }
"<"						{ return CMP_MENOR; }
">="					{ return CMP_MAYORIGUAL; }
"<="					{ return CMP_MENORIGUAL; }
"!="					{ return CMP_DISTINTO; }
"=="					{ return CMP_IGUAL; }
"&&"					{ return AND; }
"||"					{ return OR; }
"!"						{ return NOT; }

{ID}			{ 
					//yylval.string_val = yytext;
					return ID;
				}
				
{CTE_INT}		{
					//yylval.int_val = atoi(yytext);
					return CTE_INT;
				}
				
{CTE_FLOAT}		{
					//yylval.float_val = atof(yytext);
					return CTE_FLOAT;
				}
				
{TEXTO}			{ 
					//yylval.string_val = yytext;
					return CTE_STRING;
				}

{COMENTARIOS}

{TEXTO_INVALIDO}	{ 
						char errorMsg[100]; 
						sprintf(errorMsg, "Syntax Error, Caracter invalido: %s \n",yytext);
						fprintf(stderr, "Syntax Error, Caracter invalido: %s \n",yytext);
						yyerror(errorMsg);
					}


"\n"      		
"\t"		
%%
	
void yyerror(const char *msg) {
	fprintf(stderr, "\n\n ***** ERROR :: %s ***** \n\n ",msg);
	system("Pause");
	exit(1);
}