%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%   util.pl   -   Utilidades                                                   %
%                                                                              %
% author: Martín "n3m1.sys" Romera Sobrado                                     %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cabeza de la lista                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cabeza([L|_],L).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcula la máxima distancia entre los partids de una lista de partidos       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_distancia(Partidos, X) :-
    sort_izqder(Partidos, IzqDer),
    sort_derizq(Partidos, DerIzq),
    cabeza(IzqDer, MasIzq),
    cabeza(DerIzq, MasDer),
    espectro(MasIzq, EspIzq),
    espectro(MasDer, EspDer),
    X is EspDer - EspIzq.

sort_izqder(L,S) :- 
    permutation(L,S),
    izqder(S),!.

sort_derizq(L,S) :-
    permutation(L,S),
    derizq(S),!.

izqder([]).
izqder([_]).
izqder([X,Y|T]) :-
    espectro(X,EX),
    espectro(Y,EY),
    EX < EY,
    izqder([Y|T]).

derizq([]).
derizq([_]).
derizq([X,Y|T]) :-
    espectro(X,EX),
    espectro(Y,EY),
    EX > EY,
    derizq([Y|T]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elimina los partidos que no han obtenido escanos de un grupo de partidos     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eliminar_sin_escanos(Partidos, Resultado) :-
    assert(partidos(Partidos)),
    forall(sin_escanos(X), eliminar(X)),
    partidos(Resultado),
    retract(partidos(Resultado)).

eliminar(X) :-
    partidos(Partidos),
    retract(partidos(Partidos)),
    eliminarTodos(X, Partidos, R),
    assert(partidos(R)).

eliminarTodos(_, [], []).
eliminarTodos(X, [X|Xs], Y) :-
    eliminarTodos(X, Xs, Y).
eliminarTodos(X, [T|Xs], [T|Y]) :-
    dif(X, T),
    eliminarTodos(X, Xs, Y).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elimina los partidos repetidos en un grupo de partidos                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eliminar_repes([],[]).

eliminar_repes([H | T], List) :-    
     member(H, T),
     eliminar_repes(T, List),!.

eliminar_repes([H | T], [H|T1]) :- 
      \+member(H, T),
      eliminar_repes(T, T1),!.
