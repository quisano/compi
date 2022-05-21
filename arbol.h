#include <stdlib.h>
#include <stdio.h>

struct Nodo {
	char *dato;
	struct Nodo *izquierda;
	struct Nodo *derecha;
};

struct Nodo *Pp, *Sp= NULL, *Ap= NULL, *Ep= NULL, *Tp= NULL, *Fp= NULL, *AVGp, *LAVGp = NULL, *Zp = NULL, *Dp = NULL, *LDp = NULL , *Vp = NULL, *TPp = NULL ;

struct Nodo *crearHoja(char *dato) {
    size_t tamanioNodo = sizeof(struct Nodo);
    struct Nodo *nodo = (struct Nodo *) malloc(tamanioNodo);
    nodo->dato = dato; 
    nodo->izquierda = nodo->derecha = NULL;
    return nodo;
}

struct Nodo *crearNodo(char *dato, struct Nodo *izq, struct Nodo *der){
    size_t tamanioNodo = sizeof(struct Nodo);
    struct Nodo *nodo = (struct Nodo *) malloc(tamanioNodo);
    nodo->dato = dato; 
    nodo->izquierda = izq ;
	nodo->derecha = der;
    return nodo;
	
}

void postorden(FILE *archivo, struct Nodo *nodo) {
    
	if (nodo != NULL) {     
		postorden(archivo, nodo->izquierda);
        postorden(archivo, nodo->derecha);
        fprintf(archivo, nodo->dato);
		
    }

}

int exportar( struct Nodo *raiz ){
	FILE *archivo;
	archivo = fopen("intermedio.txt","a"); 
	postorden( archivo , raiz );
	fprintf(archivo,"\n");
	fclose(archivo);
}



