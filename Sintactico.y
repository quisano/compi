%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"

int yystopparser=0;
FILE  *yyin;
int yyerror();
int yylex();
int crear_TS();


%}

%token CTE_E
%token CTE_R
%token ID
%token OP_ASIG   
%token OP_SUM
%token OP_MUL      
%token OP_RES
%token OP_DIV      
%token LA          
%token LC
%token PARA
%token PARC
%token CORA
%token CORC
%token AND 
%token OR
%token CO_IGUAL
%token CO_DIST
%token CO_MENI
%token CO_MEN
%token CO_MAYI
%token CO_MAY
%token IF
%token THEN
%token ELSE
%token ENDIF
%token WHILE
%token CTE_S 			
%token DP				
%token PC				
%token COMA
%token PUNTO
%token DECVAR
%token ENDDEC
%token INT
%token FLOAT
%token STRING
%token READ
%token WRITE
%token AVG
%token INLIST

%%

programa:
		sentencia {printf(" Sentencia es Programa\n"); } 
		| programa sentencia {printf( " Programa y Sentencia es Programa\n"); }
		;
		
sentencia:
		asignacion	{ printf(" Asignacion es Sentencia\n"); }
		| iteracion { printf(" Iteracion es Sentencia\n"); }
		| seleccion { printf(" Seleccion es Sentencia\n"); }
		| zonadec { printf(" Zona Declaracion es Sentencia\n"); }
		| read { printf("Read es Sentencia\n"); }
		| write { printf("Write es Sentencia\n"); }
		;

asignacion:
		ID OP_ASIG expresion {printf(" ID := Expresion es Asignacion\n"); }
		| ID OP_ASIG constante_string {printf(" ID := Constante String es Asignacion\n"); }
		| ID OP_ASIG promedio {printf(" ID := AVG es Asignacion\n");}
		;

seleccion:
		IF PARA condicion PARC THEN LA programa LC ELSE LA programa LC ENDIF{printf(" IF (Condicion) THEN {Programa} ELSE {Programa} Es Seleccion\n"); }
		| IF PARA condicion PARC THEN LA programa LC ENDIF{printf(" IF (Condicion) THEN {Programa} es Seleccion\n"); }
		;

iteracion:
		WHILE PARA condicion PARC LA programa LC {printf(" WHILE (Condicion) { programa } es Iteracion\n"); }
		;

condicion:
		  condicion AND comparacion {printf(" Condicion AND Comparacion es Condicion\n"); }
		| condicion OR comparacion {printf(" Condicion OR Comparacion es Condicion\n"); }
		| inlist {printf(" INLIST es Condicion\n"); }
		| comparacion {printf(" Comparacion es Condicion\n"); }
		;
		
comparacion:
		expresion comparador expresion {printf(" Expresion es Comparador y Expresion\n"); }
		;
		
comparador:
		CO_IGUAL {printf(" == es Comparador\n"); }
		| CO_DIST {printf(" != es Comparador\n"); }
		| CO_MENI {printf(" <= es Comparador\n"); }
		| CO_MEN {printf(" < es Comparador\n"); }
		| CO_MAYI {printf(" >= es Comparador\n"); }
		| CO_MAY {printf(" > es Comparador\n"); }
		;

expresion:
		expresion OP_SUM termino {printf(" Expresion + Termino es Expresion\n"); }
		| expresion OP_RES termino {printf(" Expresion - Termino es Expresion\n"); }
		| termino {printf(" Termino es Expresion\n"); } 
		;
		
termino:
		termino OP_MUL factor {printf(" Termino * Factor es Termino\n"); }
		| termino OP_DIV factor {printf(" Termino / Factor es Termino\n"); }
		| factor {printf(" Factor es Termino\n"); }
		;
		
factor:
		PARA expresion PARC {printf(" ( Expresion ) es Factor\n"); }
		| ID {printf(" ID es Factor\n"); }
		| CTE_E {printf(" CTE_E es Factor\n"); }
		| CTE_R {printf(" CTE_R es Factor\n"); }
		| promedio {printf(" Promedio es Factor\n");}
		;
		
zonadec:
		DECVAR  declaracion {printf (" DECVAR Declaracion es Zonadec\n"); }
		| declaracion {printf (" Declaracion es Zonadec\n"); }
		| declaracion ENDDEC {printf (" Declaracion ENDDEC es Zonadec\n"); }
		;
		
declaracion:
		variable DP tipo {printf(" Variable: Tipo es Declaracion\n"); }
		;
		
variable:
		variable COMA ID { printf(" Variable,ID es Variable\n"); } 
		| ID { printf(" ID es Variable\n"); } 
		;
tipo:
		FLOAT {printf (" FLOAT es Tipo\n"); }
		| INT {printf (" INT es Tipo\n"); }
		| STRING {printf (" STRING es Tipo\n"); }
		;
		
constante_string:
		CTE_S {printf (" CTE_S es Constante String\n"); }
		;

promedio: 
		AVG PARA lista PARC {printf("Promedio: AVG ( Argumentos )\n");}
		;
lista:
		CORA lista_argumentos CORC {printf("[ Lista_Argumentos] es Lista\n");}
		;
		
lista_argumentos:
		argumento COMA argumento {printf("Argumento , Argumento es Lista Argumentos\n");}
		;
		
argumento:
		CTE_E COMA factor {printf(" CTE_E , Factor es Argumento\n");}
		| CTE_R COMA factor {printf("CTE_R , Factor es Argumento\n");}
		| PARA expresion PARC  {printf("( expresion ) es Argumento\n");} 
		;
		
inlist:
		INLIST PARA lista_inlist PARC { printf( "INLIST ( lista_inlist ) es Inlist\n"); }
		;

lista_inlist:
		arg_inlist PC arg_inlist { printf("Arg_Inlist ; Arg_Inlist es Lista_Inlist\n" ); }
		| arg_inlist { printf("Arg_Inlist es Lista_Inlist\n" ); }
	
arg_inlist:
		expresion PC arg_inlist{ printf("Expresion ; Arg_Inlist es Arg_Inlist\n" ); }
		| termino PC arg_inlist { printf("Termino ; Arg_Inlist es Arg_Inlist\n" ); }
		| factor { printf("Factor es Arg_Inlist\n" ); }
		| CORA vector CORC { printf("[Vector] es Arg_Inlist\n" ); }
		;
		
vector:	
		expresion PC vector{ printf("Expresion ; Vector es Vector\n" ); }
		| termino PC vector { printf("Termino ; Vector es Vector\n" ); }
		| factor PC vector { printf("Factor ; Vector es Vector\n" ); }
		| factor { printf("Factor es Vector\n" ); }
		| expresion { printf("Expresion es Vector\n" ); }
		| termino { printf("Termino es Vector\n" ); }
		;
		
read:
		READ CTE_S { printf("READ CTE_S es Read\n"); }
		| READ CTE_E {printf(" READ CTE_E es Read\n"); }
		| READ ID {printf(" READ ID es Read\n"); }
		| READ CTE_R {printf(" READ CTE_R es Read\n"); }
		;
write:
		WRITE CTE_S { printf("WRITE CTE_S es Write\n"); }
		| WRITE CTE_E {printf(" WRITE CTE_E es Write\n"); }
		| WRITE ID {printf(" WRITE ID es Write\n"); }
		| WRITE CTE_R {printf(" WRITE CTE_R es Write\n"); }
		;
%%


int main(int argc, char *argv[])
{
    if((yyin = fopen(argv[1], "rt"))==NULL)
    {
        printf("\nNo se puede abrir el archivo de prueba: %s\n", argv[1]);
       
    }
    else
    { 
        
        yyparse();
        
    }
	fclose(yyin);
	crear_TS();
    return 0;
}
int yyerror(void)
{
	printf("Error Sintactico\n");
	exit (1);
}