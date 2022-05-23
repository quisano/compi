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
		
	struct Ts *ts;
		
		FILE *f;
		
		f = fopen("ts.txt","r");
		
		if( f == NULL ){
			printf( " No se pudo abrir el archivo\n");
			exit(1);
		}

		size_t tam = sizeof(struct Ts);
		struct Ts *tabla = (struct Ts *) malloc(tam * tam_archivo(f));
		
		ts
	
}

struct Ts *recorrer_archivo( FILE *f ){
	
	struct Ts *ts;
	char temp[50];
	
	while( !eof(f) ){
		
		for( int i = 0 ; i != "|"; i++){
			temp[i] = fgetc(f);
			
		}
		
		ts->nombre = temp; 

	}
	
}

int tam_archivo( FILE *f ){
	
	int c = 0;
	char *temp = NULL;
	
	while( !eof(f) ){
		
		fgets(temp,100,f);
		
		c++;

	}
	return c;
	
}


