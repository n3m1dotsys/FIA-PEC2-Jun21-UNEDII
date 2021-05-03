%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   pactos.pl   -   El pactometro 3.0 (Tiembla Ferreras).
%
% author: Martín "n3m1.sys" Romera Sobrado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- [partidos].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reglas sobre pactos. Estas reglas se basan en las intenciones de pactos de   %
% los partidos según lo que han dicho en los medios                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pactaria_con(up,up).
pactaria_con(up,mm).
pactaria_con(up,psoe).
pactaria_con(mm,mm).
pactaria_con(mm,up).
pactaria_con(mm,psoe).
pactaria_con(psoe,psoe).
pactaria_con(psoe,mm).
pactaria_con(psoe,cs).
pactaria_con(cs,cs).
pactaria_con(cs,psoe).
pactaria_con(cs,pp).
pactaria_con(cs,vox).
pactaria_con(pp,pp).
pactaria_con(pp,cs).
pactaria_con(pp,vox).
pactaria_con(vox,vox).
pactaria_con(vox,cs).
pactaria_con(vox,pp).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Definición de mayoría parlamentaria para hacer posible un pacto              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Los partidos de X forman una mayoría (la mitad más 1) de los escaños, es decir
% si los partidos de X conforman al menos 70 escaños
mayoria(Partidos) :- 
    escanos_totales(Partidos, S),
    S >= 69.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Valoriación de un pacto                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
valorar_pacto(Ps) :-
    eliminar_repes(Ps, Parts),
    eliminar_sin_escanos(Parts, Partidos),
    (
        mayoria(Partidos),
        (
            (  
                % Solo hay un partido en el pacto
                solo_uno(Partidos),!,
                comen_mayoria_absoluta(Partidos)
            );
            (
                % Todos los partidos quieren pactar entre si 
                not(solo_uno(Partidos)),
                pactos_bidireccionales(Partidos),!,
                comen_pactos_bidireccionales(Partidos)
            );(
                % Algunos partidos no quieren pactar con otros que a su vez quieren
                % pactar con ellos
                not(solo_uno(Partidos)),
                not(pactos_bidireccionales(Partidos)),
                pactos_unidireccionales(Partidos),!,
                comen_pactos_unidireccionales(Partidos)
            );(
                % Hay partidos que no quieren votar entre ellos
                not(solo_uno(Partidos)),
                not(pactos_bidireccionales(Partidos)),
                not(pactos_unidireccionales(Partidos)),!,
                comen_no_pactos(Partidos)
            )
        );
        % No cumplen la condición de mayoria
        not(mayoria(Partidos)),
        comen_no_mayoria(Partidos)
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluación de cantidad de partidos en una agrupación                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
solo_uno([_|[]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluación de intención de pacto                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pactos_bidireccionales(Partidos) :-
    forall(member(X,Partidos),pacta_resto(X,Partidos)).

pacta_resto(X,Partidos) :-
    forall(member(Y,Partidos),pactaria_con(X,Y)).

pactos_unidireccionales(Partidos) :-
    forall(member(X,Partidos),pacta_uniresto(X,Partidos)).

pacta_uniresto(X,Partidos) :-
    forall(member(Y,Partidos),pacta_alguien(X,Y)).

pacta_alguien(X,Y) :-
    pactaria_con(X,Y);
    pactaria_con(Y,X).