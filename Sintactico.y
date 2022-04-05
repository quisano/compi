%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>
#include "y.tab.h"

typedef struct{
    char nombre[33];
    char tipo[15];
    char valor[32];
    char longitud[10];
}t_simbolo;


typedef struct s_nodo{
    t_simbolo simbolo;
    struct s_nodo *sig;
}t_nodo;

typedef t_nodo *t_lista;
int yystopparser=0;


t_lista list;

FILE  *yyin;
char *yyltext;
char *yytext;
int yylex();
void yyerror(const char *s);

%}

%union {
	int int_val;
	double float_val;
	char *string_val;
}

//Start Symbol
%start programa

//Tokens
%token DECVAR
%token ENDDEC
%token IF
%token THEN
%token ELSE
%token ENDIF
%token WHILE
%token DO
%token ENDWHILE
%token INLIST
%token AVG
%token INT
%token FLOAT
%token STRING
%token OP_SUM
%token OP_RES
%token OP_DIV
%token OP_MUL
%token OP_MOD
%token OP_ASIG
%token OP_IGUAL
%token OP_DOSP
%token CAR_COMA
%token CAR_PYC
%token CAR_PA
%token CAR_PC
%token CAR_CA
%token CAR_CC
%token CAR_LA
%token CAR_LC
%token CMP_MAYOR
%token CMP_MENOR
%token CMP_MAYORIGUAL
%token CMP_MENORIGUAL
%token CMP_DISTINTO
%token CMP_IGUAL
%token AND
%token OR
%token NOT
%token <string_val>ID
%token <int_val>CTE_INT
%token <float_val>CTE_FLOAT
%token <string_val>CTE_STRING

//Definicion de la gramatica
%%
programa: {printf("INICIO DEL PROGRAMA\n");}
	declaracion_variables
	sentencias {printf("FIN DEL PROGRAMA\n");}

declaracion_variables: 
	DECVAR {printf("Inicio de declaracion de variables múltiples\n");}
	lista_de_declaracion_variables_multiple OP_DOSP declaracion_tipo
	ENDDEC {printf("Fin de declaracion de variables\n");}

lista_de_declaracion_variables_multiple:
	CAR_CA {printf("Inicio de declaracion de variables\n");}
	lista_variables_multiple
	CAR_CC {printf("Fin de declaracion de variables\n");}

lista_variables_multiple:
	lista_variables_multiple CAR_COMA ID {printf("Regla -> lista_variables_multiple: lista_variables_multiple , ID\n");}

lista_variables_multiple:
	ID 	{printf("Regla -> lista_variables_multiple: ID\n");}

declaracion_tipo:
	INT
	| FLOAT	
	| STRING

sentencias:
	sentencias operacion {printf("Regla -> sentencias: sentencias operacion\n");}

sentencias:
	operacion  {printf("Regla -> sentencias: operacion\n");}

operacion:
	operacion_if 		{printf("Regla -> operacion : operacion_if\n");}	|
	iteracion  			{printf("Regla -> operacion : iteracion\n");}	|
	asignacion			{printf("Regla -> operacion : asignacion\n");}

operacion_if:
	IF CAR_PA condiciones CAR_PC THEN CAR_LA sentencias CAR_LC {printf("Regla -> IF (condiciones) THEN {sentencias}\n");}

operacion_if:
	IF CAR_PA condiciones CAR_PC THEN CAR_LA sentencias CAR_LC ELSE CAR_LA sentencias CAR_LC {printf("Regla -> IF (condiciones) THEN {sentencias} ELSE {sentencias}\n");}

iteracion:
	WHILE CAR_PA condiciones CAR_PC CAR_LA sentencias CAR_LC {printf("Regla -> WHILE (condiciones) {sentencias}\n");}

condiciones:
	condicion 						{printf("Regla -> condiciones : condicion\n");}	|
	NOT condicion 					{printf("Regla -> condiciones : !condicion\n");} |
	condicion operador condicion 	{printf("Regla -> condiciones : condicion operador condicion\n");}

condicion:
	expresion operador expresion 	{printf("Regla -> condicion : expresion operador condicion\n");} |
	funcion_especial 				{printf("Regla -> condicion : funcion_especial\n");}

funcion_especial: 
	INLIST CAR_PA expresion CAR_PYC argumentos CAR_PC {printf("Regla -> funcion_especial: INLIST CAR_PA expresion CAR_PYC argumentos CAR_PC\n");} |
	AVG CAR_PA argumentos CAR_PC {printf("Regla -> funcion_especial: AVG CAR_PA argumentos CAR_PC\n");}

argumentos:
	CAR_CA argumento CAR_CC | {printf("Regla -> argumentos: CAR_CA argumento CAR_CC\n");}

argumento:
	argumento CAR_COMA factor | {printf("Regla -> argumento: argumento CAR_COMA factor\n");}
	factor {printf("Regla -> argumento: factor\n");}

operador:
	AND				{printf("Regla -> operador : AND\n");}|
	OR 				{printf("Regla -> operador : OR\n");}|
	CMP_IGUAL 		{printf("Regla -> operador : ==\n");}|
	CMP_DISTINTO 	{printf("Regla -> operador : !=\n");}| 
	CMP_MENOR 		{printf("Regla -> operador : <\n");}|
	CMP_MAYOR 		{printf("Regla -> operador : >\n");}| 
	CMP_MENORIGUAL 	{printf("Regla -> operador : <=\n");}| 
	CMP_MAYORIGUAL	{printf("Regla -> operador : >=\n");}


asignacion:	
	ID OP_ASIG expresion	{printf("Regla -> asignacion: ID := expresion\n");}

expresion:
	expresion OP_RES termino	{printf("Regla -> expresion: expresion - termino\n");}|
	expresion OP_SUM termino	{printf("Regla -> expresion: expresion + termino\n");}|
	termino						{printf("Regla -> expresion: termino\n");}

termino:
	termino OP_MUL factor	{printf("Regla -> termino: termino * factor\n");}|	
	termino OP_DIV factor	{printf("Regla -> termino: termino / factor\n");}|
	factor					{printf("Regla -> termino: factor\n");}

factor:
	ID 			{printf("Regla -> factor: ID\n");}| 
	constante	{printf("Regla -> factor: constante\n");}

constante:
	CTE_INT		{printf("Regla -> constante: INT\n");}|
	CTE_FLOAT	{printf("Regla -> constante: FLOAT\n");}|
	CTE_STRING	{printf("Regla -> constante: STRING\n");}

%%

//Función main: Abre el archivo de pruebas lo lee y escribe Tabla de Simbolos.
int main(int argc,char *argv[])
{
	if (!(yyin = fopen(argv[1], "rt")))
	{
		printf("\nError al abrir %s. Se aborta la ejecucion.\n", argv[1]);
		return -1;
	}
	
	yyparse();
	
	fclose(yyin);

	printf("\n\n* COMPILACION EXITOSA *\n");

	return 0;
}