.data
mensaje_entrada: .asciiz "Ingresar Nodo del cual se desea la informacion\n" # mensaje que solicita el nodo
resultado: .asciiz " Los valores son:" # mensaje que entrega los resultados
matriz: .word 0,2,0,0,0,1,3,10,0 #ejemplo de matriz de adyacencia con un tamaño de 3x3
tamaño: .word 3 
distancia: .word 999,999,999 #array que en el futuro contendra las distancias mas cortas entre los vertices. Lo inicio con 999 que representara infinito
vertice_incluido: .word 0,0,0 #contendra valores 0 o 1 dependiendo si un vertice esta incluido en el camino mas corto

.text
.globl main

main:

la $a1, matriz #asigno la direccion de la matriz
lw $a2, tamaño #asigno el valor del tamaño
la $a3, distancia #asigno la direccion del array distancias
la $a0, vertice_incluido # asigno la direccion del array correspondiente



li $v0,4 #llamada para imprimir
la $a0,mensaje_entrada #selecciono la etiqueta mensaje para imprimirla
syscall #imprimo

addi $v0, $zero, 5	
syscall			# pregunta por un entero al usuario usando la syscall 5

add $a0, $zero, $v0	# mueve el entero entregado por la syscall 5 a a0, lo cual me servira para saber que opcion fue seleccionada



#la $a0, vertice_incluido # asigno la direccion del array correspondiente

jal Dijkstra




Distancia_Minima: #funcion para encontrar el vertice son valor de dsitancia minima desde el conjunto de vertices aun no incluidos en el camino mas corto
li $v1,0     #variable que retorna el indice del valor minimo
addi $s1,$zero,999
li $t3,0 #me sirve como contador para el FOR y para los indices de los vectores
FOR_Distancia_Minima:
beq,$t3,$a2, FIN_FOR_Distancia_Minima
lw $t2,0($a0) #es quivalente a decir $t1=a0[$t3]
lw $t1,0($a3) #es quivalente a decir $t1=a3[$t3]
bne,$t2,$zero,Repetir_FOR_Distancia_Minima
blt,$s1,$t1,Repetir_FOR_Distancia_Minima
addi $s1,$t1,0 #minimo =distancia
addi $v1,$t3,0 #variable que necesito al final de esta funcion, por ende no modificarla

Repetir_FOR_Distancia_Minima:
addi $a3,$a3,4
addi $a0,$a0,4
addi $t3,$t3,1 #contador del For +1
b FOR_Distancia_Minima #se repite el ciclo

FIN_FOR_Distancia_Minima: 

li $t4,4
mul $t5,$a2,$t4
subi $t6,$t5,4

sub $a3,$a3,$t6
sub $a0,$a3,$t6 # me devuelvo al primer espacio de los arreglos vertice incluido y distancias 
jr $ra #retorna hacia donde fue invocada la funcion 



Dijkstra:

li $t0,4
mul $t1,$t0,$a0
add $a3,$a3,$t1 # avanzo al indice del nodo recibido como entrada
li $t1,0
sw $t1,0($a3) #la distancia de un nodo a si mismo es cero obviamente
sub $a3,$a3,$t1 #me retorno al primer indice del arreglo

li $t1,0
subi $t2,$a2,1 # tamaño-1
la $a0, vertice_incluido # asigno la direccion del array correspondiente

FOR_Principal_Buscar_Distancia_Minima:
beq $t1,$t2, FIN_Dijkstra
jal Distancia_Minima
 
li $t0,4
mul $t5,$v1,$t0
add $a0,$a0,$t5 #me ubico en el indice correcto del array vertices incluidos
li $t6,1
sw $t6,0($a0)
sub $a0,$a0,$t5 # me devuelvo al primer indice

add $a3,$a3,$t5
lw $t7,0($a3) #distancia[v1]
sub $a3,$a3,$t5#retorno al indice correspondiemte

li $t4,0
For_Segundo: #actualizara los valores de las distancias
beq $t4,$a2,Fin_For_Segundo
lw $t3,0($a0) #vertice_incluido[v]
lw $t9,0($a3) #distancia[$t4]
lw $t8,0($a1)
add $s2,$t7,$t8

bnez $t3,Repetir_For_Segundo
beq $t8,$s1,Repetir_For_Segundo
beq $t7,$s1,Repetir_For_Segundo
bge $s2,$t9,Repetir_For_Segundo
sw   $s2,0($a3)


Repetir_For_Segundo:
addi $a1,$a1,4
addi $a0,$a0,4
addi $a3,$a3,4
addi $t4,$t4,1
b For_Segundo

Fin_For_Segundo:
addi $t1,$t1,1
b FOR_Principal_Buscar_Distancia_Minima
 
FIN_Dijkstra: jr $ra
