%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

FILE  *yyin;
int yylval;
char *yyltext;

int yyerror(void);

int eval_int( char* a ){
	int b = atoi(a);
	if( b  < -32768 || b > 32767 ){
		printf( "\nERROR LEXICO : Rango entero Invalido (16 bits): %s\n", yytext ); exit (0);}
	return 0;
}
/*int eval_float( char* a ){
	char *ptr;
	long b;
	strtoul(a,&ptr,b);
	if( b  < -2147483648 || b > 2147483647 ){
		printf( "\nERROR LEXICO : Rango reales Invalido (32 bits): %s\n", yytext ); exit (0);} 
	return 0;
}*/

int eval_string( char* a ){
	unsigned long b = sizeof(a);
	if( b  < 0 || b > 1073741824 ){
		printf( "\nERROR LEXICO : Longitud String Invalido ( 30 caracteres ): %s\n", yytext ); exit (0);}
	return 0;
}

%}

%option noyywrap  
%option yylineno 

CORA			"["
CORC			"]"

DIGITO			[0-9]
LETRA			[aA-zZ]
SIMBOLO			[:>!]
A_COMENTARIO	"-/"
C_COMENTARIO	"/-"

CTE_E	        {DIGITO}+
CTE_R			{DIGITO}*"."{DIGITO}*
ID				{LETRA}({LETRA}|{DIGITO}|_)*
CTE_S 			"\""({LETRA}|{DIGITO}|{SIMBOLO}|.)+"\""
COMENTARIO		{A_COMENTARIO}({LETRA}|{DIGITO}|.)+{C_COMENTARIO}
DP				":"
PC				";"
OP_ASIG   		":""="
OP_SUM		    "+"
OP_MUL          "*"
OP_RES		    "-"
OP_DIV          "/"
COMA			","
LA              "{"
LC				"}"
PARA			"("
PARC			")"
PUNTO			"."
AND 			"&&"
OR				"||"
CO_IGUAL		"=="
CO_DIST			"!="
CO_MENI			"<="
CO_MEN			"<"
CO_MAYI			">="
CO_MAY			">"
DECVAR			"DECVAR"
ENDDEC			"ENDDEC"
INT				"INT"
FLOAT			"FLOAT"
STRING			"STRING"
IF				"IF"
THEN			"THEN"
ELSE			"ELSE"
ENDIF			"ENDIF"
WHILE			"WHILE"
READ			"READ"
WRITE			"WRITE"
AVG				"AVG"
INLIST			"INLIST"

%%

{CORA}          {printf("\nCorAbre: %s", yytext);return CORA;}
{CORC}			{printf("\nCorCierra: %s", yytext);return CORC;}

{DECVAR}		{printf("\nP_Reservada_DECVAR: %s", yytext);return DECVAR; }
{ENDDEC}		{printf("\nP_Reservada_ENDDEC: %s", yytext);return ENDDEC; }
{INT}			{printf("\nP_Reservada_INT: %s", yytext);return INT; }												
{FLOAT}			{printf("\nP_Reservada_FLOAT: %s", yytext);return FLOAT;}
{STRING}		{printf("\nP_Reservada_STRING: %s", yytext);return STRING;}
{IF}			{printf("\nP_Reservada_IF: %s", yytext);return IF;}
{THEN}			{printf("\nP_Reservada_THEN: %s", yytext);return THEN;}
{ELSE}			{printf("\nP_Reservada_THEN: %s", yytext);return ELSE;}
{ENDIF}			{printf("\nP_Reservada_ENDIF: %s", yytext);return ENDIF;}
{WHILE}			{printf("\nP_Reservada_WHILE: %s", yytext);return WHILE;}
{READ}			{printf("\nP_Reservada_READ: %s", yytext);return READ;}
{WRITE}			{printf("\nP_Reservada_WRITE: %s", yytext);return WRITE;}
{AVG}			{printf("\nP_Reservada_AVG: %s", yytext);return AVG;}
{INLIST}		{printf("\nP_Reservada_INLIST: %s", yytext);return INLIST;}

{CTE_E}			{printf("\nConstEntera: %s", yytext); eval_int(yytext);	return CTE_E;} 
{CTE_R}			{printf("\nConstReal: %s", yytext); return CTE_R;} 
{ID}			{printf("\nIdentificador: %s", yytext);return ID;}
{CTE_S} 		{printf("\nConstString: %s", yytext); eval_string(yytext); return CTE_S;} 
{COMENTARIO}
{DP}			{printf("\nDosPuntos: %s", yytext);return DP;}
{PC}			{printf("\nPuntoComa: %s", yytext);return PC;}
{OP_SUM}		{printf("\nSuma: %s", yytext);return OP_SUM;}
{OP_ASIG}		{printf("\nAsignacion: %s", yytext);return OP_ASIG;}
{OP_MUL}		{printf("\nMultiplicacion: %s", yytext);return OP_MUL;}
{OP_RES}		{printf("\nResta: %s", yytext);return OP_RES;}
{OP_DIV}		{printf("\nDivision: %s", yytext);return OP_DIV;}
{COMA}			{printf("\nComa: %s", yytext);return COMA;}
{LA}            {printf("\nLlAbre: %s", yytext);return LA;}
{LC}			{printf("\nLlCierra: %s", yytext);return LC;}
{PARA}			{printf("\nParAbre: %s", yytext);return PARA;}
{PARC}			{printf("\nParCierra: %s", yytext);return PARC;}
{PUNTO}			{printf("\nPunto: %s", yytext);return PUNTO;}
{AND}			{printf("\nAnd: %s", yytext);return AND;}
{OR}			{printf("\nOr: %s", yytext);return OR;}
{CO_IGUAL}		{printf("\nIgual: %s", yytext);return CO_IGUAL;}
{CO_DIST}		{printf("\nNoIgual: %s", yytext);return CO_DIST;}
{CO_MENI}		{printf("\nMenIgual: %s", yytext);return CO_MENI;}
{CO_MEN}		{printf("\nMenor: %s", yytext);return CO_MEN;}
{CO_MAYI}		{printf("\nMayIgual: %s", yytext);return CO_MAYI;}
{CO_MAY}		{printf("\nMayor: %s", yytext);return CO_MAY;}


"\n"      		
"\t"
"\n\t"
" "             		
"\r\n"
.			 { printf( "\nERROR LEXICO : Caracter no reconocido: %s\n", yytext ); exit (0);}

%%

//PRUEBA
/*int main(int argc,char *argv[])
{
	
	if ((yyin = fopen(argv[1], "r")) == NULL)
	{
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	}
	else
	{
		yylex();
	}
	
	fclose(yyin);

}*/