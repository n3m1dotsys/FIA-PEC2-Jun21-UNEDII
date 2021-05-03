%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                              %
%   comentarios.pl   -   Contiene los comentarios del periodista               %
%                                                                              %
% author: Martín "n3m1.sys" Romera Sobrado                                     %
%                                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- [partidos].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Listar partidos                                                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
listar_partidos([]).
listar_partidos([P]) :-
    nombre(P,N),
    write('y '),
    write(N).

listar_partidos([P|Ps]):-
    nombre(P,N),
    write(N),
    write(', '),
    listar_partidos(Ps).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comentario de quien ha ganado las elecciones                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ganador(Partido) :-
    escanos(Partido, X),
    PRG is X mod 3,
    nombredet(Partido, Nombre),
    candidato(Partido, Candidato),
    % Selección de frase pseudoaleatoria según el número de escaños
    (
        (PRG == 0,
            write('Con estos resultados, '),
            write(Candidato),
            write(' habría ganado las elecciones.'),
            !
        );
        (PRG == 1,
            write('Ahora mismo con los resultados que tenemos, '),
            write(Nombre),
            write(' tendría mayoría parlamentaria en la Asamblea de Madrid.'),
            !
        );
        (PRG == 2,
            write(Nombre),
            write(' con '),
            write(X),
            write(' escaños, se sitúa como primera fuerza parlamentaria.'),
            !
        )
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comentario si un conjunto de partidos no cumple la condición de mayoría      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
comen_no_mayoria(Partidos) :-
    escanos_totales(Partidos,Escanos),
    PRG is Escanos mod 4,
    (
        (PRG == 0,
            write('Si querías un pacto entre esos partidos... parece que se'),
            write('quedan cortos. Prueba dentro de 4 años :)'),nl,!
        );
        (PRG == 1,
            write('No se si lo sabías, pero '),
            write(Escanos),
            write(' es menos que 69 :/.'),nl,!
        );
        (PRG == 2,
            write('No voy ni a intentar pensar si se van a llevar bien... ¡Ni'),
            write('siquiera forman mayoría!'),nl,!
        );
        (PRG == 3,
            write('Antes de mandarme hacer algo inútil ¿Qué tal si haces la '),
            write('suma antes?'),nl,!
        )
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comentario en caso de mayoría absoluta                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
comen_mayoria_absoluta(Partido) :-
    escanos(Partido,Escanos),
    candidato(Partido,Presidente),
    write('Contra todo pronóstico, '),
    write(Presidente),
    write(' lograría la mayoría absoluta con los resultados actuales con '),
    write(Escanos),
    write(' escaños.'),nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comentario si los partidos tienen opción a pacto bidireccional               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
comen_pactos_bidireccionales(Escanos,Partidos) :-
    escanos_totales(Partidos, Escanos),
    (
        (mismo_espectro(Partidos),
            % Los partidos son del mismo espectro politica 
            % (o derecha o izquierda)
            (todos_derecha(Partidos),
                % Los partidos son todos de derechas
                write('Una coalición entre '),
                listar_partidos(Partidos),
                write(' daría paso a un gobierno de derechas en la Asamblea'),
                write(' de Madrid liderado por '),
                quicksort(Partidos,Ordenados),
                cabeza(Ordenados,Lider),
                candidato(Lider,Presidente),
                write(Presidente),
                write(' con un respaldo de '),
                write(Escanos),
                write(' escaños.'),nl
            );
            (todos_derecha(Partidos),
                % Los partidos son todos de izquierdas
                write('Una coalición que podría dar paso a un gobierno del'),
                write(' cambio liderado por'),
                quicksort(Partidos,Ordenados),
                cabeza(Ordenados,Lider),
                candidato(Lider,Presidente),
                write(Presidente),
                write(' con el respaldo de los '),
                write(Escanos),
                write(' escaños de '),
                listar_partidos(Partidos),
                write('.'),nl
            )
        );
        (distinto_espectro(Partidos),
            % Los partidos son de derechas e izquierdas
            listar_partidos(Partidos),
            write(' suman juntos una mayoría mixta de centro derecha y centro'),
            write(' izquierda con '),
            write(Escanos),
            write(' escaños que habilitarían un gobierno liderado por '),
            quicksort(Partidos,Ordenados),
            cabeza(Ordenados,Lider),
            candidato(Lider,Presidente),
            write(Presidente),
            write('.'),nl
        )
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comentario si los partidos pueden optar a pactos unidireccionales            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
comen_pactos_unidireccionales(Partidos) :-
    % Por la forma en la que estan definidas las intenciones de pacto, esto solo
    % puede ocurrir dentro de la izquierda de forma que para simplificar solo se
    % definirán los dialogos de esta situación para la izquierda
    escanos_totales(Partidos, Escanos),
    (   
        (todos_izquierda(Partidos),
            write('Un pacto entre '),
            listar_partidos(Partidos),
            write(' podrían dar paso a un gobierno progresista liderado por '),
            quicksort(Partidos,Ordenados),
            cabeza(Ordenados,Lider),
            candidato(Lider,Presidente),
            write(Presidente),
            write(' con '),
            write(Escanos),
            write(' escaños de respaldo. Sin embargo '),
            candidato(psoe, CPSOE),
            write(CPSOE),
            write(' ha advertido que no tenía intención de pactar con '),
            candidato(up, CUP),
            write(CUP),
            write(' lo que podría bloquear esta posibilidad.'),nl
        );
        (not(todos_izquierda(Partidos)),
            write('Hmmm... Algo falla porque esto no debería de poder ocurrir'),
            write(' según la lógica del vago de mi programador.'),nl
        )
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comentario si los partidos no quieren pactar entre ellos                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
comen_no_pactos(Partidos) :-
    % Esta situación solo se puede dar entre partidos de diferentes espectros 
    % políticos, así que el mensaje se decidirá mediante la diferencia máxima
    % (la distancia en el espectro entre los dos extremos) de los partidos
    max_distancia(Partidos,Dist),
    (
        (Dist == 2, !,
            write('Un poco extraña la combinación de '),
            listar_partidos(Partidos),
            write(', ¿no crees?. Es decir sí, suman mayoría y eso pero...'),
            write('¿No hay nada mejor?'),nl
        );
        (Dist == 3, !,
            write('No me imagino un mundo en el que '),
            listar_partidos(Partidos),
            write('pacten... Prueba otra cosa anda...'),nl
        );
        (Dist == 4, !,
            write('¿Sabes eso de que no hay que beber antes de conducir? '),
            write('Pues aplicate lo mismo para cuando vayas a preguntarme'),
            write(' por la posibilidad de un pacto.'),nl
        );
        (Dist == 5, !,
            write('Tú fumas crack'),nl
        )
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comentario por si se encuentra un partido que no tiene escaños en la         %
% combinación propuesta                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
comen_sin_escanos(P) :-
    write('No creo que nadie vaya a pactar con un partido sin escaños como '),
    nombre(P,N),
    write(N),
    write('.'),nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comentario por si se encuentra un partido repetido en un grupo de partidos   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
comen_repe(P) :-
    write('Por mucho que te guste '),
    nombre(P,N),
    write(N),
    write(', no va a tener más escaños de los que tiene.'),nl.
