/* -*- Mode:Prolog; coding:iso-8859-1; -*- */


:-use_module(library(clpfd)).


%second parameter is to use dont care or not to use it
custom_all_distinct(List,0,_):-
        all_distinct(List).
        


custom_all_distinct([ListHead|Tail],1,DontCareValue):-
        apply_all_distinct_constraints([ListHead|Tail],1,DontCareValue),
        !,
        custom_all_distinct(Tail,1,DontCareValue).

custom_all_distinct([],1,_).



apply_all_distinct_constraints([ListHead,ListTailHead|ListTail],1,DontCareValue):-
        ((ListHead #\= ListTailHead) #\/ (ListHead#=DontCareValue)),
        !,
        apply_all_distinct_constraints([ListHead|ListTail],1,DontCareValue).

apply_all_distinct_constraints([_],1,_).
        
        