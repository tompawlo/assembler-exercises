.model medium
.stack 100h

printStr macro aString
	mov ah, 9h
	lea dx, aString
	int 21h
	endm
printnl macro
	printStr newLine
endm
printChar macro aChar
	mov ah, 2h
	mov dl, aChar[bx]
	int 21h
	endm
printChar0 macro aChar
	mov ah, 2h
	mov dl, aChar
	int 21h
	endm
printNum macro aNum
	mov ah, 2h
	mov dl, aNum
	add dl, '0'
	int 21h
	endm
prinTab macro aTab
	push cx
	mov bx, 0
	mov cx, 5
	mov ah, 2h
	wypiszTab:
		mov dl, aTab[bx]
		int 21h
		inc bx
		loop wypiszTab
	pop cx
	endm

readCh macro aValue
	mov ah, 1h
	int 21h
	mov aValue, al
	endm
ujawnij macro aValue
	mov zakodowane[bx],dl
	endm
begin macro
	mov ax, @data
	mov ds, ax
	endm
exit macro
	mov ah, 04ch
	int 21h
	endm
.data
	msg db 'Gra w wisielca!',10,13,'$'
	litery db 'h','a','s','l','o'
	zakodowane db '*','*','*','*','*'
	posZycia db 'Posiadane zycia: $'
	zycia db 5h
	odgadniete db 0h
	wprowadz db 'Wprowadz litere: $'
	gratulacje db 'Odgadnieto haslo: $'
	wpisano db 'Wpisano: $'
	dobra_lit db 'Dobra litera$'
	litera db 'a'
	koniec db 'Koniec Gry!$'
	newLine DB 10,13,'$'
	
.code
main proc
	begin
	printStr msg ; Powitaj gracza
	
	
	mov cx, 5
	petla:					; Podaj litere
		printStr posZycia
		printNum zycia
		printnl
		
		prinTab zakodowane
		printnl
		
		printStr wprowadz
		readCh litera
		printnl
		
		printStr wpisano
		printChar0 litera
		printnl
		push cx
		mov cx, 5
		mov bx, 0
		sprawdz:
			mov dl, litera
			cmp dl, litery[bx]
			je pasuje
			inc bx
			cmp bx, 5
			jz nie_pasuje
			loop sprawdz
		pasuje:
			printStr dobra_lit
			;printChar0 litera
			mov dl, litera
			mov zakodowane[bx], dl
			inc zycia
			inc odgadniete
			printnl
		nie_pasuje:
			dec zycia
			printnl
		pop cx
		dec cx
		cmp odgadniete, 5
		jz wyjscie
		cmp zycia, 0
		jz wyjscie
		jmp petla
		
	wyjscie:
		mov bx, 0
		mov cx, 5
		mov ah, 2h
	wypisz_haslo:
		mov dl, zakodowane[bx]
		int 21h
		inc bx
		loop wypisz_haslo
		printnl
		printStr koniec
		printnl
	exit
	main endp
end main