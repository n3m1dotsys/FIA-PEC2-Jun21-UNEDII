%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   main.pl   -   Programa a ejecutar
%
% author: Martín "n3m1.sys" Romera Sobrado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- [partidos, pactos].

main :-
    % Solicitamos los escaños que ha obtenido cada partido en las elecciones
    pedir_escanos(up),
    pedir_escanos(mm),
    pedir_escanos(psoe),
    pedir_escanos(cs),
    pedir_escanos(pp),
    pedir_escanos(vox).

    
