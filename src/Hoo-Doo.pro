/* -*- Mode:Prolog; coding:iso-8859-1; -*- */


:-include('flat_2D_convert.pro').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Hoo-Doo Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

applyConstraints(FlatBoard,Side,UseTransparent):-
        
        %apply domain constraints
        (UseTransparent = 0,!,domain(FlatBoard,1,Side);domain(FlatBoard,0,Side)),
        inflate(Inflated, FlatBoard,Side),
        applyLineConstraints(Inflated).
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Line Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
applyLineConstraints([BoardHead|BoardTail]):-
        all_distinct(BoardHead),
        applyLineConstraints(BoardTail).

applyLineConstraints([LastLine]):-
        all_distinct(LastLine).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Columns
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getColumn(Board,Col,ColNr):-
        getColumn(Board,Col,ColNr,[]).

getColumn([BoardHead|BoardTail],Col,ColNr,Tmp):-
        nth0(ColNr,BoardHead,Elem),
        append(Tmp,[Elem],NewTmp),
        getColumn(BoardTail,Col,ColNr,NewTmp).
getColumn([],Col,_,Tmp):-
        Col = Tmp.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Column Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


applyColumnConstraints(Board,Side):-
        applyColumnConstraints(Board,Side,0).

applyColumnConstraints(Board,Side,Nr):-
        Nr<Side,
        getColumn(Board,Col,Nr),
        all_distinct(Col),
        NewNr is Nr+1,
        applyColumnConstraints(Board,Side,NewNr).
applyColumnConstraints(_,Side,Side).
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find l Diagonal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getLDiagonal(Side,FlatBoard,Diagonal,DiagonalNr):-
        FirstPos is
        getDiagonal(Side,FlatBoard,Diagonal,DiagonalNr,[],FirstPos).

getDiagonal(Side,Board,Diagonal,DiagonalNr,Tmp,CurrentPos):-
        NewPos 
        
        
