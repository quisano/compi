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
char tituloTS[] = "NOMBRE\t\t\tTIPO\t\t\tVALOR\t\t\tLONGITUD\n";
void nuevoSimbolo(char nombre[], char tipo[], void* valor);
void crearLista(t_lista*);
int comparacionDeSimbolo(const t_simbolo*, const t_simbolo*);
void vaciarLista(t_lista*);
void imprimirLista(FILE* pf, t_lista* pl);
void actualizar_tipo_dato(char tipo[], t_lista*);
void actualizar_tipo_dato_en_simbolo(t_simbolo* d, char tipo[]);

extern int yyerror(char *message);
extern int yylex(void);

%}

%union {
	int int_val;
	double float_val;
	char *string_val;
}

//--Start Symbol
%start programa

//--Tokens
// - Palabras reservadas
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
%token READ
%token WRITE

// - Operadores
%token OP_SUM
%token OP_RES
%token OP_DIV
%token OP_MUL
%token OP_MOD
%token OP_ASIG
%token OP_IGUAL
%token OP_DOSP

// - Elementos gramaticales
%token CAR_COMA
%token CAR_PYC
%token CAR_PA
%token CAR_PC
%token CAR_CA
%token CAR_CC
%token CAR_LA
%token CAR_LC

// - Comparadores
%token CMP_MAYOR
%token CMP_MENOR
%token CMP_MAYORIGUAL
%token CMP_MENORIGUAL
%token CMP_DISTINTO
%token CMP_IGUAL

// - Conectores
%token AND
%token OR
%token NOT

// - Constantes
%token <string_val>ID
%token <int_val>CTE_INT
%token <float_val>CTE_FLOAT
%token <string_val>CTE_STRING

// - Definicion de la gramatica
%%
programa:
	declaracion_variables {printf("Fin Declaracion de variables\n");}
	sentencias

declaracion_variables: 
	{printf("Declaracion de variables\n");} DECVAR lista_de_declaracion_variables_multiple ENDDEC

lista_de_declaracion_variables_multiple:
	lista_variables_multiple OP_DOSP declaracion_tipo

lista_variables_multiple:
	lista_variables_multiple CAR_COMA ID {printf("Regla -> lista_variables_multiple: lista_variables_multiple , ID\n");} |
	ID 	{printf("Regla -> lista_variables_multiple: ID\n");}

declaracion_tipo:
	INT
	| FLOAT	
	| STRING

sentencias:
	sentencias sentencia |
	sentencia

sentencia:
	//sentencia operacion {printf("Regla -> sentencia: sentencia operacion\n");} |
	operacion  {printf("Regla -> sentencia: operacion\n");}

operacion:
	operacion_if 		{printf("Regla -> operacion : operacion_if\n");}	|
	iteracion  			{printf("Regla -> operacion : iteracion\n");}	|
	asignacion			{printf("Regla -> operacion : asignacion\n");}

operacion_if:
	IF CAR_PA condiciones CAR_PC CAR_LA sentencias CAR_LC {printf("Regla -> IF (condiciones) {sentencias}\n");} |
	IF CAR_PA condiciones CAR_PC CAR_LA sentencias CAR_LC ELSE CAR_LA sentencias CAR_LC {printf("Regla -> IF (condiciones) {sentencias} ELSE {sentencias}\n");}

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
	CAR_CA argumento CAR_CC {printf("Regla -> argumentos: CAR_CA argumento CAR_CC\n");}

argumento:
	argumento CAR_COMA factor {printf("Regla -> argumento: argumento CAR_COMA factor\n");} |
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
	FILE* pf = fopen("ts.txt","wt");
	
	if (!(yyin = fopen(argv[1], "rt")))
	{
		printf("\nError al abrir %s. Se aborta la ejecucion.\n", argv[1]);
		return -1;
	}

	crearLista(&list);
	
	yyparse();
	
	fclose(yyin);
	imprimirLista(pf,&list);
	vaciarLista(&list);
	fclose(pf);

	printf("\n\n* COMPILACION EXITOSA *\n");

	return 0;
}

//Función comparacionDeSimbolo: Compara los nombres de los IDs para no agregar ya existentes
int comparacionDeSimbolo(const t_simbolo *d,const t_simbolo *dc)
{
    return (strcmp(d->nombre ,dc->nombre));

}

//Función crearLista: Función que inicializa en NULL la lista de simbolos
void crearLista(t_lista *pl)
{
    *pl=NULL;
}

//Función vaciarLista: Función que libera los recursos de la memoria utilizado por la lista de simbolos
void vaciarLista(t_lista *pl)
{
    t_nodo* aux;

    while(*pl)
    {
        aux=*pl;
        *pl=aux->sig;
        free(aux);
    }
}


//Función imprimirLista: Función que imprime en el archivo .txt de la tabla de simbolos la lista de simbolos
void imprimirLista(FILE* pf, t_lista* pl)
{
    fprintf(pf," Nombre                          | Tipo          | Valor                          | Longitud |\n");
    fprintf(pf,"---------------------------------|---------------|--------------------------------|----------|\n");

    while(*pl)
    {
        fprintf(pf,"%-33s|%-15s|%-32s|%-10s|\n",(*pl)->simbolo.nombre,(*pl)->simbolo.tipo,(*pl)->simbolo.valor,(*pl)->simbolo.longitud);
		pl=&(*pl)->sig;
    }
}

//Función enlistar: Función que agrega en lista un nuevo nodo de estructura tipo Simbolo
int enlistar(t_lista *pl,t_simbolo* d)
{
    t_nodo* nue;

    while(*pl && comparacionDeSimbolo(d,&(*pl)->simbolo))
    {
        pl=&(*pl)->sig;
    }

    if(!(*pl))
    {
        nue=(t_nodo*) malloc(sizeof(t_nodo));

        if(!nue)
            return -1;

        nue->simbolo=*d;
        nue->sig=NULL;
        *pl=nue;

        return 1;
    }

    return 0;
}

//Función nuevoSimbolo: Función realiza un Set de valores a un nuevo nodo de estructura tipo Simbolo
void nuevoSimbolo(char nombre[], char tipo[], void* valor)
{
	int* entero;
	double* real;
	char *array;
   	int length, c = 0;
   	char aux[30];

	t_simbolo simbolo;

	strcpy(simbolo.longitud,"--");
	strcpy(simbolo.valor,"");

	if(strcmp(tipo,"ID") != 0)
	{
		if(strcmp(tipo,"CTE_INT") == 0)
		{
			entero = (int *) valor;
			sprintf(simbolo.valor,"%d",*entero);
			sprintf(simbolo.nombre,"_%d",*entero);
		}
		if(strcmp(tipo,"CTE_FLOAT") == 0)
		{
			real = (double*) valor;
			sprintf(simbolo.valor,"%.7f",*real);
			sprintf(simbolo.nombre,"_%.7f",*real);
		}

		if(strcmp(tipo,"CTE_STRING") == 0)
		{
			array= (char*)valor;
			length = strlen(array) - 2;
		 
		   	while (c < length) {
		      	aux[c] = array[1+c];
		     	c++;
		   	}
		   	aux[c] = '\0';
			array = aux;

			sprintf(simbolo.valor,"%s",array);
			sprintf(simbolo.nombre,"_%s",array);
			sprintf(simbolo.longitud,"%d",strlen(array));
		}
		strcpy(simbolo.tipo,tipo);
	}
	else {
		strcpy(simbolo.tipo,tipo);
		strcpy(simbolo.nombre,nombre);
	}

	enlistar(&list,&simbolo);
}

//Función actualizar_tipo_dato: Función que recorre la lista de simbolos buscando IDs sin tipo de datos para asignarle el tipo correcto.
void actualizar_tipo_dato(char tipo[], t_lista *pl){
	char* tipo_simb;
	char* id = "ID";

	while(*pl) {
		tipo_simb = (*pl)->simbolo.tipo;

		if(strcmp(tipo_simb, id)==0) {
			actualizar_tipo_dato_en_simbolo(&(*pl)->simbolo, tipo);
		}
		pl=&(*pl)->sig;
	}
}

//Función actualizar_tipo_dato_en_simbolo: Función que realiza un String Copy del tipo de dato a un nodo Simbolo.
void actualizar_tipo_dato_en_simbolo(t_simbolo* d, char tipo[]) {
		strcpy(d->tipo, tipo);
}