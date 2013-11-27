/* -*- Mode:Prolog; coding:iso-8859-1; -*- */

:-use_module(library(clpfd)).
:-use_module(library(lists)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creates a 2D board from a flat list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inflate(Bidimentional,Flatten,Side):-
        inflate(Bidimentional,Flatten,[],Side,0).


inflate(B,_,Tmp,Side,LineNr):-
        LineNr = Side,
        B=Tmp.

inflate(B,F,Tmp,Side,LineNr):-
        LineNr<Side,
        generateLine(F,Line,LineNr,Side),
        append(Tmp,[Line],NewTmp),
        NewLineNr is LineNr+1,
        !,
        inflate(B,F,NewTmp,Side,NewLineNr).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Makes a 2D list a Flat one%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flat(Bidimentional,Flat,Side):-
        flat(Bidimentional,Flat,[],Side,0).

flat(_,F,Tmp,Side,LineNr):-
        LineNr=Side,
        F=Tmp.
        
flat(B,F,Tmp,Side,LineNr):-
        LineNr<Side,
        Pos is LineNr +1,
        nth1(Pos,B,Line),%not zero based
        append(Tmp,Line,NewTmp),
        NewLineNr is LineNr +1,
        !,flat(B,F,NewTmp,Side,NewLineNr).
        

testFlat(F):-
        Bl = [[A,B],[C,D]],
        flat(Bl,F,2),
        A is 2,
        write(Bl).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts Line in a given postion from a flat board%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
generateLine(FlatBoard,Line,LineNr,Side):-
        generateLine(FlatBoard,Line,LineNr,Side,[],0).

generateLine(FlatBoard,Line,LineNr,Side,Tmp,Pos):-
        Pos<Side,
        PositionInBoard is Side*LineNr+Pos+1,%+1 because is not zero based
        element(PositionInBoard, FlatBoard, Elem),
        append(Tmp,[Elem],NewTmp),
        NewPos is Pos+1,
        !,generateLine(FlatBoard,Line,LineNr,Side,NewTmp,NewPos).

generateLine(_,Line,_,Side,Tmp,Pos):-
        Pos is Side,
        Line =Tmp.
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

