#include <stdio.h>
#include <stdlib.h>

struct Ts{
	char nombre[100];
	char tipo[100];
	char valor[50];
	int longitud;
};

//crear_TS
//guardar_TS

struct Ts *leerTs( ){
		
		FILE *f;
		
		f = fopen("ts.txt","r");
		
		if( f == NULL ){
			printf( " No se pudo abrir el archivo\n");
			exit(1);
		}
		
		size_t tam = sizeof(struct Ts);
		struct Ts *tabla = (struct Ts *) malloc(tam);
    
		
}

