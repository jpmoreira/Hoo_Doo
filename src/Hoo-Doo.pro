/* -*- Mode:Prolog; coding:iso-8859-1; -*- */


:-include('flat_2D_convert.pro').



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Hoo-Doo Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

applyConstraints(FlatBoard,Side,UseTransparent):-
        
        %apply domain constraints
        (UseTransparent = 0,!,domain(FlatBoard,1,Side);domain(FlatBoard,0,Side)),
        applyLineConstraints(FlatBoard,Side).
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Line Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
applyLineConstraints(Board,Side):-
        applyLineConstraints(Board,Side,0).

applyLineConstraints(Board,Side,CurrentLine):-
        ActualLineNumber is CurrenwtLine+1.


test(X,B):-
        domain(X,1,3),
        element(1,X,First),
        element(2,X,Second),
        element(3,X,Third),
        NewX = [[First,Second],Third],
        nth1(1,NewX,B).
        
                
