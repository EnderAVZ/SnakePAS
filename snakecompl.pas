program snake;

uses crt;

var
	speed:		integer; // Velocidad de la serpiente
	diff:		char; // Diferencia
	score:		integer; // Puntuacion
	quit:		boolean; // Reinicia el programa
	gamemode:	integer; // Selecciona el modo
	snakecolor: integer; // Color de la serpiente
	CChoice:	char; // Elección de color

	procedure startscreen(); // La primera pantalla que aparecera
	var
		SSx:		integer; // Coordenada X
		SSy:		integer; // Coordenada Y
		SSybool:	boolean; // Verifica que SSy no este en el titulo
		
begin // Comienza en la pantalla de inicio
		repeat // Comienza a imprimir
			gotoxy(35 , 12);
			writeln('SNAKE');
			gotoxy(32 , 13);
			writeln('PRESS ENTER');
		repeat // Comienza a encontrar un lugar aleatorio
				SSybool:=FALSE;
				SSx:=random(79)+1;
				SSy:=random(24)+1;
				if (SSy>14) OR (SSy<11) then SSybool:=true
		until SSybool=TRUE; // Termina de encontrar un lugar aleatorio
			gotoxy(SSx,SSy);
			textcolor(random(9)+8);
			write('o');
			delay(10)
		until keypressed // Finaliza impresion
	
end;
	


procedure MOVE(MVEspeed:integer; var MVElink:integer; MVEmode:integer); // Procedimiento principal, basicamente es todo el juego del snake
	var
// M = >
// K = <
// H = V
// P = ^
        MVEquit:		boolean; // paz
        MVEX:			array[1..100] of integer; // x
        MVEY:			array[1..100] of integer; // y
		MVEXDOT:		array[1..3] of integer; // x para obtener
		MVEYDOT:		array[1..3] of integer; // y para obtener
		MVEBX:			array[1..3] of integer; // X de bombas
		MVEBY:			array[1..3] of integer; // Y de bombas
		MVEkey:			char; // Direccion
		MVEi:			integer; // Cuenta
		MVEprev:		char; // Copia de seguridad para la direccion
		MVEtally:		integer; // Realiza un seguimiento del movimiento de las bombas
		MVEbombnum:		integer; // Número de bombas lanzadas
        MVEsec:			integer; // Segundos
        
begin // Comenzar MVE
		MVEquit:=false;
		MVElink:=4;
		cursoroff;
		MVEtally:=0;
		MVEbombnum:=1;
		MVEX[1]:=30;
		MVEY[1]:=15;
		MVEsec:=5;
		MVEkey:='M';
		MVEprev:=MVEkey;
		
		for MVEi:=1 to 3 do
begin //Rellena los puntos aleatorios para el segmento
			MVEXDOT[MVEi]:=random(80)+1;
			MVEYDOT[MVEi]:=random(25)+1;
			MVEBX[MVEi]:=random(80)+1;
			MVEBY[MVEi]:=1
end; // Finaliza el relleno de puntos aleatorios
		repeat // Comienza el ciclo del juego
			repeat // Empieza a moverse
			
				snakecolor:=random(9)+8;
				for MVEi:=MVElink downto 2 do
begin // Se mueven los segmentos
					MVEX[MVEi]:=MVEX[MVEi-1];
					MVEY[MVEi]:=MVEY[MVEi-1]
end; // Finalizacion de MVE
				
case MVEkey of // Cambiar posicion de cabeza
					'M': MVEX[1]:=MVEX[1]+1;
					'K': MVEX[1]:=MVEX[1]-1;
					'H': MVEY[1]:=MVEY[1]-1;
					'P': MVEY[1]:=MVEY[1]+1;
					'q': MVEquit:=true;
			else
					MVEkey:=MVEprev; // Evita pausar el juego
case MVEkey of // Cambiar pos de cabeza
				            'M': MVEX[1]:=MVEX[1]+1;
				            'K': MVEX[1]:=MVEX[1]-1;
							'H': MVEY[1]:=MVEY[1]-1;
				            'P': MVEY[1]:=MVEY[1]+1;
				            'Q': MVEquit:=true
end // finaliza el case interno
end; // finaliza el case externo
				
				for MVEi:=1 to 3 do
begin //Comience a colocar puntos al azar
					gotoxy(MVEXDOT[MVEi],MVEYDOT[MVEi]);
					textcolor(yellow);
					write('o')
end; // puntos de lugar final
				
				for MVEi:=1 to 3 do
begin // Compruebe si la cabeza de la serpiente ha tocado un punto
					if (MVEX[1]=MVEXDOT[MVEi]) AND (MVEY[1]=MVEYDOT[MVEi]) then
begin // empezar si
						MVElink:=MVElink+1;
						MVEsec:=5;
						MVEXDOT[MVEi]:=random(80)+1;
						MVEYDOT[MVEi]:=random(25)+1
end // fin interno si
end; // fin externo si
				
				MVEprev:=MVEkey; //Evita la pausa del juego al enviar spam a las teclas
				
				if (MVEX[1]=MVEX[3]) AND (MVEY[1]=MVEY[3]) then
begin // Evita que el usuario choque accidentalmente con el segmento trasero
			case MVEkey of // Comprueba si se ha pulsado la tecla opuesta
						'M': begin
								MVEkey:='K';
								MVEX[1]:=MVEX[1]-2
								end;
						'K': begin
								MVEkey:='M';
								MVEX[1]:=MVEX[1]+2
								end;
						'H': begin
								MVEkey:='P';
								MVEY[1]:=MVEY[1]+2
							 end;
						'P': begin
								MVEkey:='H';
								MVEY[1]:=MVEY[1]-2
							 end					
end // Fin del case
end; // Control de prevención de finalización
				
				for MVEi:=2 to MVElink do
begin // Compruebe si la cabeza ha golpeado el segmento
					if (MVEX[1]=MVEX[MVEi]) AND (MVEY[1]=MVEY[MVEi]) then MVEquit:=TRUE
end; // control de la cabeza final
				
				for MVEi:=2 to MVElink do
begin // Escribir segmentos
					gotoxy(MVEX[MVEi],MVEY[MVEi]);
					textcolor(snakecolor);
					write('o')
end; // termina los segmentos
				
				gotoxy(MVEX[1],MVEY[1]);
				textcolor(snakecolor);
				write('o'); // escribir cabeza
				
				if MVEmode=1 then // MODO BOMBA
				begin // SUELTA BOMBAS!
				        MVEtally:=MVEtally+1;

					for MVEi:=1 to 3 do
					begin // Empieza a escribir bombas
						gotoxy(MVEBX[MVEi],MVEBY[MVEi]);
						textcolor(lightred);
						write('o')
					end; // Deja de escribir bombas

					for MVEi:=1 to MVEbombnum do
					begin // Cambia la posicion de la bomba
						MVEBY[MVEi]:=MVEBY[MVEi]+1;
						if MVEBY[MVEi]=25 then
						begin // Restablecer la posición de la bomba
							MVEBY[MVEi]:=1;
							MVEBX[MVEi]:=random(80)+1
						end // Posición final de la bomba
					end; // Finalizar el cambio de posición de la bomba

					if MVEtally=10 then
					begin // Le dice a otras bombas que comiencen a caer
						MVEbombnum:=MVEbombnum+1;
						if MVEbombnum=4 then MVEbombnum:=3;
					        MVEtally:=0
					end; // Poner fin a la bomba num

					for MVEi:=1 to MVElink do
					begin // Compruebe si la serpiente golpeó la bomba
						if (MVEX[MVEi]=MVEBX[1]) AND (MVEY[MVEi]=MVEBY[1]) then MVEquit:=TRUE;
						if (MVEX[MVEi]=MVEBX[2]) AND (MVEY[MVEi]=MVEBY[2]) then MVEquit:=TRUE;
						if (MVEX[MVEi]=MVEBX[3]) AND (MVEY[MVEi]=MVEBY[3]) then MVEquit:=TRUE
					end // Finalizar chequeo
				end; // Finaliza el modo bomb

				if MVEmode=3 then // MODO TIEMPO
				begin // Temporizador de inicio
					MVEtally:=MVEtally+1;
					if MVEtally=20 then
					begin // Cambia segundo
						MVEsec:=MVEsec-1;
						MVEtally:=1;
					end; // Finalizacion del cambio de segundo
					if MVEsec=0 then MVEquit:=TRUE;
					gotoxy(40,2);
					Textcolor(lightcyan);
					writeln(MvEsec)
				end; // Fin del tiempo
					
				if (MVEX[1]=81) or (MVEX[1]=0) or (MVEY[1]=0) or (MVEY[1]=26) then
				begin // Compruebe si la serpiente ha golpeado la pared de la pantalla
					if (MVEmode=2) or (MVEmode=3) then // MODO DE BUCLE
					begin // Comenzar los comandos del modo de bucle
						case MVEX[1] of // Cambiar x pos de cabeza
							81: MVEX[1]:=1;
							0: MVEX[1]:=80
						end; // Finaliza x pos 
						case MVEY[1] of // Cambiar y pos de cabeza
							26: MVEY[1]:=1;
							0: MVEY[1]:=25
						end // Finaliza y pos
					end // Finaliza el modo bucle
					else
						MVEquit:=TRUE;
				end; // Finaliza chequeo
				delay(MVEspeed);
				clrscr;
			until keypressed or MVEquit; // Finaliza movimiento
			textcolor(yellow);
			if MVEquit=TRUE then writeln('GAME OVER               Press Enter');
			MVEkey:=readkey;
		until MVEquit; // Fin del juego
	end; // Fin MOVE



	procedure restart(var RSTquit: boolean); // Determina si se llama a un reinicio
	var
		RSTchar:		char;// Y o N
	begin // Comenzar a reiniciar
		RSTquit:= false;
		repeat // Espera una entrada válida
			writeln('Te gustaria volver a jugar?');
			write('Escriba y para reiniciar o n para salir: ');
			readln(RSTchar);
			if (RSTchar='n') or (RSTchar='N') then RSTquit:=TRUE;
			clrscr
		until (RSTchar='y') or (RSTchar='Y') or RSTquit // Sale en una entrada valida
	end; // Fin del reinicio



	procedure SCOREME(SEscore: integer; SEdiff: char); // Muestra puntajes altos
        var
		SEfile: 		text; // Archivo que contiene partituras
		SElist: 		array[1..7] of integer; // Puntuaciones altas
		SEi: 			integer; // Cuenta
		SEj: 			integer; // Tambien cuenta
		SEh: 			integer; // Tambien tambien cuenta
		SEname: 		array[1..7] of string; // nombre de los poseedores de la puntuación más alta
		SEtemp: 		integer; // Variable de marcador de posición
		SEuser: 		string; // Nombre del usuario
		SEhold: 		string; // Marcador de posición de nombre
                SEhigh: 		boolean; // Determina si hay un nuevo puntaje alto
	begin
		SEj:=1;
		SEh:=1;
		SEhigh:=FALSE;
		reset(SEfile);
		for SEi:=1 to 10 do
		begin // Empezar a leer archivos
			if (SEi mod 2 = 1) then
			begin // Obtener nombres
				readln(SEfile,SEname[SEj]);
				SEj:=SEj+1
			end // Finalizacion de nombres
			else
			begin // Obtener puntajes
				readln(SEfile,SElist[SEh]);
				SEh:=SEh+1
			end // Finalizacion de los puntajes
		end; // Fin de la lectura
		close(SEfile);
		for SEi:=1 to 5 do
		begin // Comience control alto
			if SEscore>=SElist[SEi] then SEhigh:=TRUE
		end; // Fin del control alto
		if SEhigh=TRUE then
		begin // Permitir al usuario ingresar nombre
			writeln('NUEVO RECORD!');
			write('INGRESA TU NOMBRE: ');
			readln(SEuser)
		end; // entrada final
		for SEi:=1 to 5 do
		begin // Empezar a cambiar puntuaciones
			if SEscore>SElist[SEi] then
			begin // Cambia la posición si hay una nueva puntuación alta
				SEtemp:=SElist[SEi];
				SElist[SEi]:=SEscore;
				SEscore:=SEtemp;
				SEhold:=SEname[SEi];
				SEname[SEi]:=SEuser;
				SEuser:=SEhold
			end // Cambio final
		end; // Cambios en la puntuacion final
		SEj:=1;
		SEh:=1;
		rewrite(SEfile);
		for SEi:=1 to 10 do
		begin // Reescribir el archivo de puntuación más alta
			if (SEi mod 2 = 1) then
			begin // escribir nombre
				writeln(SEfile,SEname[SEj]);
				SEj:=SEj+1
			end // nombre finalizado
			else
			begin // escribe puntaje
				writeln(SEfile,SElist[SEh]);
				SEh:=SEh+1
			end // puntaje finalizado
		end; // Terminar de escribir
		close(SEfile);
		textcolor(lightgray);
		write('PUNTUACIONES ALTAS PARA ');
		case diff of // Escribir la partitura elegida
			'F','f': write('FACIL');
			'M','m': write('MEDIO');
			'D','d': write('DIFICIL');
			'B','b': write('BOMBA');
			'E','e': write('EN BUCLE');
			'C','c': write('CONTRARRELOJ');
		end; // Terminar de escribir
		writeln(' MODO');
		writeln;
		for SEi:=1 to 5 do
		begin // Empezar a mostrar puntuaciones altas
			textcolor(lightgray);
			write(SEi,':   ',SEname[SEi],' - ');
			textcolor(yellow);
			writeln(SElist[SEi])
		end // Finalizar visualización de puntuación más alta
	end;



begin // Empezar PRINCIPAL
	repeat // Comienza la repetición principal
		randomize;
		snakecolor:=10;
		score:=0;
		speed:=0;
		gamemode:=0;
		cursoroff;
		startscreen;
		clrscr;
		textcolor(lightgray);
		writeln('Presiona enter');
		readln;
		repeat; // Pantalla principal, indicaciones de dificultad
			clrscr;
			gotoxy(15,1);
			textcolor(lightgreen);
			writeln('SNAKE');
			gotoxy(12,2);
			writeln('ENDERSON VELASQUEZ');
			gotoxy(1,5);
			textcolor(yellow);
			writeln('Bienvenido al juego del snake!');
			textcolor(lightgray);
			write('Controlaras una serpiente');
			textcolor(snakecolor);
			write('oooo ');
			writeln;
			textcolor(lightgray);
			write('trata de comer todos los puntos ');
			textcolor(yellow);
			write('o');
			writeln;
			textcolor(lightgray);
			writeln('Cada punto que comas hara que tu serpiente sea mas larga.');
			write('En el modo bomba, debes evitar que caigan bombas. ');
			textcolor(lightred);
			write('o');
			textcolor(lightgray);
			writeln;
			writeln('En el modo de bucle y el modo de tiempo, solo pierdes golpeandote a ti mismo, no a las paredes.');
			writeln('En el modo contrarreloj, tienes 5 segundos para conseguir un punto.');
			writeln('Controlas a tu serpiente con las teclas de flecha.');
			writeln('Perderas el juego si tu serpiente golpea el borde de la pantalla.');
			writeln('O si la serpiente se golpea a si misma.');
			writeln('Puedes salir del juego en cualquier momento presionando la tecla key.');
			writeln('Tu puntuacion se mostrara al final del juego.');
			writeln;
			textcolor(yellow);
			writeln('SELECCIONA TU DIFICULTAD');
			writeln('Facil, Medio, Dificil, Bomba, En Bucle, o Contrarreloj?');
			writeln('Escriba la opcion para cambiar el color de la serpiente.');
			cursoron;
			readln(diff);
			case diff of // Opciones para modos de juego
				'F','f': speed:=100;
				'M','m': speed:=70;
				'D','d': speed:=40;
				'B','b': begin // Misma velocidad que medio, lanza bombas
						speed:=70;
						gamemode:=1
					 end; // Bomba finalizada
				'E','e': begin // Velocidad superior a la media, sin colisión
						speed:=50;
						gamemode:=2
					 end; // bucle final
				'O','o': begin // Elegir color
						clrscr;
						writeln('Selecciona el color de tu snake!');
						writeln;
						writeln;
						textcolor(lightmagenta);
						writeln('	Purple');
						textcolor(lightgreen);
						writeln('	Green');
						textcolor(red);
						writeln('	Red');
						textcolor(yellow);
						writeln('	Yellow');
						textcolor(white);
						writeln('	White');
						textcolor(lightcyan);
						writeln('	Blue');
						writeln;
						textcolor(lightgray);
						write('Haz tu seleccion: ');
						readln(CChoice);
						case CChoice of // Eleccion de color
							'P','p': snakecolor:=13;
							'G','g': snakecolor:=10;
							'R','r': snakecolor:=4;
							'Y','y': snakecolor:=14;
							'W','w': snakecolor:=15;
							'B','b': snakecolor:=11;
						end; // Finaliza la eleccion de color
					 end; // Final elige color
				'T','t': begin // Velocidad superior a la media, límite de tiempo, sin colisión
						speed:=50;
						gamemode:=3
					 end
			end // Terminar opciones
		until (speed>0); // Se repite hasta que se selecciona un modo de juego válido
		MOVE(speed,score,gamemode);
		cursoron;
		clrscr;
		textcolor(lightgray);
		write('Puntaje: ');
		textcolor(yellow);
		write(score);
		writeln;
		textcolor(lightgray);
		write('Dificultad: ');
		textcolor(yellow);
		case diff of // Dificultad de escritura
			'E','e': write('FACIL');
			'M','m': write('MEDIO');
			'H','h': write('DIFICIL');
			'B','b': write('BOMBA');
			'L','l': write('BUCLE');
			'T','t': write('TIEMPO DE ATAQUE')
		end; // Terminar con la dificultad de escritura
		writeln;
		writeln;
		SCOREME(score,diff);
		writeln;
		restart(quit);
	until quit; // Fin del bloque de repetición principal, el programa terminará
end. // FIN PRINCIPAL.
