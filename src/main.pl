%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%   main.pl   -   Programa a ejecutar                                          %
%                                                                              %
% author: Martín "n3m1.sys" Romera Sobrado                                     %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- [partidos, pactos, comentarios, util].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Introducir los resultados                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init :-
    pedir_escanos(up),
    pedir_escanos(mm),
    pedir_escanos(psoe),
    pedir_escanos(cs),
    pedir_escanos(pp),
    pedir_escanos(vox),
    assert(lista_partidos([])),
    forall(con_escanos(X), anadir_partido(X)),
    lista_partidos(L),
    quicksort(L,R),
    cabeza(R,Ganador),
    ganador(Ganador),
    nl,
    write('Para comenzar a calcular pactos, lanza el comando "pactometro."').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Empezar a calcular escanos                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pactometro :- 
    assert(lista_pacto([])),
    write('Cuantos partidos va a formar el pacto: '), nl,
    read(N),
    pedir_partido(N),
    lista_pacto(L),
    valorar_pacto(L),
    retract(lista_pacto(_)).

pedir_partido(0) :- !.
pedir_partido(N) :-
    write(N),
    write(' restantes.'),nl,
    write('Introduce un partido de usando el siguiente código: '),nl,
    write('up : Unidas Podemos'),nl,
    write('mm : Más Madrid'),nl,
    write('psoe : PSOE'),nl,
    write('cs : Ciudadanos'),nl,
    write('pp : Partido Popular'),nl,
    write('vox : VOX'),nl,
    read(X),
    (X == up; X == mm; X == psoe; X == cs; X == pp; X == vox),
    lista_pacto(L),
    forall(lista_pacto(L),retract(lista_pacto(L))),
    append(L,[X],R),
    assert(lista_pacto(R)),
    I is N - 1,
    pedir_partido(I);
    (X \= up, X \= mm, X \= psoe, X \= cs, X \= pp ,X \= vox),
    write('(!): Entrada invalida'),
    pedir_partido(N).

