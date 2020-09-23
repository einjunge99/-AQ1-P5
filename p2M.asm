;--------------------------MANEJO ARCHIVOS---------------------
abrir macro buffer,handler
local error,fin
mov ah,3dh
mov al,00h
lea dx,buffer
int 21h
jc error
mov handler,ax
jmp fin

error:
print error1
getChar
jmp Menu
fin:
endm 

cerrar macro handler 
local error, fin
mov ah, 3eh
mov bx,handler
int 21h
jc  error
jmp fin
error:
print error2
getChar
jmp Menu
fin:
endm

leer macro handler,buffer,numBytes
local error, fin
mov ah,3fh
mov bx,handler
mov cx,numBytes
lea dx,buffer
int 21h
jc error
jmp fin
error:
print error3
getChar
jmp Menu
fin:
endm

crear macro buffer,handler
LOCAL error,fin
mov ah,3ch
mov cx,00h
lea dx,buffer
int 21h
jc error
mov handler,ax
jmp fin

error:
print error4
fin:
endm

escribir macro handler,buffer,numBytes
LOCAL error,fin
mov ah,40h
mov bx,handler
mov cx ,numBytes
lea dx,buffer
int 21h
jc error
jmp fin
error:
print error5
fin:
endm

sobrantes macro buffer,numBytes     ;----------elimina '$' no utilizados de cadena especificada
LOCAL ciclo1,ciclo2,fin
xor si,si
xor cx,cx
mov cx,numBytes
ciclo1:
cmp buffer[si],24h    
je ciclo2
inc si
loop ciclo1
jmp fin
ciclo2:
mov buffer[si],20h
inc si
loop ciclo2
fin:
endm


;-----------------------VISUALES------------------------------


print macro buffer
mov ax,@data
mov ds,ax
mov ah,09h
mov dx,offset buffer
int 21h
endm

pixel macro x0,y0,color
push cx
mov ah,0ch
mov al,color
mov bh,0h
mov dx,y0
mov cx,x0
int 10h
pop cx

endm

eje macro
LOCAL eje_x,eje_y
mov ax,0013h
int 10h
mov cx,13eh
eje_x:
    pixel cx,5fh,4fh
    loop eje_x
    mov cx,0c6h
eje_y:
    pixel 9fh,cx,4fh
    loop eje_y
endm

plotOriginal macro buffer
LOCAL punto,salir
eje    
mov ax,inicioX
mov j,ax
mov ax,finX
mov i,ax
punto:

evaluarFuncion buffer,j
pixel x,y,4fh
mov bx,j
mov ax,i
cmp bx,ax
je salir
add bx,1
mov j,bx
jmp punto

salir:   
mov ah,10h
int 16h

mov ax,0003h
int 10h
endm

plotDerivada macro buffer
LOCAL punto,salir
eje    
mov ax,inicioX
mov j,ax
mov ax,finX
mov i,ax
punto:
evaluarDerivada buffer,j
pixel x,y,4fh
mov bx,j
mov ax,i
cmp bx,ax
je salir
add bx,1
mov j,bx
jmp punto

salir:   
mov ah,10h
int 16h

mov ax,0003h
int 10h
endm


plotIntegral macro buffer,c
LOCAL punto,salir
eje    
mov ax,inicioX
mov j,ax
mov ax,finX
mov i,ax
punto:
evaluarIntegral buffer,j,c
;mov ax,y
;parseString resultado
;print salto
;print resultado
pixel x,y,4fh
mov bx,j
mov ax,i
cmp bx,ax
je salir
add bx,1
mov j,bx
jmp punto

salir:   
mov ah,10h
int 16h

mov ax,0003h
int 10h
endm



;-----------------------CAPTURA DE DATOS Y ANALISIS DE DATOS-----------------------


getFecha macro buffer
    xor     ax, ax
    xor     bx, bx
    mov     ah, 2ah             
    int     21h

    mov     di,0
    mov     al,dl
    bcd buffer

    inc     di           
    mov     al, dh
    bcd buffer

    inc     di                
    mov buffer[di], 32h
    inc di  
    mov buffer[di], 30h 
    inc di 
    mov buffer[di], 32h
    inc di  
    mov buffer[di], 30h  


    endm

    getHora macro buffer
    xor     ax, ax
    xor     bx, bx
    mov     ah, 2ch
    int     21h

    mov     di,0
    mov     al, ch
    bcd buffer

    inc     di  
    mov     al, cl
    bcd buffer

    inc     di
    mov     al, dh
    bcd buffer


endm

bcd macro entrada     
    push dx
    xor dx,dx
    mov dl,al
    xor ax,ax
    mov bl,0ah
    mov al,dl
    div bl
    push ax
    add al,30h
    mov entrada[di], al        
    inc  di

    pop ax
    add ah,30h
    mov entrada[di], ah
    inc  di
    pop dx
endm

recorrer macro texto,buffer        ; <----------------INICIO HTML DINAMICO
LOCAL ciclo,error,fin
push di
xor di,di
mov di,0
dec di
dec si
ciclo:
inc si
inc di
cmp texto[di],ah
je fin
mov al,texto[di]
mov buffer[si],al
jmp ciclo

fin:
pop di
dec si
endm


functMostrar macro
print ing
getTexto ruta
crear ruta,handlerRuta
html reporteHtml
sobrantes reporteHtml,3501
escribir handlerRuta,reporteHtml,SIZEOF reporteHtml
cerrar handlerRuta
endm


html macro buffer,tipo
getFecha date
getHora time
xor ah,ah
mov ah,24h
mov si,0


recorrer style,buffer
recorrer f1,buffer
recorrer f2,buffer
recorrer f3,buffer
recorrer f4,buffer
recorrer f5,buffer
recorrer f6,buffer
recorrer f7,buffer

recorrer saltoHTML,buffer

recorrer f8,buffer

recorrer saltoHTML,buffer

recorrer abrirH3,buffer
recorrer date,buffer
recorrer cerrarH3,buffer

recorrer abrirH3,buffer
recorrer time,buffer
recorrer cerrarH3,buffer

recorrer saltoHTML,buffer

recorrer f9,buffer
recorrer abrirH3,buffer
recorrer otxt,buffer
recorrer fGuardar,buffer
recorrer cerrarH3,buffer

recorrer saltoHTML,buffer

recorrer f10,buffer
recorrer abrirH3,buffer
recorrer dtxt,buffer
recorrer fDerivada,buffer
recorrer cerrarH3,buffer

recorrer saltoHTML,buffer

recorrer f11,buffer
recorrer abrirH3,buffer
recorrer itxt,buffer
recorrer fIntegral,buffer
recorrer cerrarH3,buffer

recorrer saltoHTML,buffer

endm  



correrRuta macro entrada,buffer
local ciclo,fin
xor si,si
ciclo:
mov al,entrada[si+2]
cmp al,'@'
je fin
mov buffer[si],al
inc si
jmp ciclo
fin:
endm

setRuta macro buffer
local ciclo,fin,extension,formato,S0,S1
xor si,si
ciclo:
mov al,buffer[si]
cmp al,'.'
je S0
cmp al,0
je fin
inc si
jmp ciclo
;-------validar extension arq,hacer jmp al menu

S0:
mov al,buffer[si+1]
cmp al,'a'
jne extension
mov al,buffer[si+2]
cmp al,'r'
jne extension
mov al,buffer[si+3]
cmp al,'q'
jne extension

S1:
mov al,buffer[0]
cmp al,'@'
jne formato
mov al,buffer[1]
cmp al,'@'
jne formato
mov al,buffer[si+4]
cmp al,'@'
jne formato
mov al,buffer[si+5]
cmp al,'@'
jne formato
jmp fin

formato:
print error11
jmp Calculadora

extension:
print error10
jmp Calculadora

fin: 
correrRuta buffer,auxRuta
endm


getChar macro
mov ah,01h
int 21h
endm

getTexto macro buffer
LOCAL concat,fin
xor si,si

concat:
getChar
cmp al,0dh
je fin
mov buffer[si],al
inc si
jmp concat
fin:
mov al,'$'
mov buffer[si],al
endm


limpiar macro buffer,numBytes,pos
LOCAL ciclo
mov cx,numBytes
mov si,pos
ciclo:
moc buffer[si],24h
loop ciclo
endm


funcVacia macro
LOCAL fin,error
cmp fGuardar,'$'
je error
jmp fin
error:
print error8
jmp Menu
fin:
endm

parseString macro buffer
LOCAL negativo,S0,S1,S2,fin
xor si,si
xor cx,cx
xor bx,bx
xor dx,dx
mov dl,0ah
test ax,1000000000000000b
jnz negativo
jmp S1
negativo:
neg ax
mov buffer[si],45
inc si
jmp S1
S0:
xor ah,ah
S1:
div dl
inc cx
push ax
cmp al,00h
je S2
jmp S0
S2:
pop ax
add ah,30h
mov buffer[si],ah
inc si
loop S2
mov ah,24h
mov buffer[si],ah
inc si
fin:
endm

setCoordenadas macro inicio
LOCAL negativoX,negativoY,fin,nada,continuar

test ax,1000000000000000b
jnz negativoY

cmp ax,95 
jg nada
mov bx,5fh
sub bx,ax
mov y,bx

continuar:
xor bx,bx
mov bx,inicio
test bx,1000000000000000b
jnz negativoX
add bx,159
mov x,bx
jmp fin

nada:
mov y,0
mov x,0
jmp fin

negativoY:
neg ax

cmp ax,95 
jg nada
add ax,5fh
mov y,ax
jmp continuar


negativoX:
neg bx

mov ax,159
sub ax,bx
mov x,ax
fin:

endm




setOperadores macro buffer,op
LOCAL fin,ciclo,nada,S0,correcto
xor si,si
xor di,di
ciclo:
xor ax,ax
mov al,buffer[si]
cmp al,3bh           
je fin
cmp al,20h
je nada
cmp al,30h            
jge nada  
jmp S0

S0:
mov op[di],al
inc di
inc si
jmp ciclo

nada:
inc si
jmp ciclo

fin:
endm

setNumeros macro buffer,num
LOCAL fin,ciclo,limpia,nada,S0
xor si,si
xor di,di

ciclo:
xor ax,ax
xor bx,bx
mov al,buffer[si]
cmp al,3bh  
je fin
cmp al, 30h              ;----->0, 
jl nada               ;--------------Rango permitido
cmp al, 3ah              ;----->9,  
jl S0   
inc si     
jmp ciclo

S0:
sub al,30h
mov bl,0ah
mul bl
inc si

mov bl,buffer[si]
sub bl,30h
add ax,bx

inc si

mov num[di],ax    ;-------------tomar en cuenta que al ser arreglo dw, DI va de dos en dos

inc di
inc di
jmp ciclo

nada:
inc si
jmp ciclo

fin:
mov num[di],53h         
mov num[di+2],54h
mov num[di+4],4fh
mov num[di+6],50h
endm

;---------------------------------------------------
;---------------------esto ya------------------------
;---------------------------------------------------


correrNum macro num;--------resultado en ax
LOCAL ciclo,regresar,S0,S1,S2,S3,fin
mov num[di],ax
inc di
inc di
ciclo:
mov ax,num[di+2]
mov num[di],ax

cmp ax,53h
je S0
regresar:
inc di
inc di
jmp ciclo

;----------------------------si detecta SSTOP signfica que ahi debe de parar el traslado
S0:
mov ax,num[di+2]
cmp ax,53h
je S1
jmp regresar
S1:
mov ax,num[di+4]
cmp ax,54h
je S2
jmp regresar
S2:
mov ax,num[di+6]
cmp ax,4fh
je S3
jmp regresar
S3:
mov ax,num[di+8]
cmp ax,50h
je fin

fin:
endm


correrOp macro op ;--------resultado en ax
LOCAL ciclo,fin
ciclo:
mov al,op[si+1]
mov op[si],al

cmp al,24h
je fin
inc si
jmp ciclo
fin:
endm

modoCalculadora macro num,op,operacion
LOCAL ciclo,fin,continuar,S0,S1,S2,S3,S4,corrimiento,estados,siguiente
xor si,si
xor di,di

ciclo:
xor cx,cx
xor ax,ax
mov dl,op[si]
cmp dl,24h
jne continuar
jmp fin
continuar:

mov ax,num[di]      
mov cx,num[di+2]
mov dh,operacion
cmp dl,dh
jne siguiente
cmp dl,'+'
je S1
cmp dl,'-'
je S2
cmp dl,'/'
je S3
jmp S4
S1:
add ax,cx
jmp corrimiento
S2:
sub ax,cx
jmp corrimiento
S3:
xor dx,dx
div cx
jmp corrimiento
S4:
mul cx

corrimiento:

correrNum num
correrOp op
xor si,si           
xor di,di
jmp ciclo


siguiente:
inc si
inc di
inc di
jmp ciclo


fin:
endm





evaluarFuncion macro entrada,inicio ;-----------desde aqui ya debe de venir negativo el numero
LOCAL ciclo,exponente,fin,setNegativo,continuar,error,primCorregir,secCorregir,correcto
mov y,0
xor bx,bx
xor si,si
push bx
mov cont,0
ciclo:

xor dx,dx
xor bx,bx
xor ax,ax
xor cx,cx

mov ax,inicio
mov bx,inicio
mov cl,entrada[si+3]
cmp cl,31h
je primCorregir         ;--------en caso que el exponente sea 1
cmp cl,30h
je secCorregir          ;--------en caso que el exponente sea 0
sub cx,31h
exponente:
mul bx
;cmp dx,0                ;--------deja de ser 0 cuando el resultado es mayor a 65536 o 16^4
;jne error
loop exponente

xor bx,bx
mov bl,entrada[si]
cmp bl,'-'
je setNegativo
mov bl,entrada[si+1]
sub bl,30h
continuar:
mul bx
;cmp dx,0                ;--------deja de ser 0 cuando el resultado es mayor a 65536 o 16^4
;jne error
pop bx
add bx,ax
push bx
mov al,cont
add al,1
mov cont,al
mov ah,5
cmp cont,ah
je correcto
inc si
inc si
inc si
inc si
jmp ciclo


primCorregir:
mov cx,0
mov ax,inicio
mov bx,1
jmp exponente

secCorregir:
mov cx,0
mov ax,1
mov bx,1
jmp exponente

setNegativo:
mov bl,entrada[si+1]  
sub bl,30h
neg bx                 
jmp continuar

correcto:
pop bx
mov ax,bx
setCoordenadas inicio
jmp fin


error:
pop bx
xor bx,bx
xor ax,ax
mov y,0
mov x,0
fin:

endm

evaluarDerivada macro entrada,inicio
LOCAL ciclo,exponente,fin,setNegativo,continuar,error,primCorregir,secCorregir,correcto
mov y,0
xor bx,bx
xor si,si
push bx
mov cont,0
ciclo:

xor dx,dx
xor bx,bx
xor ax,ax
xor cx,cx

mov ax,inicio
mov bx,inicio
mov cl,entrada[si+4]
cmp cl,31h
je primCorregir         ;--------en caso que el exponente sea 1
cmp cl,30h
je secCorregir          ;--------en caso que el exponente sea 0
sub cx,31h
exponente:
mul bx
;cmp dx,0                ;--------deja de ser 0 cuando el resultado es mayor a 65536 o 16^4
;jne error
loop exponente

push ax

xor ax,ax
mov al,entrada[si+1]
sub al,30h
mov bx,10
mul bx

xor bx,bx
mov bl,entrada[si+2]
sub bl,30h
add ax,bx

xor bx,bx
mov bl,entrada[si]
cmp bl,'-'
je setNegativo
continuar:
mov bx,ax
pop ax
mul bx


;cmp dx,0                ;--------deja de ser 0 cuando el resultado es mayor a 65536 o 16^4
;jne error
pop bx
add bx,ax
push bx
mov al,cont
add al,1
mov cont,al
mov ah,4    
cmp cont,ah
je correcto
inc si
inc si
inc si
inc si
inc si
jmp ciclo


primCorregir:
mov cx,0
mov ax,inicio
mov bx,1
jmp exponente

secCorregir:
mov cx,0
mov ax,1
mov bx,1
jmp exponente

setNegativo:
neg ax
jmp continuar



correcto:
pop bx
mov ax,bx
setCoordenadas inicio
jmp fin


error:
pop bx
xor bx,bx
xor ax,ax
mov y,0
mov x,0
fin:
endm

evaluarIntegral macro entrada,inicio,c
LOCAL ciclo,exponente,fin,setNegativo,continuar,error,primCorregir,secCorregir,correcto
mov y,0
xor bx,bx
xor si,si
push bx
mov cont,0
ciclo:

xor dx,dx
xor bx,bx
xor ax,ax
xor cx,cx

mov ax,inicio
mov bx,inicio
mov cl,entrada[si+5]
cmp cl,31h
je primCorregir         ;--------en caso que el exponente sea 1
cmp cl,30h
je secCorregir          ;--------en caso que el exponente sea 0
sub cx,31h
exponente:
mul bx
;cmp dx,0                ;--------deja de ser 0 cuando el resultado es mayor a 65536 o 16^4
;jne error
loop exponente
xor bx,bx
mov bl,entrada[si]
cmp bl,'-'
je setNegativo
mov bl,entrada[si+1]
sub bl,30h
continuar:
mul bx
;cmp dx,0                ;--------deja de ser 0 cuando el resultado es mayor a 65536 o 16^4
;jne error
pop bx
add bx,ax
push bx
mov al,cont
add al,1
mov cont,al
mov ah,5
cmp cont,ah
je correcto
inc si
inc si
inc si
inc si
inc si
inc si
jmp ciclo


primCorregir:
mov cx,0
mov ax,inicio
mov bx,1
jmp exponente

secCorregir:
mov cx,0
mov ax,1
mov bx,1
jmp exponente

setNegativo:
mov bl,entrada[si+1]
sub bl,30h
neg bx
jmp continuar

correcto:
pop bx
mov ax,bx
add ax,c
setCoordenadas inicio
jmp fin


error:
pop bx
xor bx,bx
xor ax,ax
mov y,0
mov x,0
fin:

endm



funcDerivada macro entrada,buffer   
LOCAL ciclo,fin
xor di,di
mov cx,4
ciclo:
mov bh,entrada[di]         ;-----se guarda el signo
inc di
mov al,entrada[di]         ;-----coeficiente
inc di
inc di
mov bl,entrada[di]         ;-----exponente
inc di

sub al,30h                 ;
sub bl,30h                 ;----conversion a valor decimal 
                           ;

push bx        
mul bl

mov bl,0ah
div bl

add al,30h                 ;
add ah,30h                 ;----conversion a valor hexa
                           ;
mov buffer[si],bh
inc si
mov buffer[si],al
inc si
mov buffer[si],ah
inc si
mov buffer[si],'x'
inc si
pop bx
add bl,2fh
mov buffer[si],bl
inc si

loop ciclo

fin:
endm

funcIntegral macro entrada,buffer
LOCAL ciclo,fin
xor di,di
mov cx,5
ciclo:
mov bh,entrada[di]         ;-----se guarda el signo
inc di
mov al,entrada[di]         ;-----coeficiente
inc di
inc di
mov bl,entrada[di]         ;-----exponente
inc di

add bl,1                  


mov buffer[si],bh
inc si
mov buffer[si],al
inc si
mov buffer[si],'/'
inc si
mov buffer[si],bl
inc si
mov buffer[si],'x'
inc si
mov buffer[si],bl
inc si

loop ciclo

mov buffer[si],'+'
inc si
mov buffer[si],'c'
fin:
endm



entradaValida macro buffer
LOCAL ciclo,fin,S0,S0_,S1,S1_,S2,S3,S4,S5,S6,panico,fin,estado
xor si,si
xor cx,cx
dec si
ciclo:
xor ax,ax
inc si
mov al,buffer[si]
cmp al,24h
je estado
S0:
cmp al, 30h              ;----->0, 
jl S0_                 ;--------------Rango permitido
cmp al, 3ah              ;----->9,  
jl S1  
S0_:           
jmp error


S1:
inc si
mov al,buffer[si]
cmp al, 30h              ;----->0, 
jl S1_                 ;--------------Rango permitido
cmp al, 3ah              ;----->9,  
jl S2     
S1_:        
jmp error

S2:
inc si
mov al,buffer[si]
cmp al, 3bh       
je estado                   
cmp al, 20h      
je S3             
jmp error


S3:   
inc si
mov al,buffer[si]    
cmp al, 2fh
je S4    
cmp al, 2ah
je S4       
cmp al, 2dh
je S4      
cmp al, 2bh    
je S4             
jmp error


S4:
inc si
mov al,buffer[si]
cmp al, 20h      
je ciclo             
jmp error


error:
mov cx,1
mov guardaError,al
print error9
print guardaError
panico:             ;-------------lo regresa al inicio y se recupera si detecta un numero o '$'
cmp al,24h
je estado
jmp ciclo

estado:
cmp cx,1
je Calculadora

fin:
print salto
print msg4
endm

funcValida macro mensaje,buffer,info
LOCAL ciclo,fin,error,valid,S0,S1,S2,S3,valores,tipo
ciclo:
print mensaje
push si
getTexto arreglo
pop si
xor di,di
S0:
cmp arreglo[di], '+'
je S2
cmp arreglo[di], '-'
je S2
mov signo,'+'

S1:
cmp arreglo[di], 30h     ;----->0, 
jl error                 ;--------------Rango permitido
cmp arreglo[di], 40h     ;----->1,  
jl S3 
jmp error 

S2:
mov al,arreglo[di]
mov signo,al
inc di
jmp S1
    
S3:
mov al,arreglo[di]
mov numero,al
inc di
cmp arreglo[di],'$'
jne error

valores:
xor ax,ax
mov al,signo
mov buffer[si],al
inc si
mov ah,numero
mov buffer[si],ah
inc si


tipo:
mov al,info
mov buffer[si],'x'
inc si
mov buffer[si],al
inc si
jmp fin

error:
print error7
jmp ciclo

fin:
endm

rangoMayor macro
LOCAL fin
mov ax,inicioX
mov bx,finX
cmp bx,ax
jg fin

print error12
jmp Graficar
fin:
endm

rangoValida macro mensaje,buffer
LOCAL ciclo,fin,error,S0,S1,S2,S3,S4,correcto,negativo,primRet,secRet,incremento
ciclo:
print mensaje
getTexto arreglo
xor di,di
S0:
cmp arreglo[di], '+'
je S2
cmp arreglo[di], '-'
je S2
mov signo,'+'

S1:
cmp arreglo[di], 30h     ;----->0, 
jl error                 ;--------------Rango permitido
cmp arreglo[di], 40h     ;----->1,  
jl S4
jmp error 

S2:
mov al,arreglo[di]
mov signo,al
inc di
jmp S1
    
S3:
inc di
cmp arreglo[di],'$'
jne S4
jmp correcto


S4:
inc di
cmp arreglo[di], 30h     ;----->0, 
jl error                 ;--------------Rango permitido
cmp arreglo[di], 40h     ;----->1,  
jl S3 
jmp error 

correcto:
xor ax,ax
xor bx,bx
xor si,si
cmp arreglo[si], '+'
je incremento
cmp arreglo[si], '-'
je incremento

primRet:
mov al,arreglo[si]
sub al,30h
mov bx,10
mul bx
xor bx,bx
mov bl,arreglo[si+1]
sub bl,30h  
add ax,bx

cmp signo,'-'
je negativo
secRet:
mov buffer,ax
jmp fin

negativo:
neg ax
jmp secRet

incremento:
inc si
jmp primRet

error:
print error7
jmp ciclo

fin:
endm



;--------------------------------ANALISIS DE DATOS---------------------

