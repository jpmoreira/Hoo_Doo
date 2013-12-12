/* -*- Mode:Prolog; coding:iso-8859-1; -*- */



%%%%%3x3 [[a,b,c],[d,e,f],[g,h,i]]
%%%%%4X4 [[1,a,c,v],[,e,3,4,5],[,a,s,d,y],[l,k,j,h]]

:-include('flat_2D_convert.pro').



solve(SolvedBoard,Side,Transparent):-
        DesiredSize is Side*Side,
        generateFlatList(Board,DesiredSize),
        applyConstraints(Board,Side,Transparent),
        labeling([], Board),
        SolvedBoard=Board.


solve2(SolvedBoard,NrLines,NrColumns,TransparentMode):-
        DesiredSize is NrLines*NrColumns+1,%plus one for the Transparent
        generateFlatList(Board,DesiredSize),
        applyConstraints2(Board,NrLines,NrColumns,TransparentMode),
        labeling([], Board),
        SolvedBoard=Board.

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Generate List
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
generateFlatList(Board,DesiredSize):-
        Index is 0,
        generateFlatListAux(DesiredSize, Index, [], Board).
        
        
generateFlatListAux(DesiredSize, DesiredSize, Board, Board).

generateFlatListAux(DesiredSize, Index, Progress, Board):-
                append(Progress, [_], Nprogress),
                Next_index is Index+1,
                generateFlatListAux(DesiredSize,Next_index, Nprogress, Board).
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Hoo-Doo Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

applyConstraints(FlatBoard,Side,UseTransparent):-
        
        %apply domain constraints
        (UseTransparent = 0,!,domain(FlatBoard,1,Side);domain(FlatBoard,0,Side)),
        inflate(Inflated, FlatBoard,Side),
        applyLineConstraints(Inflated),
        applyColumnConstraints(Inflated,Side),
        applyDiagonalConstraints(Inflated,Side).
  

applyConstraints2(FlatBoard,NrLines,NrColumns,UseTransparent):-
        maxMember(UpperValue,[NrColumns,NrLines]),
        %apply domain constraints
        (UseTransparent = 0,!,domain(FlatBoard,1,UpperValue);domain(FlatBoard,0,UpperValue)),
        inflate(Inflated, FlatBoard,NrLines,NrColumns),
        applyLineConstraints(Inflated),
        applyColumnConstraints(Inflated,NrColumns),
        applyDiagonalConstraints2(Inflated,NrLines,NrColumns).

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Line Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
applyLineConstraints([BoardHead|BoardTail]):-
        all_distinct(BoardHead),
        !,
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
        !,
        getColumn(BoardTail,Col,ColNr,NewTmp).
getColumn([],Col,_,Tmp):-
        Col = Tmp.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply Column Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


applyColumnConstraints(Board,NrColumns):-
        applyColumnConstraints(Board,NrColumns,0).

applyColumnConstraints(Board,NrColumns,Nr):-
        Nr<NrColumns,
        getColumn(Board,Col,Nr),
        all_distinct(Col),
        NewNr is Nr+1,
        !,
        applyColumnConstraints(Board,NrColumns,NewNr).
applyColumnConstraints(_,NrColumns,NrColumns).


        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find l Diagonal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getlDiagonalStartingPosition(Side,DiagonalNr,Line,Col):-
        (DiagonalNr>=Side, Pos is (DiagonalNr mod Side)+1;Pos is (Side-DiagonalNr-1)*Side),
        Line is Pos // Side,
        Col is  Pos mod Side,
        !.


getLDiagonal(Side,Board,Diagonal,DiagonalNr):-
        getlDiagonalStartingPosition(Side,DiagonalNr,Line,Col),
        !,
        getLDiagonal(Side,Board,Diagonal,DiagonalNr,[],Line,Col).

getLDiagonal(Side,Board,Diagonal,DiagonalNr,Tmp,CurrentLine,CurrentCol):-
        CurrentLine<Side,CurrentCol<Side,
        CurrentLine>=0,CurrentCol>=0,
        NewCol is CurrentCol+1,
        NewLine is CurrentLine+1,
        nth0(CurrentLine,Board,Line),
        nth0(CurrentCol,Line,Elem),
        append(Tmp,[Elem],NewTmp),
        !,
        getLDiagonal(Side,Board,Diagonal,DiagonalNr,NewTmp,NewLine,NewCol).
getLDiagonal(Side,_,Diagonal,_,Tmp,CurrentCol,CurrentLine):-
        (CurrentCol>=Side;CurrentLine>=Side),
        !,
        Diagonal=Tmp.
        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find r Diagonal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
getrDiagonalStartingPosition(Side,DiagonalNr,Line,Col):-
        (DiagonalNr<Side,Pos=DiagonalNr;DiagonalNr>=Side,Pos is (DiagonalNr-Side+2)*Side-1),
        Line is Pos // Side,
        Col is  Pos mod Side,
        !.
        
getRDiagonal(Side,Board,Diagonal,DiagonalNr):-
        getrDiagonalStartingPosition(Side,DiagonalNr,StartingLine,StartingCol),
        getRDiagonal(Side,Board,Diagonal,DiagonalNr,[],StartingLine,StartingCol).

getRDiagonal(Side,Board,Diagonal,DiagonalNr,Tmp,CurrentLine,CurrentCol):-
        CurrentLine<Side,CurrentCol<Side,
        CurrentLine>=0,CurrentCol>=0,
        NewLine is CurrentLine+1,
        NewCol is CurrentCol-1,
        nth0(CurrentLine,Board,Line),
        nth0(CurrentCol,Line,Elem),
        append(Tmp,[Elem],NewTmp),
        !,
        getRDiagonal(Side,Board,Diagonal,DiagonalNr,NewTmp,NewLine,NewCol).
getRDiagonal(Side,_,Diagonal,_,Tmp,CurrentLine,CurrentCol):-
        (CurrentLine<0;CurrentCol<0;CurrentLine>=Side;CurrentCol>=Side),
        !,
        Diagonal=Tmp.



getRDiagonal2(NrLines,NrColumns,Board,Diagonal,DiagonalNr):-
        max_member(Max, [NrLines,NrColumns]),
        getrDiagonalStartingPosition(Max,DiagonalNr,StartingLine,StartingCol),
        getRDiagonal2(NrLines,NrColumns,Board,Diagonal,DiagonalNr,[],StartingLine,StartingCol).

getRDiagonal2(NrLines,NrColumns,_,Diagonal,_,Tmp,CurrentLine,CurrentCol):-
        max_member(Max,[NrLines,NrColumns]),
        (CurrentLine<0;CurrentCol<0;CurrentLine>=Max;CurrentCol>=Max),
        !,
        Diagonal=Tmp.

getRDiagonal2(NrLines,NrColumns,Board,Diagonal,DiagonalNr,Tmp,CurrentLine,CurrentCol):-
        CurrentLine<NrLines,CurrentCol<NrColumns,
        CurrentLine>=0,CurrentCol>=0,
        NewLine is CurrentLine+1,
        NewCol is CurrentCol-1,
        nth0(CurrentLine,Board,Line),
        nth0(CurrentCol,Line,Elem),
        append(Tmp,[Elem],NewTmp),
        !,
        getRDiagonal2(NrLines,NrColumns,Board,Diagonal,DiagonalNr,NewTmp,NewLine,NewCol).

getRDiagonal2(NrLines,NrColumns,Board,Diagonal,DiagonalNr,Tmp,CurrentLine,CurrentCol):-
        NewLine is CurrentLine+1,
        NewCol is CurrentCol-1,
        !,
        getRDiagonal2(NrLines,NrColumns,Board,Diagonal,DiagonalNr,Tmp,NewLine,NewCol).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Apply Diagonal Constraints
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


applyDiagonalConstraints(Board,Side):-
        applyRDiagonalConstraints(Board,Side,1),
        applyLDiagonalConstraints(Board,Side,1).


applyRDiagonalConstraints(Board,Side,DiagonalNr):-
        DiagonalNr<2*Side-2,
        NextDiagonalNr is DiagonalNr +1,
        getRDiagonal(Side,Board,Diagonal,DiagonalNr),
        all_distinct(Diagonal),
        !,
        applyRDiagonalConstraints(Board,Side,NextDiagonalNr).
applyRDiagonalConstraints(_,Side,DiagonalNr):-
        DiagonalNr>=2*Side-2.


applyLDiagonalConstraints(Board,Side,DiagonalNr):-
        DiagonalNr<2*Side-2,
        NextDiagonalNr is DiagonalNr +1,
        getLDiagonal(Side,Board,Diagonal,DiagonalNr),
        all_distinct(Diagonal),
        !,
        applyRDiagonalConstraints(Board,Side,NextDiagonalNr).
applyLDiagonalConstraints(_,Side,DiagonalNr):-
        DiagonalNr>=2*Side-2.


%       TODO non square version!!!!!!