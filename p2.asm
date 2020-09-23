
include p2M.asm     ;---------------Macros file            

.model small
;----------------------------------------------------
;-----------------SEGMENTO DE PILA-------------------
;----------------------------------------------------
.stack
;----------------------------------------------------
;-----------------SEGMENTO DE DATO------------------
;----------------------------------------------------
.data

;----------------------CADENAS A MOSTRAR-------------------------
displayTitulo   db      0ah,0dh,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',
                        0ah,0dh,'FACULTAD DE INGENIERIA',
                        0ah,0dh,'CIENCIAS Y SISTEMAS',
                        0ah,0dh,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES',
                        0ah,0dh,'NOMBRE: JULIAN ISAAC MALDONADO LOPEZ',
                        0ah,0dh,'CARNET: 201806839',
                        0ah,0dh,'A','$'
displayGrafica db       0ah,0dh,'Seleccione la opcion a graficar',
                        0ah,0dh,'1) Graficar original',
                        0ah,0dh,'2) Graficar derivada',
                        0ah,0dh,'3) Graficar Intergal',
                        0ah,0dh,'4) Salir','$'

displayOpciones  db     0ah,0dh,'1) Ingresar funcion f(x)',
                        0ah,0dh,'2) Funcion en memoria',
                        0ah,0dh,'3) Derivada f(x)',
                        0ah,0dh,'4) Intergal f(x)',
                        0ah,0dh,'5) Graficar funciones',
                        0ah,0dh,'6) Reporte',
                        0ah,0dh,'7) Modo calculadora',
                        0ah,0dh,'8) Salir','$'


msg1            db      0ah,0dh,'Ingrese los coeficientes: ','$'   
msg2            db      0ah,0dh,'Ingrese el valor inicial: ','$'   
msg3            db      0ah,0dh,'Ingrese el valor final: ','$' 
msg4            db      0ah,0dh,'Todo bien, todo correcto','$' 
msg5            db      0ah,0dh,'El resultado de la operacion es: ','$' 
msg6            db      0ah,0dh,'Ingrese constante de integracion ','$' 
ing             db      0ah,0dh,'Ingrese el nombre del archivo:','$'
msgX4           db      0ah,0dh,'- Coeficiente de x4: ','$'
msgX3           db      0ah,0dh,'- Coeficiente de x3: ','$'
msgX2           db      0ah,0dh,'- Coeficiente de x2: ','$'
msgX1           db      0ah,0dh,'- Coeficiente de x1: ','$'
msgX0           db      0ah,0dh,'- Coeficiente de x0: ','$'

               
                
salto           db      0ah,0dh,'$'

;--------------------REPORTE HTML--------------------
style           db 0ah,0dh,'<style>',0ah,0dh,'h2,h3 {',0ah,0dh,'  font-family: Arial;',0ah,0dh,'  line-height: 0.5em;',0ah,0dh,'}',0ah,0dh,'</style> ','$'
f1              db 0ah,0dh,'<h2> UNIVERSIDAD DE SAN CARLOS DE GUATEMALA</h2> ','$'
f2              db 0ah,0dh,'<h2> FACULTAD DE INGENIERIA</h2> ','$'
f3              db 0ah,0dh,'<h2> ESCUELA DE CIENCIAS Y SISTEMAS</h2> ','$'
f4              db 0ah,0dh,'<h2> ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A</h2> ','$'
f5              db 0ah,0dh,'<h2> PRIMER SEMESTRE 2020</h2> ','$'
f6              db 0ah,0dh,'<h3> JULIAN ISAAC MALDONADO LOPEZ</h3> ','$'
f7              db 0ah,0dh,'<h3> 201806839</h3> ','$'
f8              db 0ah,0dh,'<h3> REPORTE PRACTICA NO.3</h3> ','$'
f9              db 0ah,0dh,'<h3> Funcion original ','$'
f10             db 0ah,0dh,'<h3> Funcion derivada</h3> ','$'
f11             db 0ah,0dh,'<h3> Funcion integral</h3> ','$'
otxt            db 'f(x)= ','$'
dtxt            db 'f',27h,'(x)= ','$'
itxt            db 'F(x)= ','$'
abrirH3         db 0ah,0dh,'<h3> ','$'
cerrarH3        db 0ah,0dh,'</h3> ','$'
saltoHTML       db 0ah,0dh,'</br> ','$'



;-------------------ERRORES-----------------------------
error1 db 'Error al cargar el archivo','$'
error2 db 'Error al cerrar el archivo','$'
error3 db 'Error al leer el archivo','$'
error4 db 'Error al crear el archivo','$'
error5 db 'Error al escribir el archivo','$'
error6 db 'Comando invalido','$'

error7 db  0ah,0dh,'Caracter no valido','$'
error8 db  0ah,0dh,'Funcion vacia','$'
error9 db  0ah,0dh,'Error lexico detectado: ','$'
error10 db  0ah,0dh,'Extension incorrecta ','$'
error11 db  0ah,0dh,'Formato incorrecto ','$'
error12 db  0ah,0dh,'Limite erroneo ','$'

errorDebbug db 'Error','$'

;--------------------VARIABLES DINAMICAS--------------
reporteHtml     db 3500 dup('$'),'$'
arreglo         db 7 dup('$'),'$'


date  db "00/00/0000",0dh, 0ah,'$'
time db      "00:00:00", 0dh, 0ah, '$'


fAux1           db 10 dup('$'),'$'
fAux2           db 10 dup('$'),'$'
fAux3           db 25 dup('$'),'$'
fGuardar        db 20 dup('$'),20h,'$'
fDerivada       db 20 dup('$'),20h,'$'
fIntegral       db 30 dup('$'),20h,'$'



cont            db 0,'$'
j               dw 0
i               dw 0
signo           db '+','$'
numero          db 0,'$'
indice          db 0,'$'


inicioX         dw 0
finX            dw 0
constante       dw 0            ;---------valor de constante de integracion

resultado       db 300 dup('$'),'$'
x               dw 0
y               dw 0

operadores      db 100 dup('$'),'$'
operandos       dw 100 dup(0),0
guardaError     db 0,'$'


ruta            db 50 dup(0),0
auxRuta         db 50 dup(0),0
handlerRuta     dw ?
informacion     db 71 dup('$'),'$'
;----------------------------------------------------
;-----------------SEGMENTO DE CODIGO-----------------
;----------------------------------------------------
.code 
main proc


  Menu:
    print salto
    print displayTitulo
    print salto
    print displayOpciones
    print salto
    getChar
    cmp al,'1'
    je Funcion
    cmp al,'2'
    je Memoria
    cmp al,'3'
    je Derivada
    cmp al,'4'
    je Intergal
    cmp al,'5'
    je Graficar
    cmp al,'6'
    je Reporte
    cmp al,'7'
    je Calculadora
    cmp al,'8'
    je Salir
    jmp Menu

  Funcion:
  print msg1
  xor si,si
  funcValida msgX4,fGuardar,'4'
  funcValida msgX3,fGuardar,'3'
  funcValida msgX2,fGuardar,'2'
  funcValida msgX1,fGuardar,'1'
  funcValida msgX0,fGuardar,'0'


  xor si,si
  funcDerivada fGuardar,fDerivada
  xor si,si
  funcIntegral fGuardar,fIntegral
  jmp Menu
  
  Calculadora:

  print salto
  print ing
  getTexto ruta
  setRuta ruta
  abrir auxRuta,handlerRuta
  leer handlerRuta,informacion,SIZEOF informacion   
  entradaValida informacion
  setNumeros informacion,operandos
  setOperadores informacion,operadores
 
  modoCalculadora operandos,operadores,2fh ;------------'/'
  modoCalculadora operandos,operadores,2ah ;------------'*'
  modoCalculadora operandos,operadores,2dh ;------------'-'
  modoCalculadora operandos,operadores,2bh ;------------'+'
  
  mov ax,operandos[0]  ;-----------------resultado almacenado en la primera posicion 
  parseString resultado
  print salto
  print msg5
  print salto
  print resultado
  jmp menu

  Memoria:
  print salto
  funcVacia
  print otxt
  print fGuardar
  jmp Menu

  Derivada:
  print salto
  funcVacia
  print dtxt
  print fDerivada
  jmp Menu

  Intergal:
  print salto
  funcVacia
  print itxt
  print fIntegral
  jmp Menu


  Reporte:
  funcVacia
  functMostrar 
  jmp menu
  Graficar:
  funcVacia
  print displayGrafica
  getChar
    cmp al,'1'
    je gOriginal
    cmp al,'2'
    je gDerivada
    cmp al,'3'
    je gIntegral
    cmp al,'4'
    je Menu
    jmp Graficar
 
    gOriginal:
    xor si,si
    rangoValida msg2,inicioX
    rangoValida msg3,finX
    rangoMayor
    plotOriginal fGuardar
    jmp Graficar
    gDerivada:
    xor si,si
    rangoValida msg2,inicioX
    rangoValida msg3,finX
    rangoMayor
    plotDerivada fDerivada
    jmp Graficar
    gIntegral:
    xor si,si
    rangoValida msg2,inicioX
    rangoValida msg3,finX
    rangoMayor
    rangoValida msg6,constante
    plotIntegral fIntegral,constante
    jmp Graficar

  jmp Menu
  Salir:
        mov ah,4ch
        xor al,al
        int 21h


main endp
end main