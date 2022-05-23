#include <stdio.h>
#include <stdlib.h>
#include "arbol.h"

struct Pila
{
	struct Nodo *ptr;
	struct Pila *sig ;
};

struct Pila *crea_pila( void )
{
	struct Pila *nuevo ;
	nuevo = ( struct Pila * )malloc(sizeof(struct Pila ));
	return nuevo ;
}

struct Pila *apilar( struct Pila *p , struct Nodo *q )
{
	struct Pila *nuevo = crea_pila( ) ;
	if(!nuevo)
		printf( "\nPila llena");
	else
	{
		nuevo->ptr = q ;
		nuevo->sig = p ;
	}
	return nuevo ;
}

struct Pila *desapilar( struct Pila *p )
{
	struct Pila *aux ;
	if( !p )
		printf( "\nPila vacia" );
	else
	{
		aux = p->sig ;
		free( p );
	}
		return aux ;
}




