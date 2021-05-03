%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%   partidos.pl   -   Cosas relacionadas con los partidos                      %
%                                                                              %
% author: Martín "n3m1.sys" Romera Sobrado                                     %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definición de los partidos principales                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nombre(up, 'Unidas Podemos').
nombre(mm, 'Más Madrid').
nombre(psoe, 'PSOE').
nombre(cs, 'Ciudadanos').
nombre(pp, 'Partido Popular').
nombre(vox, 'VOX').

nombredet(up, 'Unidas Podemos').
nombredet(mm, 'Más Madrid').
nombredet(psoe, 'el PSOE').
nombredet(cs, 'Ciudadanos').
nombredet(pp, 'el Partido Popular').
nombredet(vox, 'VOX').

candidato(up, 'Pablo Iglesias').
candidato(mm, 'Mónica García').
candidato(psoe, 'Ángel Gabilondo').
candidato(cs, 'Edmundo Bal').
candidato(pp, 'Isabel Díaz Ayuso').
candidato(vox, 'Rocío Monasterio').

izquierda(up). 
izquierda(mm). 
izquierda(psoe).

derecha(cs).
derecha(pp). 
derecha(vox).    

% 1 sería más a la izquierda y 6 más a la derecha
espectro(up, 1).
espectro(mm, 2).
espectro(psoe, 3).
espectro(cs, 4).
espectro(pp, 5).
espectro(vox, 6).

% TODO: En caso de que algún partido minoritario saque algún escaño el 4 de 
%       mayo se añadirá.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Los partidos se encuentran en el mismo espectro o no                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mismo_espectro(Partidos) :- 
    todos_derecha(Partidos); 
    todos_izquierda(Partidos).

distinto_espectro(Partidos) :- not(mismo_espectro(Partidos)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Soliciitar resultado de un partido                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pedir_escanos(Partido) :- 
    write('Introduce el número de escaños que ha obtenido '),
    nombre(Partido, S),
    write(S),
    nl,
    read(X),
    assert(escanos(Partido, X)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reiniciar resultados                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
reiniciar_escanos :-
    forall(escanos(X,Y),retract(escanos(X,Y))),
    retract(lista_partidos(_)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dice si un partido tiene o no escaños                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sin_escanos(Partido) :-
    escanos(Partido,0).

con_escanos(Partido) :-
    escanos(Partido,X),
    X >= 1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lista los partidos con escanos                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
anadir_partido(P) :-
    lista_partidos(X),
    retract(lista_partidos(X)),
    append(X,[P],L),
    assert(lista_partidos(L)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ordenado rápido de partidos                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: Esto debería estar en util.pl pero por algún motivo no quiere funcionar
%       ahí
quicksort([P|Ps], R) :-
    partition(Ps,P,Izq,Der),
    quicksort(Izq,IR),
    quicksort(Der,DR),
    append(IR,[P|DR],R).

quicksort([],[]).

partition([P|Ps],Pivot,[P|IR],DR) :-
    escanos(P,PX),
    escanos(Pivot,PivotX),
    PX > PivotX,!,
    partition(Ps,Pivot,IR,DR).

partition([P|Ps],Pivot,IR,[P|DR]) :-
    escanos(P,PX),
    escanos(Pivot,PivotX),
    (PX < PivotX; PX == PivotX),!,
    partition(Ps,Pivot,IR,DR).

partition([],_,[],[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculo de escaños totales de un grupo de partidos                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
escanos_totales([Partido|[]], S) :-
    escanos(Partido,X),
    S is X,!.

escanos_totales([Partido | Partidos], S) :- 
    escanos(Partido, X),
    escanos_totales(Partidos, Y),
    S is X + Y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comprobación de que todos los partidos son del mismo espectro político       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
todos_derecha([Partido | Partidos]) :-
    derecha(Partido),
    todos_derecha(Partidos).

todos_derecha(Partido) :-
    derecha(Partido).

todos_izquierda([Partido | Partidos]) :-
    izquierda(Partido),
    todos_izquierda(Partidos).

todos_izquierda([Partido]) :- 
    izquierda(Partido).
