:: Script para windows
del intermedio.txt
flex Lexico.l
bison -dyv Sintactico.y

gcc.exe lex.yy.c y.tab.c arbol.h -o Primera.exe

Primera.exe Prueba.txt

@echo off
del Primera.exe
del lex.yy.c
del y.tab.c
del y.tab.h
del y.output

pause

