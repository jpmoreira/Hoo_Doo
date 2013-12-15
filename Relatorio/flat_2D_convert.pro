/* -*- Mode:Prolog; coding:iso-8859-1; -*- */

:-use_module(library(clpfd)).
:-use_module(library(lists)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creates a 2D board from a flat list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

inflate(Bidimentional,Flatten,NrLines,NrColumns):-
        inflate(Bidimentional,Flatten,[],NrLines,NrColumns,0).


inflate(B,_,Tmp,NrLines,_,LineNr):-
        LineNr = NrLines,
        B=Tmp.

inflate(B,F,Tmp,NrLines,NrColumns,LineNr):-
        LineNr<NrLines,
        generateLine(F,Line,LineNr,NrColumns),
        append(Tmp,[Line],NewTmp),
        NewLineNr is LineNr+1,
        !,
        inflate(B,F,NewTmp,NrLines,NrColumns,NewLineNr).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Makes a 2D list a Flat one%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flat(Bidimentional,Flat,NrLines):-
        flat(Bidimentional,Flat,[],NrLines,0).

flat(_,F,Tmp,NrLines,LineNr):-
        LineNr=NrLines,
        F=Tmp.
        
flat(B,F,Tmp,NrLines,LineNr):-
        LineNr<NrLines,
        Pos is LineNr +1,
        nth1(Pos,B,Line),%not zero based
        append(Tmp,Line,NewTmp),
        NewLineNr is LineNr +1,
        !,flat(B,F,NewTmp,NrLines,NewLineNr).
        




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts Line in a given postion from a flat board%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
generateLine(FlatBoard,Line,LineNr,LineLength):-
        generateLine(FlatBoard,Line,LineNr,LineLength,[],0).

generateLine(FlatBoard,Line,LineNr,LineLength,Tmp,Pos):-
        Pos<LineLength,
        PositionInBoard is LineLength*LineNr+Pos+1,%+1 because is not zero based
        element(PositionInBoard, FlatBoard, Elem),
        append(Tmp,[Elem],NewTmp),
        NewPos is Pos+1,
        !,generateLine(FlatBoard,Line,LineNr,LineLength,NewTmp,NewPos).

generateLine(_,Line,_,LineLength,Tmp,Pos):-
        Pos is LineLength,
        Line =Tmp.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

