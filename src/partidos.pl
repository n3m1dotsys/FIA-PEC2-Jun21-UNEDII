%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   partidos.pl   -   Cosas relacionadas con los partidos
%
% author: Martín "n3m1.sys" Romera Sobrado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definición de los partidos principales
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nombre(up, 'Unidas Podemos').
nombre(mm, 'Más Madrid').
nombre(psoe, 'PSOE').
nombre(cs, 'Ciudadanos').
nombre(pp, 'Partido Popular').
nombre(vox, 'VOX').

izquierda(up). 
izquierda(mm). 
izquierda(psoe).

derecha(cs).
derecha(pp). 
derecha(vox).    

pedir_escanos(Partido) :- 
    write('Introduce el número de escaños que ha obtenido '),
    nombre(Partido, S),
    write(S),
    nl,
    read(X),
    assert(escanos(Partido, X)).

% NOTE: En caso de que algún partido minoritario saque algún escaño el 4 de 
%       mayo se añadirá aquí abajo.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculo de escaños totales de un grupo de partidos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
escanos_totales([Partido], S) :-
    escanos(Partido,X),
    S is X.

escanos_totales([Partido | Partidos], S) :- 
    escanos(Partido, X),
    escanos_totales(Partidos, Y),
    S is X + Y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comprobación de que todos los partidos son del mismo espectro político
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
todos_derecha([Partido | Partidos]) :-
    derecha(Partido),
    todos_derecha(Partidos).

todos_derecha([Partido]) :-
    derecha(Partido).

todos_izquierda([Partido | Partidos]) :-
    izquierda(Partido),
    todos_izquierda(Partidos).

todos_izquierda([Partido]) :- 
    izquierda(Partido).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ordenar los partidos según sus escaños
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
