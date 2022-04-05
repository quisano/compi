echo "1. Genero Léxico"
flex Lexico.l
echo "Listo"
echo "2. Genero Sintáctico"
bison -dyv Sintactico.y
echo "Listo"
echo "3. Genero Ejecutable"
gcc.exe lex.yy.c y.tab.c -o Primera.exe
echo "Listo"
echo "4. Corriendo programa del programador"
Primera.exe Prueba.txt
echo "Listo"
echo "Eliminando archivos generados..."
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del Primera.exe
echo "Listo"
