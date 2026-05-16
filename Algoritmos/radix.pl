:- use_module(library(apply)).
:- initialization(main).

% Leer CSV
read_values_file(File, Nums) :-
  open(File, read, S),
  read_line_to_codes(S, Codes), close(S),
  string_codes(Str, Codes),
  ( sub_string(Str,0,1,_, "\"") -> sub_string(Str,1,_,1,Inner), ValuesStr=Inner ; ValuesStr=Str ),
  split_string(ValuesStr, ",", " ", Strs), maplist(number_string, Nums, Strs).

% Inicializar un "arreglo" O(1) de 10 posiciones
init_array(Array, N) :-
  functor(Array, buckets, N),
  fill_array(Array, 1, N).

fill_array(Array, I, N) :-
  I =< N, !,
  setarg(I, Array, []),
  I1 is I + 1,
  fill_array(Array, I1, N).
fill_array(_, _, _).

% Extraer e INVERTIR los baldes para garantizar el orden estable de Radix
array_to_list_rev(Array, I, N, [BRev|Bs]) :-
  I =< N, !,
  arg(I, Array, B),
  reverse(B, BRev), % La reversión mantiene la estabilidad matemática
  I1 is I + 1,
  array_to_list_rev(Array, I1, N, Bs).
array_to_list_rev(_, _, _, []).

% Radix Sort principal
radix_sort(List,Sorted) :-
  ( List = [] -> Sorted = [] ; max_list(List, Max), radix_loop(List, 1, Max, Sorted) ).

radix_loop(L, Exp, Max, L) :- Exp > Max, !.
radix_loop(L, Exp, Max, Sorted) :-
  init_array(Array, 10), 
  distribute_digits(L, Exp, Array), 
  array_to_list_rev(Array, 1, 10, Bs), 
  flatten(Bs, L2),
  Exp1 is Exp * 10, 
  radix_loop(L2, Exp1, Max, Sorted).

% Distribución O(1) in-place según el dígito
distribute_digits([], _, _).
distribute_digits([H|T], Exp, Array) :-
  D is (H // Exp) mod 10,
  Idx is D + 1, % Prolog arg/3 usa índices basados en 1
  arg(Idx, Array, Old), 
  NewBucket = [H|Old], 
  setarg(Idx, Array, NewBucket),
  distribute_digits(T, Exp, Array).

% Medición de tiempo
time_ms(Goal, MS) :-
  statistics(walltime, [Start|_]),
  call(Goal),
  statistics(walltime, [End|_]),
  MS is End - Start.

main :-
  current_prolog_flag(argv, ArgV),
  ( ArgV = [File|_] -> Input = File ; halt(1) ),
  read_values_file(Input, Base), length(Base, N),
  time_ms(radix_sort(Base, _), Time),
  format(string(FName), "Reportes/radix_prolog_~d.txt", [N]),
  open(FName, write, Out),
  format(Out, "Algoritmo: radix~nLenguaje: prolog~nTamaño del archivo: ~d~nTiempo (ms): ~d~n", [N, Time]),
  close(Out), halt.