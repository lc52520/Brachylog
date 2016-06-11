/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
____            ____
\   \          /   /
 \   \  ____  /   /
  \   \/    \/   /
   \     /\     /     BRACHYLOG       
    \   /  \   /      A terse declarative logic programming language
    /   \  /   \    
   /     \/     \     Written by Julien Cumin - 2016
  /   /\____/\   \    https://github.com/JCumin/Brachylog
 /   /  ___   \   \
/___/  /__/    \___\
     
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */


:- module(utils, [integer_value/2,
                  brachylog_prolog_variable/2,
                  length_/2,
                  prepend_string/2
                 ]).

:- use_module(library(clpfd)).
    
    
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   INTEGER_VALUE
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
integer_value('integer':Sign:I,E) :-
    integer_value('integer':Sign:I,0,E,E).

integer_value('integer':Sign:[],N0,N,_) :-
    (
        Sign = 'positive',
        N #= N0
        ;
        Sign = 'negative',
        N #= - N0
    ).
integer_value('integer':Sign:[H],N0,N,M) :-
    H in 0..9,
    N1 #= H + N0 * 10,
    abs(M) #>= abs(N1),
    integer_value('integer':Sign:[],N1,N,M).
integer_value('integer':Sign:[H,I|T],N0,N,M) :-
    H in 0..9,
    N1 #= H + N0 * 10,
    abs(M) #>= abs(N1),
    integer_value('integer':Sign:[I|T],N1,N,M).
    

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   BRACHYLOG_PROLOG_VARIABLE
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
brachylog_prolog_variable('integer':I,I) :- !.
brachylog_prolog_variable('float':F,F) :- !.
brachylog_prolog_variable('string':S,String) :- !,
    escape_string_list(S,T),
    atomic_list_concat(T,U),
    atomic_list_concat(['"',U,'"'],A),
    term_to_atom(String,A).
brachylog_prolog_variable(List,PrologList) :-
    is_list(List),
    maplist(brachylog_prolog_variable,List,PrologList).
    
escape_string_list([],[]).
escape_string_list(['"'|T],['\\','"'|T2]) :-
    escape_string_list(T,T2).
escape_string_list(['\\'|T],['\\','\\'|T2]) :-
    escape_string_list(T,T2).
escape_string_list([H|T],[H|T2]) :-
    H \= '"',
    H \= '\\',
    escape_string_list(T,T2).

    
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   LENGTH_
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
length_(Length,List) :-
    length(List,Length).
   
   
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   PREPEND_STRING
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
prepend_string(S,'string':S).
