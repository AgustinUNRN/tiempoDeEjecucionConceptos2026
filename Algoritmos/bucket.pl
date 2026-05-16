:- use_module(library(apply)).
:- initialization(main).

% Leer CSV
read_values_file(File, Nums) :-
  open(File, read, S),
  read_line_to_codes(S, Codes), close(S),
  string_codes(Str, Codes),
  ( sub_string(Str,0,1,_, "\"") -> sub_string(Str,1,_,1,Inner), ValuesStr=Inner ; ValuesStr=Str ),
  split_string(ValuesStr, ",", " ", Strs), maplist(number_string, Nums, Strs).

% Inicializar un "arreglo" O(1) de baldes vacíos
init_array(Array, N) :-
  functor(Array, buckets, N),
  fill_array(Array, 1, N).

fill_array(Array, I, N) :-
  I =< N, !,
  setarg(I, Array, []),
  I1 is I + 1,
  fill_array(Array, I1, N).
fill_array(_, _, _).

% Extraer los baldes del arreglo a una lista
array_to_list(Array, I, N, [B|Bs]) :-
  I =< N, !,
  arg(I, Array, B),
  I1 is I + 1,
  array_to_list(Array, I1, N, Bs).
array_to_list(_, _, _, []).

% Bucket Sort principal
bucket_sort(List, Sorted) :-
  ( List = [] -> Sorted = [] ;
    min_list(List, Min), max_list(List, Max), Range is Max - Min + 1,
    length(List, Len), BucketsCount is max(1, min(Len, Range)),
    init_array(Array, BucketsCount),
    distribute(List, Min, Max, BucketsCount, Array),
    array_to_list(Array, 1, BucketsCount, BucketsFilled),
    maplist(insertion_sort, BucketsFilled, SortedBuckets), 
    flatten(SortedBuckets, Sorted)
  ).

% Distribución O(1) usando mutación in-place (setarg)
distribute([], _, _, _, _).
distribute([H|T], Min, Max, BucketsCount, Array) :-
  Range is Max - Min + 1,
  ( Range =:= 0 -> Idx0 = 0 ; Idx0 is ((H - Min) * (BucketsCount - 1)) // max(1, Range - 1) ),
  Idx is Idx0 + 1, % Prolog arg/3 usa índices basados en 1
  arg(Idx, Array, Old),
  NewBucket = [H|Old],
  setarg(Idx, Array, NewBucket),
  distribute(T, Min, Max, BucketsCount, Array).

% Insertion Sort para los baldes
insertion_sort(List, Sorted) :- insertion_sort(List, [], Sorted).
insertion_sort([],Acc,Acc).
insertion_sort([H|T],Acc,Sorted) :- insert_sorted(H,Acc,Acc2), insertion_sort(T,Acc2,Sorted).
insert_sorted(X,[],[X]).
insert_sorted(X,[H|T],[X,H|T]) :- X =< H, !.
insert_sorted(X,[H|T],[H|R]) :- insert_sorted(X,T,R).

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
  time_ms(bucket_sort(Base, _), Time),
  format(string(FName), "Reportes/bucket_prolog_~d.txt", [N]),
  open(FName, write, Out),
  format(Out, "Algoritmo: bucket~nLenguaje: prolog~nTamaño del archivo: ~d~nTiempo (ms): ~d~n", [N, Time]),
  close(Out), halt.